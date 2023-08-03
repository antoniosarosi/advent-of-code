const std = @import("std");
const solutions = @import("solutions.zig");

const MAX_INPUT_BYTES = 1 << 30;

fn fail(comptime format: []const u8, args: anytype) noreturn {
    var stderr = std.io.getStdErr().writer();
    stderr.print(format, args) catch {};

    std.process.exit(1);
}

fn readInputFileAlloc(relative_path: [:0]const u8, allocator: std.mem.Allocator) ![]u8 {
    var buf: [std.fs.MAX_PATH_BYTES]u8 = undefined;
    const absolute_path = try std.fs.realpathZ(relative_path, &buf);

    const file = try std.fs.openFileAbsolute(absolute_path, .{});
    defer file.close();

    return file.readToEndAlloc(allocator, MAX_INPUT_BYTES);
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len < 3 or args.len > 4) {
        fail("Usage: ./executable YEAR DAY [path/to/alternate/input.txt]\n", .{});
    }

    const year = std.fmt.parseInt(u32, args[1], 10) catch |err| {
        fail("Can't parse year '{s}': {}", .{ args[1], err });
    };

    const day = std.fmt.parseInt(u32, args[2], 10) catch |err| {
        fail("Can't parse day '{s}': {}", .{ args[2], err });
    };

    var input_file: [:0]u8 = undefined;

    if (args.len == 4) {
        input_file = args[3];
    } else {
        var buf = std.mem.zeroes([std.fs.MAX_PATH_BYTES:0]u8);
        _ = std.fmt.bufPrint(&buf, "./inputs/{}/day{d:0>2}.txt", .{ year, day }) catch |err| {
            fail("Can't format default input file path: {}", .{err});
        };
        input_file = &buf;
    }

    var solutions_map = try solutions.collectSolutions(allocator);
    defer solutions_map.deinit();

    const key = try std.fmt.allocPrint(allocator, "{}/{d:0>2}", .{ year, day });
    defer allocator.free(key);

    if (!solutions_map.contains(key)) {
        fail("Solution for year {} day {} is not implemented or registered", .{ year, day });
    }

    const solution = solutions_map.get(key).?;

    const input = readInputFileAlloc(input_file, allocator) catch |err| {
        fail("Can't read input file '{s}': {}", .{ input_file, err });
    };
    defer allocator.free(input);

    const output = try solution(input, allocator);
    defer {
        allocator.free(output[0]);
        allocator.free(output[1]);
    }

    var stdout = std.io.getStdOut().writer();
    try stdout.print("{s}\n{s}", .{ output[0], output[1] });
}
