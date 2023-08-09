module Solutions (solutions) where

import qualified Data.Map as Map

import qualified Year2022.Day01
import qualified Year2022.Day02

solutions :: Map.Map String (String -> (String, String))
solutions =
    Map.fromList
        [ ("2022/01", Year2022.Day01.solution)
        , ("2022/02", Year2022.Day02.solution)
        ]
