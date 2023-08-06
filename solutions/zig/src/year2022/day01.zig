const std = @import("std");

fn parseTotalCalories(input: []const u8, allocator: std.mem.Allocator) !std.ArrayList(u32) {
    var elves_iter = std.mem.split(u8, std.mem.trim(u8, input, " \n"), "\n\n");
    var total_calories = std.ArrayList(u32).init(allocator);

    while (elves_iter.next()) |elf| {
        var calories: u32 = 0;
        var calories_iter = std.mem.split(u8, elf, "\n");
        while (calories_iter.next()) |cal| {
            calories += try std.fmt.parseInt(u32, cal, 10);
        }
        try total_calories.append(calories);
    }

    return total_calories;
}

fn part1(calories: *std.ArrayList(u32)) u32 {
    return std.mem.max(u32, calories.items);
}

fn part2(calories: *std.ArrayList(u32)) u32 {
    var top_three = [3]u32{ 0, 0, 0 };
    for (calories.items) |cal| {
        inline for (0..top_three.len) |i| {
            if (cal > top_three[i]) {
                comptime var j: usize = 2;
                inline while (j > 0) : (j -= 1) {
                    top_three[j] = top_three[j - 1];
                }
                top_three[i] = cal;
                break;
            }
        }
    }

    return top_three[0] + top_three[1] + top_three[2];
}

pub fn solution(input: []const u8, allocator: std.mem.Allocator) !struct { []u8, []u8 } {
    var calories = try parseTotalCalories(input, allocator);
    defer calories.deinit();

    return .{
        try std.fmt.allocPrint(allocator, "{}", .{part1(&calories)}),
        try std.fmt.allocPrint(allocator, "{}", .{part2(&calories)}),
    };
}
