module Year2022.Day01 (solution) where

import Data.List (sortOn)
import Data.List.Split (splitOn)

parse :: String -> [Int]
parse input = map sum $ map (map read) $ map words $ splitOn "\n\n" input

part1 :: [Int] -> Int
part1 calories = maximum calories

part2 :: [Int] -> Int
part2 calories = sum $ take 3 $ sortOn negate calories

solution :: String -> (String, String)
solution input = (show $ part1 calories, show $ part2 calories)
  where
    calories = parse input
