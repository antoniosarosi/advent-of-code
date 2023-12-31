const std = @import("std");

const GROUP_SIZE = 3;
const Group = [GROUP_SIZE]std.ArrayList(u8);

fn parse(input: []const u8, allocator: std.mem.Allocator) !std.ArrayList(Group) {
    var groups = std.ArrayList(Group).init(allocator);
    var lines = std.mem.split(u8, std.mem.trim(u8, input, " \n"), "\n");

    while (lines.next()) |line| {
        var group = try groups.addOne();
        group[0] = std.ArrayList(u8).init(allocator);
        try group[0].appendSlice(line);

        inline for (1..GROUP_SIZE) |i| {
            group[i] = std.ArrayList(u8).init(allocator);
            try group[i].appendSlice(lines.next().?);
        }
    }

    return groups;
}

/// Constant time, one branch instruction + addition.
///
/// O(1)
fn priority(item: u8) usize {
    const lower_case_shift = 'a' - 1;
    const upper_case_shift = 'A' - 2;
    const letter_count = 'z' - 'a';

    return switch (item) {
        'a'...'z' => item - lower_case_shift,
        'A'...'Z' => item - upper_case_shift + letter_count,
        else => unreachable,
    };
}

/// No hash sets, no additional allocations.
///
/// Time: O(n * (m/2 + (m/2)^2)) ≈ O(n * m^2)
/// Mem:  O(n * m)
fn part1LinearScan(rucksacks: *const std.ArrayList(std.ArrayList(u8))) usize {
    var priorities_sum: usize = 0;

    for (rucksacks.items) |rucksack| {
        const half = rucksack.items.len / 2;
        const first_compartment = rucksack.items[0..half];
        for (rucksack.items[half..]) |item| {
            if (std.mem.indexOfScalar(u8, first_compartment, item) != null) {
                priorities_sum += priority(item);
                break;
            }
        }
    }

    return priorities_sum;
}

/// Uses a hash set instead of searching linearly. One initial allocation is
/// performed to ensure the hash set can contain at least the total number of
/// elements in the first rucksack. Further reallocations might be necessary.
///
/// Time: O(n * m)
/// Mem:  O(n * m + max(m/2)) ≈ O(n * m)
fn part1HashSet(rucksacks: *const std.ArrayList(std.ArrayList(u8))) !usize {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var priorities_sum: usize = 0;

    var first_compartment = std.AutoHashMap(u8, void).init(allocator);
    try first_compartment.ensureTotalCapacity(@intCast(rucksacks.items[0].items.len));
    defer first_compartment.deinit();

    for (rucksacks.items) |rucksack| {
        defer first_compartment.clearRetainingCapacity();
        const half = rucksack.items.len / 2;
        for (rucksack.items[0..half]) |item| {
            try first_compartment.put(item, {});
        }
        for (rucksack.items[half..]) |item| {
            if (first_compartment.contains(item)) {
                priorities_sum += priority(item);
                break;
            }
        }
    }

    return priorities_sum;
}

/// Uses a single buffer to search for duplicates linearly. The maximum buffer
/// size will end up being equal to the the longest rucksack times GROUP_SIZE.
///
/// Time: O(n * g * m^2)
/// Mem:  O(n * g * m + max(m * g)) ≈ O(n * g * m)
fn part2LinearScan(groups: *const std.ArrayList(Group)) !usize {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var candidates = try allocator.alloc(u8, groups.items[0][0].items.len * GROUP_SIZE);
    defer allocator.free(candidates);

    var priorities_sum: usize = 0;
    for (groups.items) |group| {
        var buf_size = group[0].items.len;
        inline for (group[1..]) |next_group| {
            if (next_group.items.len > buf_size) {
                buf_size = next_group.items.len;
            }
        }

        if (buf_size * GROUP_SIZE > candidates.len) {
            candidates = try allocator.realloc(candidates, buf_size * GROUP_SIZE);
        }
        @memcpy(candidates[0..group[0].items.len], group[0].items);
        @memset(candidates[group[0].items.len..], 0);

        for (group[1..], 1..) |rucksack, i| {
            const prev = (i - 1) * buf_size;
            const current = i * buf_size;

            var j: usize = 0;
            for (rucksack.items) |item| {
                for (candidates[prev..current]) |candidate| search: {
                    if (candidate == 0) {
                        break :search;
                    }
                    if (item == candidate) {
                        while (j < buf_size and candidates[current + j] != 0) {
                            if (candidates[current + j] == item) {
                                break :search;
                            } else {
                                j += 1;
                            }
                        }
                        candidates[current + j] = item;
                    }
                }
            }
        }

        priorities_sum += priority(candidates[buf_size * (GROUP_SIZE - 1)]);
    }

    return priorities_sum;
}

/// Uses a couple of hash sets to calculate the set difference in each
/// iteration. By the end of the loop only duplicate items will remain.
///
/// Time: O(n * g * 3m) ≈ O(n * g * m)
/// Mem:  O(n * g * m + 2*max(m)) ≈ O(n * g * m)
fn part2HashSet(groups: *const std.ArrayList(Group)) !usize {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var candidates = std.AutoHashMap(u8, void).init(allocator);
    defer candidates.deinit();

    var current_rucksack = std.AutoHashMap(u8, void).init(allocator);
    defer current_rucksack.deinit();

    var priorities_sum: usize = 0;

    for (groups.items) |group| {
        defer candidates.clearRetainingCapacity();
        try candidates.ensureTotalCapacity(@intCast(group[0].items.len));

        for (group[0].items) |item| {
            try candidates.put(item, {});
        }

        for (group[1..], 1..) |rucksack, i| {
            defer current_rucksack.clearRetainingCapacity();
            try current_rucksack.ensureTotalCapacity(@intCast(rucksack.items.len));

            for (rucksack.items) |item| {
                try current_rucksack.put(item, {});
            }

            for (group[i - 1].items) |item| {
                if (!current_rucksack.contains(item)) {
                    _ = candidates.remove(item);
                }
            }
        }

        var items = candidates.keyIterator();
        priorities_sum += priority(items.next().?.*);
    }

    return priorities_sum;
}

/// Part 1 doesn't say anything about groups.
fn rucksacksWithoutGroups(groups: *const std.ArrayList(Group), allocator: std.mem.Allocator) !std.ArrayList(std.ArrayList(u8)) {
    var rucksacks = std.ArrayList(std.ArrayList(u8)).init(allocator);
    for (groups.items) |group| {
        for (group) |rucksack| {
            try rucksacks.append(rucksack);
        }
    }

    return rucksacks;
}

pub fn solution(input: []const u8, allocator: std.mem.Allocator) !struct { []u8, []u8 } {
    const groups = try parse(input, allocator);

    defer {
        for (groups.items) |group| {
            inline for (group) |rucksack| {
                rucksack.deinit();
            }
        }
        groups.deinit();
    }

    const rucksacks_only = try rucksacksWithoutGroups(&groups, allocator);
    defer rucksacks_only.deinit();

    return .{
        try std.fmt.allocPrint(allocator, "{}", .{try part1HashSet(&rucksacks_only)}),
        try std.fmt.allocPrint(allocator, "{}", .{try part2HashSet(&groups)}),
    };
}
