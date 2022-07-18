module Utils
  ( Card (..),
    createDeck,
    shuffleDeck,
    dealCards,
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
createDeck = [Card r True | r <- [1 .. 13], x <- [1 .. 8]]

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
  | numberRow < 4 = dealCards (drop 5 deck) (numberRow + 1) (cards ++ [take 5 deck])
  | numberRow < 10 = dealCards (drop 4 deck) (numberRow + 1) (cards ++ [take 4 deck])
  | otherwise = (cards, deck)