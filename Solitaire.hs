import Utils (Card, createDeck, dealCards, performMovement, replaceColumn, shuffleDeck)

main :: IO ()
main = do
  shuffledDeck <- shuffleDeck [] createDeck
  let (board, deck) = dealCards shuffledDeck 0 []
  playTurn board deck

playTurn :: [[Card]] -> [Card] -> IO ()
playTurn board cards = do
  print (board, cards)
  putStrLn "What do you want to do?"
  putStrLn "1. Move Cards"
  putStrLn "2. Place row of cards"
  putStrLn "3. Quit"
  option <- getLine
  case option of
    "1" -> do
      moveCards board
      playTurn board cards
    "3" -> do
      putStrLn "Quitting"
      return ()
    _ -> do
      putStrLn "Invalid option"
      playTurn board cards

-- tablero -R> tablero modificado
moveCards :: [[Card]] -> IO [[Card]]
moveCards board = do
  putStrLn "Which column do you want to move from?"
  originData <- getLine
  putStrLn "Which column do you want to move to?"
  destinationData <- getLine
  putStrLn "How many cards do you want to move?"
  cardsData <- getLine
  let origin = read originData :: Int
  let destination = read destinationData :: Int
  let cards = read cardsData :: Int
  if origin >= 10 || destination >= 10 || origin < 0 || destination < 0 || destination == origin
    then do
      putStrLn "Invalid column"
      return board
    else do
      let (newOrigin, newDestination, wasValid) = performMovement (board !! (origin - 1)) (board !! (destination - 1)) cards
      if wasValid
        then do
          return (replaceColumn newOrigin (origin -1) (replaceColumn newDestination (destination -1) board))
        else do
          putStrLn "Invalid movement"
          return board

  return []
