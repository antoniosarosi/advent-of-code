const std = @import("std");

const RangeInclusive = struct {
    start: isize,
    end: isize,

    const Self = @This();

    pub inline fn contains(self: *const Self, item: isize) bool {
        return self.start <= item and item <= self.end;
    }

    pub inline fn fullyContains(self: *const Self, other: *const Self) bool {
        return other.start >= self.start and other.end <= self.end;
    }

    pub inline fn overlaps(self: *const Self, other: *const Self) bool {
        return other.contains(self.start) or other.contains(self.end);
    }
};

const Pair = struct { RangeInclusive, RangeInclusive };

fn parseRange(input: []const u8) !RangeInclusive {
    var members = std.mem.split(u8, input, "-");
    const start = try std.fmt.parseInt(isize, members.next().?, 10);
    const end = try std.fmt.parseInt(isize, members.next().?, 10);

    return .{
        .start = start,
        .end = end,
    };
}

fn parse(input: []const u8, allocator: std.mem.Allocator) !std.ArrayList(Pair) {
    var pairs = std.ArrayList(Pair).init(allocator);
    var lines = std.mem.split(u8, std.mem.trim(u8, input, " \n"), "\n");

    while (lines.next()) |line| {
        var pair = std.mem.split(u8, line, ",");
        try pairs.append(.{
            try parseRange(pair.next().?),
            try parseRange(pair.next().?),
        });
    }

    return pairs;
}

fn part1(assignments: *const std.ArrayList(Pair)) usize {
    var count: usize = 0;
    for (assignments.items) |pair| {
        if (pair[0].fullyContains(&pair[1]) or pair[1].fullyContains(&pair[0])) {
            count += 1;
        }
    }

    return count;
}

fn part2(assignments: *const std.ArrayList(Pair)) usize {
    var count: usize = 0;
    for (assignments.items) |pair| {
        if (pair[0].overlaps(&pair[1]) or pair[1].overlaps(&pair[0])) {
            count += 1;
        }
    }

    return count;
}

pub fn solution(input: []const u8, allocator: std.mem.Allocator) !struct { []u8, []u8 } {
    const assignments = try parse(input, allocator);

    return .{
        try std.fmt.allocPrint(allocator, "{}", .{part1(&assignments)}),
        try std.fmt.allocPrint(allocator, "{}", .{part2(&assignments)}),
    };
}
