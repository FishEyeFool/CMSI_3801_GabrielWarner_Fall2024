module Exercises
    ( change,
      firstThenApply,
      powers,
      Shape(Sphere, Box),
      volume,
      surfaceArea,
      meaningfulLineCount,
      BST(Empty),
      size,     
      inorder,
      insert,
      contains,
      show
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

{-|
Description : Applies a function to the first element in a list that satisfies a given predicate.

The 'firstThenApply' function takes a list of elements,
a predicate function, and a consumer function.
It finds the first element in the list that satisfies
the predicate and applies the consumer function to it.
If no such element is found, it returns 'Nothing'.

Parameters:
  elements  - A list of elements to be processed.
  predicate - A function that takes an element and returns a 
  'Bool' indicating whether the element satisfies the condition.
  consumer  - A function that takes an element and returns a result.

Returns:
  'Maybe' result - 'Just' the result of applying the 
  consumer function to the first element that satisfies the predicate,
  or 'Nothing' if no such element is found.
-}
firstThenApply :: [element] -> (element -> Bool) -> (element -> result) -> Maybe result
firstThenApply elements predicate consumer = consumer <$> find predicate elements

{-|
Description : Generates an infinite list of powers of a given base.

The 'powers' function takes an integral base and returns an 
infinite list of its powers, starting from the 0th power.

Parameters:
  base - An integral number which is the base for the powers.

Returns:
  [base] - An infinite list of powers of the given base.
-}
powers :: Integral base => base -> [base]
powers base = map (base^) [0..]

{-|
Description : Counts the number of meaningful lines in a file.

This module provides functions to process lines of text, 
including removing whitespace and checking if a line is meaningful.
A meaningful line is defined as a line that is not empty and does not start with a '#' character.

Functions:
  * trimSpaces :: String -> String
    Removes all whitespace characters from a line.

    Parameters:
      - String: The input line from which whitespace characters will be removed.

    Returns:
      - String: The line with all whitespace characters removed.

  * isTextLine :: String -> Bool
    Checks if a line is a valid text line.

    Parameters:
      - String: The input line to be checked.

    Returns:
      - Bool: True if the line is meaningful (not empty and does not start with '#'), False otherwise.

  * meaningfulLineCount :: FilePath -> IO Int
    Counts the number of meaningful lines in a file.

    Parameters:
      FilePath: The path to the file to be processed.

Returns:
  IO Int: The number of meaningful lines in the file.
-}
trimSpaces :: String -> String
trimSpaces = unpack . replace (pack " ") (pack "") . pack . filter (not . isSpace)

isTextLine :: String -> Bool
isTextLine line =
    let trimmed = trimSpaces line
    in not (null trimmed) && head trimmed /= '#'

meaningfulLineCount :: FilePath -> IO Int
meaningfulLineCount filePath = do
    contents <- readFile filePath
    let linesList = lines contents
    return $ length (filter isTextLine linesList)
  


{-|
Description : Defines geometric shapes and calculates their volume and surface area.

This module provides a data type for geometric shapes (Sphere and Box) and 
functions to calculate their volume and surface area.

Data Types:
  * Shape - Represents a geometric shape, which can be either a Sphere or a Box.

Functions:
  * volume - Calculates the volume of a given shape.
  * surfaceArea - Calculates the surface area of a given shape.

Data Types:
  * Shape
    - Sphere Double: Represents a sphere with a given radius.
    - Box Double Double Double: Represents a box with given width, length, and depth.

Functions:
  * volume :: Shape -> Double
    Calculates the volume of a given shape.

    Parameters:
      - Shape: The shape for which to calculate the volume.

    Returns:
      - Double: The volume of the shape.

  * surfaceArea :: Shape -> Double
    Calculates the surface area of a given shape.

    Parameters:
      - Shape: The shape for which to calculate the surface area.

    Returns:
      - Double: The surface area of the shape.
-}
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

{-|
Description : A simple implementation of a Binary Search Tree (BST) in Haskell.

The `BST` data type represents a binary search tree, which can either be empty (`Empty`) or a node (`Node`) containing a value and two subtrees.

Functions:
- `size`: Computes the number of nodes in the BST.
- `inorder`: Returns a list of all values in the BST in in-order traversal.
- `insert`: Inserts a new value into the BST, maintaining the BST property.
- `contains`: Checks if a given value is present in the BST.

Instance:
- `Show`: Provides a string representation of the BST.
-}
data BST a
    = Empty
    | Node a (BST a) (BST a)

size :: BST a -> Int
size Empty = 0
size (Node _ left right) = 1 + size left + size right

inorder :: BST a -> [a]
inorder Empty = []
inorder (Node value left right) = inorder left ++ [value] ++ inorder right

insert :: Ord a => a -> BST a -> BST a
insert value Empty = Node value Empty Empty
insert value (Node nodeValue left right)
    | value < nodeValue = Node nodeValue (insert value left) right
    | value > nodeValue = Node nodeValue left (insert value right)
    | otherwise = Node nodeValue left right

contains :: (Ord a) => a -> BST a -> Bool
contains _ Empty = False
contains value (Node nodeValue left right)
    | value == nodeValue = True
    | value < nodeValue = contains value left
    | otherwise = contains value right
    

instance (Show a) => Show (BST a) where
    show :: Show a => BST a -> String
    show Empty = "()"
    show (Node value Empty Empty) = "(" ++ show value ++ ")"
    show (Node value left Empty) = "(" ++ show left ++ show value ++ ")"
    show (Node value Empty right) = "(" ++ show value ++ show right ++ ")"
    show (Node value left right) = "(" ++ show left ++ show value ++ show right ++ ")"
  
  
  
  
  
  
  
    
