
module Utils
  ( Card (..),
    createDeck,
    shuffleDeck,
    dealCards,
    turnFirstCard,
    performMovement,
  )
where

import System.Random

data Card = Card
  { rank :: Int,
    faceUp :: Bool
  }
  deriving (Eq)

instance Show Card where
  show (Card r f) = if f then show r else "X"

createDeck :: [Card]
createDeck = [Card r False | r <- [1 .. 13], x <- [1 .. 8]]

shuffleDeck :: [Card] -> [Card] -> IO [Card]
shuffleDeck shuffledDeck [] = return shuffledDeck
shuffleDeck shuffledDeck deck = do
  r <- randomRIO (0, length deck - 1)
  let randomCard = deck !! r
      deckBefore = take r deck
      deckAfter = drop (r + 1) deck
  shuffleDeck (randomCard : shuffledDeck) (deckBefore ++ deckAfter)

dealCards :: [Card] -> Int -> [[Card]] -> ([[Card]], [Card])
dealCards deck numberRow cards
  | numberRow < 4 = dealCards (drop 6 deck) (numberRow + 1) (cards ++ [turnFirstCard (take 6 deck)])
  | numberRow < 10 = dealCards (drop 5 deck) (numberRow + 1) (cards ++ [turnFirstCard (take 5 deck)])
  | otherwise = (cards, deck)

turnFirstCard :: [Card] -> [Card]
turnFirstCard (firstCard:cardColumn)
  | faceUp firstCard = firstCard : cardColumn
  | otherwise = Card (rank firstCard) True : cardColumn
turnFirstCard [] = []


{-
 c
f  1  2  3  4  5
1 [X][X][X][X][X]
2 [X][X][X][X][X]
3 [9][8][X][X][6]
4 [8][5][7][2][5]	
-}

verifyOrder :: [Card] -> Bool
verifyOrder (xs:x) = (rank (head x) - rank xs == 1) && verifyOrder x
verifyOrder [x] = True
verifyOrder [] = False

-- origen -> destino -> canCartas
performMovement :: [Card] -> [Card] -> Int -> ([Card], [Card], Bool)
performMovement _ _ 0 = ([], [], False)
performMovement [] _ _ = ([], [], False)
performMovement origin destination n
  | allCardsFaceUp && verifyOrder (take n origin) && verifyOrder (take n origin ++ [head destination]) = ([], [], False)
  where
    isLessOrSameLength = n <= length origin
    allCardsFaceUp = isLessOrSameLength && faceUp (origin!!(n-1))
{-
1,2,3,4,5

5
4
3
2
1

-}