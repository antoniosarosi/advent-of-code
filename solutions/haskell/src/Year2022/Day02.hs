module Year2022.Day02 (solution) where

data Shape = Rock | Paper | Scissors deriving (Show, Eq)

data RoundResult = Win | Draw | Loss deriving (Show, Eq)

shapePoints :: Shape -> Int
shapePoints shape = case shape of
    Rock -> 1
    Paper -> 2
    Scissors -> 3

roundPoints :: RoundResult -> Int
roundPoints result = case result of
    Win -> 6
    Draw -> 3
    Loss -> 0

parseOponent :: String -> Shape
parseOponent encoded = case encoded of
    "A" -> Rock
    "B" -> Paper
    "C" -> Scissors
    _ -> error ("Parse oponent shape error: " ++ encoded)

parsePlayerIntoShape :: String -> Shape
parsePlayerIntoShape encoded = case encoded of
    "X" -> Rock
    "Y" -> Paper
    "Z" -> Scissors
    _ -> error ("Parse player shape error" ++ encoded)

parsePlayerIntoRoundResult :: String -> RoundResult
parsePlayerIntoRoundResult encoded = case encoded of
    "X" -> Loss
    "Y" -> Draw
    "Z" -> Win
    _ -> error ("Parse player desired result error: " ++ encoded)

parse :: (String -> p) -> String -> [(Shape, p)]
parse parsePlayer input = map (parseLine . words) $ lines input
  where
    parseLine line = case line of
        [oponent, player] -> (parseOponent oponent, parsePlayer player)
        _ -> error ("Parse error at line: '" ++ unwords line ++ "'")

playeGame :: (Shape -> p -> Int) -> [(Shape, p)] -> Int
playeGame calculatePoints game = sum $ map (uncurry calculatePoints) game

roundResult :: Shape -> Shape -> RoundResult
roundResult oponent player
    | (player, oponent) `elem` win = Win
    | (player, oponent) `elem` loss = Loss
    | otherwise = Draw
  where
    win = [(Rock, Scissors), (Paper, Rock), (Scissors, Paper)]
    loss = [(Scissors, Rock), (Paper, Scissors), (Rock, Paper)]

necessaryShape :: Shape -> RoundResult -> Shape
necessaryShape oponent player
    | (player, oponent) `elem` rockNeeded = Rock
    | (player, oponent) `elem` paperNeeded = Paper
    | otherwise = Scissors
  where
    rockNeeded = [(Loss, Paper), (Draw, Rock), (Win, Scissors)]
    paperNeeded = [(Loss, Scissors), (Draw, Paper), (Win, Rock)]

part1 :: [(Shape, Shape)] -> Int
part1 = playeGame calculatePoints
  where
    calculatePoints oponent player = roundPoints (roundResult oponent player) + shapePoints player

part2 :: [(Shape, RoundResult)] -> Int
part2 = playeGame calculatePoints
  where
    calculatePoints oponent player = roundPoints player + shapePoints (necessaryShape oponent player)

solution :: String -> (String, String)
solution input =
    ( show $ part1 $ parse parsePlayerIntoShape input
    , show $ part2 $ parse parsePlayerIntoRoundResult input
    )
