module Main (main) where

import qualified Data.Map as Map
import Data.Maybe (fromMaybe)
import System.Environment (getArgs)
import System.Exit (exitFailure)
import System.IO (hPutStrLn, stderr)
import Text.Printf (printf)
import Text.Read (readMaybe)

import Solutions (solutions)

data Args = Args Int Int (Maybe String)

parseArgs :: [String] -> Either String Args
parseArgs args = case args of
    [year, day] -> ($ Nothing) <$> parseYearAndDay year day
    [year, day, path] -> ($ Just path) <$> parseYearAndDay year day
    _ -> Left "Usage: ./executable YEAR DAY [optional/input.txt]"
  where
    parseYearAndDay year day = case (readMaybe year, readMaybe day) of
        (Nothing, _) -> Left ("Can't parse year: " ++ year)
        (_, Nothing) -> Left ("Can't parse day: " ++ day)
        (Just y, Just d) -> Right $ Args y d

die :: String -> IO a
die msg = hPutStrLn stderr msg >> exitFailure

readCliArgs :: [String] -> IO Args
readCliArgs args = case parseArgs args of
    Left err -> die err
    Right parsed -> return parsed

main :: IO ()
main = do
    Args year day maybeInputFile <- readCliArgs =<< getArgs
    let inputFile = fromMaybe (printf "../../inputs/%d/day%02d.txt" year day) maybeInputFile

    let key = printf "%d/%02d" year day
    case Map.lookup key solutions of
        Nothing -> die $ printf "Solution for year %d and day %d not found" year day
        Just solution -> do
            input <- readFile inputFile
            let (part1, part2) = solution input
            putStrLn (part1 ++ "\n" ++ part2)
