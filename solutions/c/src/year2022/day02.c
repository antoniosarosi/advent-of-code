typedef enum {
    ROCK = 1,
    PAPER = 2,
    SCISSORS = 3,
} Shape;

typedef enum {
    LOSS = 0,
    DRAW = 3,
    WIN = 6,
} RoundResult;

Shape parse_oponent(char encoded) {
    switch (encoded) {
        case 'A': return ROCK;
        case 'B': return PAPER;
        case 'C': return SCISSORS;
        default:  return -1;
    }
}

Shape parse_player_shape(char encoded) {
    switch (encoded) {
        case 'X': return ROCK;
        case 'Y': return PAPER;
        case 'Z': return SCISSORS;
        default:  return -1;
    }
}

RoundResult parse_player_result(char encoded) {
    switch (encoded) {
        case 'X': return LOSS;
        case 'Y': return DRAW;
        case 'Z': return WIN;
        default:  return -1;
    }
}

RoundResult round_result(Shape player, Shape oponent) {
    switch (player) {
        case ROCK: switch (oponent) {
            case ROCK: return DRAW;
            case PAPER: return LOSS;
            case SCISSORS: return WIN;
        }

        case PAPER: switch (oponent) {
            case ROCK: return WIN;
            case PAPER: return DRAW;
            case SCISSORS: return LOSS;
        }

        case SCISSORS: switch (oponent) {
            case ROCK: return LOSS;
            case PAPER: return WIN;
            case SCISSORS: return DRAW;
        }
    }
}

Shape necessary_shape_for_result(Shape oponent, RoundResult result) {
    switch (result) {
        case LOSS: switch (oponent) {
            case ROCK: return SCISSORS;
            case PAPER: return ROCK;
            case SCISSORS: return PAPER;
        }

        case WIN: switch (oponent) {
            case ROCK: return PAPER;
            case PAPER: return SCISSORS;
            case SCISSORS: return ROCK;
        }

        case DRAW: return oponent;
    }
}

void year2022_day02_solution(char *input, char **output) {
    int part1_total_points = 0;
    int part2_total_points = 0;

    while (*input != '\0') {
        Shape oponent_shape = parse_oponent(*input);
        input += 2;

        Shape player_shape = parse_player_shape(*input);
        RoundResult player_result = parse_player_result(*input);
        input += 2;

        part1_total_points += round_result(player_shape, oponent_shape) + player_shape;
        part2_total_points += necessary_shape_for_result(oponent_shape, player_result) + player_result;
    }

    sprintf(output[0], "%d", part1_total_points);
    sprintf(output[1], "%d", part2_total_points);
}
