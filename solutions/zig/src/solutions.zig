const std = @import("std");
const year2022 = @import("year2022/year2022.zig");

const Solution = *const fn (input: []const u8, allocator: std.mem.Allocator) anyerror!struct { []u8, []u8 };

pub const map = std.ComptimeStringMap(Solution, .{
    .{ "2022/01", year2022.day01.solution },
    .{ "2022/02", year2022.day02.solution },
});
