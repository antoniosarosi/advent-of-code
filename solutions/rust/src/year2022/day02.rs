#[derive(Clone, Copy)]
enum RoundResult {
    Loss = 0,
    Draw = 3,
    Win = 6,
}

#[derive(Clone, Copy)]
enum Shape {
    Rock = 1,
    Paper = 2,
    Scissors = 3,
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
            "A" => Self::Rock,
            "B" => Self::Paper,
            "C" => Self::Scissors,
            _ => panic!("Unexpected oponent shape: '{encoded}'"),
        }
    }

    fn result_against(&self, oponent: &Self) -> RoundResult {
        use {RoundResult::*, Shape::*};

        match (self, oponent) {
            (Rock, Scissors) | (Paper, Rock) | (Scissors, Paper) => Win,

            (Scissors, Rock) | (Paper, Scissors) | (Rock, Paper) => Loss,

            _ => Draw,
        }
    }
}

impl RoundResult {
    fn necessary_shape_against(&self, oponent: &Shape) -> Shape {
        use {RoundResult::*, Shape::*};

        match (self, oponent) {
            (Loss, Paper) | (Draw, Rock) | (Win, Scissors) => Rock,

            (Loss, Scissors) | (Draw, Paper) | (Win, Rock) => Paper,

            _ => Scissors,
        }
    }
}

// Part 1
impl FromPlayerEncoding for Shape {
    fn from_player_encoding(encoded: &str) -> Self {
        match encoded {
            "X" => Self::Rock,
            "Y" => Self::Paper,
            "Z" => Self::Scissors,
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
            "X" => Self::Loss,
            "Y" => Self::Draw,
            "Z" => Self::Win,
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

pub(crate) fn solution(input: &str) -> (String, String) {
    let part1: Vec<(Shape, Shape)> = parse(input);
    let part2: Vec<(Shape, RoundResult)> = parse(input);

    (play_game(&part1).to_string(), play_game(&part2).to_string())
}
