import Haskell.Utils (Card, appendRow, createDeck, dealCards, performMovement, removeSet, replaceColumn, showBoard, shuffleDeck, turnFirstCard)

main :: IO ()
main = do
  shuffledDeck <- shuffleDeck [] createDeck
  let (board, deck) = dealCards shuffledDeck 0 []
  playTurn board deck 0

playTurn :: [[Card]] -> [Card] -> Int -> IO ()
playTurn board deck sets = do
  let currentBoard = map removeSet board
  let amountSets = sets + length (filter (== False) (zipWith (==) board currentBoard))
  if amountSets >= 8
    then do
      putStrLn "Congratulations! You won Spider Solitaire"
      return ()
    else do
      putStr "Sets Removed: "
      print amountSets
      putStr "Cards on the deck: "
      print (length deck)
      putStrLn "Cards on the board: "
      putStr (showBoard currentBoard)
      putStrLn "What do you want to do?"
      putStrLn "1. Move Cards"
      putStrLn "2. Place row of cards"
      putStrLn "3. Quit"
      option <- getLine
      case option of
        "1" -> do
          newBoard <- moveCards currentBoard
          playTurn (map turnFirstCard newBoard) deck amountSets
        "2" -> do
          if length deck < 10
            then do
              putStrLn "Deck is empty"
              playTurn currentBoard deck amountSets
            else do
              let (newBoard, newDeck) = appendRow currentBoard deck
              playTurn newBoard newDeck amountSets
        "3" -> do
          putStrLn "Quitting"
          return ()
        _ -> do
          putStrLn "Invalid option"
          playTurn currentBoard deck amountSets

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
  if origin > 10 || destination > 10 || origin <= 0 || destination <= 0 || destination == origin
    then do
      putStrLn "Invalid column"
      return board
    else do
      let (newOrigin, newDestination, wasValid) = performMovement (board !! (origin - 1)) (board !! (destination - 1)) cards
      if wasValid
        then do
          return (replaceColumn newOrigin origin (replaceColumn newDestination destination board))
        else do
          putStrLn "Invalid movement"
          return board