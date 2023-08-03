const std = @import("std");
const year2022day01 = @import("year2022/day01.zig");

const Solution = *const fn (input: []const u8, allocator: std.mem.Allocator) error{OutOfMemory}!struct {[]u8, []u8};

pub fn collectSolutions(allocator: std.mem.Allocator) std.StringHashMap(Solution) {
    var collection = std.StringHashMap(Solution).init(allocator);
    collection.put("2022/01", year2022day01.solution) catch {};

    return collection;
}
