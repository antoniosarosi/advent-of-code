const std = @import("std");

const ParseError = error{
    InvalidOponentEncoding,
    InvalidPlayerEncoding,
};

const Shape = enum(usize) {
    rock = 1,
    paper = 2,
    scissors = 3,

    const Self = @This();

    pub fn fromOponentEncoding(encoded: u8) ParseError!Self {
        return switch (encoded) {
            'A' => .rock,
            'B' => .paper,
            'C' => .scissors,
            else => error.InvalidOponentEncoding,
        };
    }

    pub fn fromPlayerEncoding(encoded: u8) ParseError!Self {
        return switch (encoded) {
            'X' => .rock,
            'Y' => .paper,
            'Z' => .scissors,
            else => error.InvalidPlayerEncoding,
        };
    }

    pub fn resultAgainst(self: Self, oponent: Self) RoundResult {
        return switch (self) {
            .rock => switch (oponent) {
                .rock => .draw,
                .paper => .loss,
                .scissors => .win,
            },

            .paper => switch (oponent) {
                .rock => .win,
                .paper => .draw,
                .scissors => .loss,
            },

            .scissors => switch (oponent) {
                .rock => .loss,
                .paper => .win,
                .scissors => .draw,
            },
        };
    }

    pub fn calculateRoundPoints(self: Self, oponent: Shape) usize {
        return @intFromEnum(self) + @intFromEnum(self.resultAgainst(oponent));
    }
};

const RoundResult = enum(usize) {
    loss = 0,
    draw = 3,
    win = 6,

    const Self = @This();

    pub fn fromPlayerEncoding(encoded: u8) ParseError!Self {
        return switch (encoded) {
            'X' => .loss,
            'Y' => .draw,
            'Z' => .win,
            else => error.InvalidPlayerEncoding,
        };
    }

    pub fn necessaryShapeAgainst(self: Self, oponent: Shape) Shape {
        return switch (self) {
            .loss => switch (oponent) {
                .rock => .scissors,
                .paper => .rock,
                .scissors => .paper,
            },

            .win => switch (oponent) {
                .rock => .paper,
                .paper => .scissors,
                .scissors => .rock,
            },

            .draw => oponent,
        };
    }

    pub fn calculateRoundPoints(self: Self, oponent: Shape) usize {
        return @intFromEnum(self) + @intFromEnum(self.necessaryShapeAgainst(oponent));
    }
};

fn Round(comptime T: type) type {
    return struct {
        oponent: Shape,
        player: T,

        const Self = @This();

        pub fn calculatePoints(self: Self) usize {
            return self.player.calculateRoundPoints(self.oponent);
        }
    };
}

fn parse(comptime T: type, input: []const u8, allocator: std.mem.Allocator) !std.ArrayList(Round(T)) {
    var game = std.ArrayList(Round(T)).init(allocator);
    var lines = std.mem.split(u8, std.mem.trim(u8, input, " \n"), "\n");
    while (lines.next()) |line| {
        const oponent = try Shape.fromOponentEncoding(line[0]);
        const player = try T.fromPlayerEncoding(line[2]);
        try game.append(.{ .oponent = oponent, .player = player });
    }

    return game;
}

fn playGame(comptime T: type, game: *const std.ArrayList(Round(T))) usize {
    var sum: usize = 0;
    for (game.items) |round| {
        sum += round.calculatePoints();
    }

    return sum;
}

pub fn solution(input: []const u8, allocator: std.mem.Allocator) !struct { []u8, []u8 } {
    const part1 = try parse(Shape, input, allocator);
    defer part1.deinit();

    const part2 = try parse(RoundResult, input, allocator);
    defer part2.deinit();

    return .{
        try std.fmt.allocPrint(allocator, "{}", .{playGame(Shape, &part1)}),
        try std.fmt.allocPrint(allocator, "{}", .{playGame(RoundResult, &part2)}),
    };
}
