const std = @import("std");

pub fn solution(input: []const u8, allocator: std.mem.Allocator) !struct {[]u8, []u8} {
    if (input.len == 1) {}

    return .{
        try std.fmt.allocPrint(allocator, "part1", .{}),
        try std.fmt.allocPrint(allocator, "part2", .{}),
    };
}
