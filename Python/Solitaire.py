

from hashlib import new
from imp import new_module
from pickle import TRUE


def createDeck():
    deck = []
    for i in range(1, 14):
        for j in range(1, 9):
            card = (i, False)
            deck.append(card)
    return deck


def shuffleDeck(deck):
    import random
    random.shuffle(deck)
    return deck


def dealCards(deck):
    cardStacks = [[], [], [], [], [], [], [], [], [], []]

    for i in range(54):
        cardStacks[i % 10].append(deck[i])

    for i in range(len(cardStacks)):
        cardStacks[i] = turnFirstCard(cardStacks[i])

    return (cardStacks, deck[54:])


def turnFirstCard(cardStack):
    if len(cardStack) > 0:
        upturnedCard = (cardStack[0][0], True)
        return [upturnedCard] + cardStack[1:]
    return []


def showCardStacks(cardStacks):
    for i in range(len(cardStacks)):
        print("S"+str(i+1)+":[" + printCardStack(cardStacks[i]) + "]")

    return 0


def printCardStack(cardStack):
    string = ""
    if len(cardStack) > 0:
        for i in range(len(cardStack)):
            if cardStack[i][1] == False:
                string += "[X]"
            else:
                string += "["+str(cardStack[i][0])+"]"
    else:
        string = "[ ]"
    return string


def verifyOrder(cardStack):
    if len(cardStack) == 0:
        return False
    elif len(cardStack) == 1:
        return True
    else:
        return (cardStack[1][0] - cardStack[0][0]) == 1 and verifyOrder(cardStack[1:])


def performMovement(origin, destination, n):
    if n <= len(origin) and origin[n-1][1] == True and verifyOrder(origin[:n] + [destination[0] if len(destination) > 0 else None]):
        return (origin[n:], origin[:n] + destination, True)
    else:
        return ([], [], False)


def replaceColumn(list, index, board):
    return board[:index-1]+[list]+board[index:]


def appendRow(board, deck):
    return (list(map(lambda x, y: [y] + x, board, deck[:10])), deck[10:])


def removeSet(column):
    if len(column) >= 13 and column[12][1] == True and verifyOrder(column[:13]):
        return column[13:]
    return column


def main():
    board = dealCards(shuffleDeck(createDeck()))
    playTurn(board[0], board[1], 0)
    return 0


def moveCards(board):
    print("Which column do you want to move from?")
    originData = input("origin: ")
    print("Which column do you want to move to?")
    destinationData = input("destination: ")
    print("How many cards do you want to move?")
    cardsData = input("cards: ")
    origin = int(originData)
    destination = int(destinationData)
    cards = int(cardsData)
    if origin > 10 or destination > 10 or origin <= 0 or destination <= 0 or destination == origin:
        print("Invalid column")
        return board
    else:
        (newOrigin, newDestination, wasValid) = performMovement(
            (board[origin-1]), (board[destination-1]), cards)
        if wasValid:
            return replaceColumn(newOrigin, origin, (replaceColumn(newDestination, destination, board)))
        else:
            print("Invalid movement")
            return board


def playTurn(board, deck, sets):
    currentBoard = list(map(turnFirstCard, list(map(removeSet, board))))
    amountSets = sets + \
        len(list(filter(lambda x: x[1] != x[0], zip(board, currentBoard))))
    if amountSets >= 8:
        print("Congratulations! You won Spider Solitaire")
        return 0
    else:
        print(len(deck), amountSets)
        showCardStacks(currentBoard)
        print("What do you want to do?")
        print("1. Move Cards")
        print("2. Place row of cards")
        print("3. Quit")
        option = input("option: ")
        if option == "1":
            newBoard = moveCards(currentBoard)
            playTurn(list(map(turnFirstCard, newBoard)), deck, amountSets)
        elif option == "2":
            if len(deck) < 10:
                print("Deck is empty")
                playTurn(currentBoard, deck, amountSets)
            else:
                (newBoard, newDeck) = appendRow(currentBoard, deck)
                playTurn(list(map(turnFirstCard, newBoard)),
                         newDeck, amountSets)
        elif option == "3":
            print("Quitting")
            return 0
        else:
            print("Invalid option")
            playTurn(currentBoard, deck, amountSets)


main()
