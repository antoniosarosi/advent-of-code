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

fn priority(item: u8) usize {
    comptime var lower_case_shift = 'a' - 1;
    comptime var upper_case_shift = 'A' - 2;
    comptime var letter_count = 'z' - 'a';

    return switch (item) {
        'a'...'z' => item - lower_case_shift,
        'A'...'Z' => item - upper_case_shift + letter_count,
        else => unreachable,
    };
}

fn part1(rucksacks: *const std.ArrayList(std.ArrayList(u8))) usize {
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

fn part2(groups: *const std.ArrayList(Group)) !usize {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();

    var priorities_sum: usize = 0;
    for (groups.items) |group| {
        var buf_size = group[0].items.len;
        inline for (group[1..]) |next_group| {
            if (next_group.items.len > buf_size) {
                buf_size = next_group.items.len;
            }
        }

        var candidates = try allocator.alloc(u8, buf_size * GROUP_SIZE);
        std.mem.copyForwards(u8, candidates[0..buf_size], group[0].items);

        for (group[1..], 1..GROUP_SIZE) |rucksack, i| {
            var prev = (i - 1) * buf_size;
            var current = i * buf_size;
            var next = current + buf_size;
            @memset(candidates[current..next], 0);

            var j: usize = 0;
            for (rucksack.items) |item| {
                for (candidates[prev..current]) |candidate| search: {
                    if (item == candidate) {
                        while (candidates[current + j] != 0) {
                            if (candidates[current + j] == item) {
                                break :search;
                            } else {
                                j += 1;
                            }
                        }
                        candidates[current + j] = item;
                    } else if (candidate == 0) {
                        break :search;
                    }
                }
            }
        }

        priorities_sum += priority(candidates[buf_size * (GROUP_SIZE - 1)]);
        allocator.free(candidates);
    }

    return priorities_sum;
}

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
        try std.fmt.allocPrint(allocator, "{}", .{part1(&rucksacks_only)}),
        try std.fmt.allocPrint(allocator, "{}", .{try part2(&groups)}),
    };
}
