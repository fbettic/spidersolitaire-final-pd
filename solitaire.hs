import Utils (createDeck, dealCards, shuffleDeck)

main :: m b
main = do
  shuffledDeck <- shuffleDeck dealCards
  show dealCards shuffledDeck 0 []