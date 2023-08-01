const std = @import("std");

fn fail(comptime format: []const u8, args: anytype) noreturn {
    var stderr = std.io.bufferedWriter(std.io.getStdErr().writer());
    stderr.writer().print(format, args) catch {};
    stderr.flush() catch {};

    std.process.exit(1);
}

fn readInputFileAlloc(relative_path: [:0]const u8, allocator: std.mem.Allocator) ![]u8 {
    var buf: [std.fs.MAX_PATH_BYTES]u8 = undefined;
    const absolute_path = try std.fs.realpathZ(relative_path, &buf);

    const file = try std.fs.openFileAbsolute(absolute_path, .{});
    defer file.close();

    const max_bytes = 1024 * 1024 * 1024;

    return file.readToEndAlloc(allocator, max_bytes);
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

    const input = readInputFileAlloc(input_file, allocator) catch |err| {
        fail("Can't read input file '{s}': {}", .{ input_file, err });
    };
    defer allocator.free(input);

    std.debug.print("{s}", .{input});
}
