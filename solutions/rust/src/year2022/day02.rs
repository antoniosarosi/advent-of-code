#[derive(Clone, Copy)]
enum RoundResult {
    LOSS = 0,
    DRAW = 3,
    WIN = 6,
}

#[derive(Clone, Copy)]
enum Shape {
    ROCK = 1,
    PAPER = 2,
    SCISSORS = 3,
}

trait FromPlayerEncoding {
    fn from_player_encoding(encoded: &str) -> Self;
}

trait ComputeRoundPoints {
    fn compute_round_points(&self, oponent: &Shape) -> i32;
}

impl Shape {
    fn from_oponent_encodig(encoded: &str) -> Self {
        match encoded {
            "A" => Self::ROCK,
            "B" => Self::PAPER,
            "C" => Self::SCISSORS,
            _ => panic!("Unexpected oponent shape: '{encoded}'"),
        }
    }

    fn result_against(&self, oponent: &Self) -> RoundResult {
        use Shape::*;

        match (self, oponent) {
            (ROCK, SCISSORS) | (PAPER, ROCK) | (SCISSORS, PAPER) => RoundResult::WIN,

            (SCISSORS, ROCK) | (PAPER, SCISSORS) | (ROCK, PAPER) => RoundResult::LOSS,

            _ => RoundResult::DRAW,
        }
    }
}

impl RoundResult {
    fn necessary_shape_against(&self, oponent: &Shape) -> Shape {
        use {RoundResult::*, Shape::*};

        match (self, oponent) {
            (LOSS, PAPER) | (DRAW, ROCK) | (WIN, SCISSORS) => Shape::ROCK,

            (LOSS, SCISSORS) | (DRAW, PAPER) | (WIN, ROCK) => Shape::PAPER,

            _ => Shape::SCISSORS,
        }
    }
}

// Part 1
impl FromPlayerEncoding for Shape {
    fn from_player_encoding(encoded: &str) -> Self {
        match encoded {
            "X" => Self::ROCK,
            "Y" => Self::PAPER,
            "Z" => Self::SCISSORS,
            _ => panic!("Unexpected player shape: '{encoded}'"),
        }
    }
}

impl ComputeRoundPoints for Shape {
    fn compute_round_points(&self, oponent: &Shape) -> i32 {
        *self as i32 + self.result_against(oponent) as i32
    }
}

// Part 2
impl FromPlayerEncoding for RoundResult {
    fn from_player_encoding(encoded: &str) -> Self {
        match encoded {
            "X" => Self::LOSS,
            "Y" => Self::DRAW,
            "Z" => Self::WIN,
            _ => panic!("Unexpected player result: '{encoded}'"),
        }
    }
}

impl ComputeRoundPoints for RoundResult {
    fn compute_round_points(&self, oponent: &Shape) -> i32 {
        *self as i32 + self.necessary_shape_against(oponent) as i32
    }
}

fn parse<P: FromPlayerEncoding>(input: &str) -> Vec<(Shape, P)> {
    let rounds = input.trim().lines().map(|line| {
        let mut split = line.split_whitespace();
        let oponent = Shape::from_oponent_encodig(split.next().unwrap());
        let player = P::from_player_encoding(split.next().unwrap());
        (oponent, player)
    });

    rounds.collect()
}

fn play_game(game: &Vec<(Shape, impl ComputeRoundPoints)>) -> i32 {
    game.iter()
        .map(|(oponent, player)| player.compute_round_points(oponent))
        .sum()
}

pub(crate) fn solution(input: &str) -> (i32, i32) {
    let part1: Vec<(Shape, Shape)> = parse(input);
    let part2: Vec<(Shape, RoundResult)> = parse(input);

    (play_game(&part1), play_game(&part2))
}
