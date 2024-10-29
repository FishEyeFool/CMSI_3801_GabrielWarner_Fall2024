module Exercises
    ( change,
      firstThenApply,
      powers,
      Shape(Sphere, Box),
      volume,
      surfaceArea,
      -- put the proper exports here
    ) where

import qualified Data.Map as Map
import Data.Text (pack, unpack, replace)
import Data.List(isPrefixOf, find)
import Data.Char(isSpace)

change :: Integer -> Either String (Map.Map Integer Integer)
change amount
    | amount < 0 = Left "amount cannot be negative"
    | otherwise = Right $ changeHelper [25, 10, 5, 1] amount Map.empty
        where
          changeHelper [] remaining counts = counts
          changeHelper (d:ds) remaining counts =
            changeHelper ds newRemaining newCounts
              where
                (count, newRemaining) = remaining `divMod` d
                newCounts = Map.insert d count counts

-- Write your first then apply function here
firstThenApply :: [element] -> (element -> Bool) -> (element -> result) -> Maybe result
firstThenApply elements predicate consumer = consumer <$> find predicate elements

-- Write your infinite powers generator here
powers :: Integral base => base -> [base]
powers base = map (base^) [0..]

-- Write your line count function here


-- Write your shape data type here
data Shape
  = Sphere Double
  | Box Double Double Double
  deriving (Show, Eq)

volume :: Shape -> Double
volume (Sphere radius) = (4 / 3) * pi * radius^3
volume (Box width length depth) = width * length * depth

surfaceArea :: Shape -> Double
surfaceArea (Sphere radius) = 4.0 * pi * radius^2
surfaceArea (Box width length depth) = 
  2.0 * (width * length + length * depth + depth * width)

-- Write your binary search tree algebraic type here
