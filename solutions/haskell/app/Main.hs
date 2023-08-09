module Main (main) where

import qualified Data.Map as Map
import Data.Maybe (fromJust, isNothing)
import System.Environment (getArgs)
import System.Exit (exitFailure)
import System.IO (hPutStrLn, stderr)
import Text.Printf (printf)
import Text.Read (readMaybe)

import Solutions (solutions)

die :: String -> IO ()
die msg = hPutStrLn stderr msg >> exitFailure

main :: IO ()
main = do
    args <- getArgs
    if length args < 2 || length args > 3
        then die "Usage: ./executable YEAR DAY [optional/input.txt]"
        else do
            let year = readMaybe (head args) :: Maybe Int
            if isNothing year
                then die ("Cant parse year: " ++ head args)
                else do
                    let day = readMaybe (args !! 1) :: Maybe Int
                    if isNothing day
                        then die ("Cant parse day: " ++ (args !! 1))
                        else do
                            let key = show (fromJust year) ++ "/" ++ printf "%02d" (fromJust day)

                            let inputFile =
                                    if length args == 3
                                        then (args !! 2)
                                        else printf "../../inputs/%d/day%02d.txt" (fromJust year) (fromJust day)

                            case Map.lookup key solutions of
                                Nothing -> die ("Solution for year " ++ head args ++ " and day " ++ (args !! 1) ++ " not found")
                                Just solution -> do
                                    input <- readFile inputFile
                                    let (part1, part2) = solution input
                                    putStrLn (part1 ++ "\n" ++ part2)
