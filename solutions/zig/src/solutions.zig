const std = @import("std");
const year2022 = @import("year2022/year2022.zig");

const Solution = *const fn (input: []const u8, allocator: std.mem.Allocator) anyerror!struct { []u8, []u8 };

pub fn collectSolutions(allocator: std.mem.Allocator) !std.StringHashMap(Solution) {
    var collection = std.StringHashMap(Solution).init(allocator);

    const solutions = [_]struct { *const [7:0]u8, Solution }{
        .{ "2022/01", year2022.day01.solution },
    };

    for (solutions) |solution| {
        try collection.put(solution[0], solution[1]);
    }

    return collection;
}
