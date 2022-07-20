

from hashlib import new
from imp import new_module
from pickle import TRUE
import string


def createDeck():
    deck = []
    for i in range(1,14):
        for j in range(1,9):
            card = (i,False)
            deck.append(card)
    return deck 

def shuffleDeck(deck):
    import random
    random.shuffle(deck)
    return deck

def dealCards(deck):
    cardStacks = [[],[],[],[],[],[],[],[],[],[]]

    for i in range(54):
        cardStacks[i%10].append(deck[i])
            
    for i in range(len(cardStacks)):
        cardStacks[i] = turnFirstCard(cardStacks[i])

    return (cardStacks,deck[54:])	
    

def turnFirstCard(cardStack):
    if len(cardStack) > 0:
        upturnedCard = (cardStack[0][0],True)
        return [upturnedCard] + cardStack[1:]
    return cardStack

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
    if len(cardStack) > 1:
        for i in range(len(cardStack)-1):
            if cardStack[i][0] >= cardStack[i+1][0]:
                return False
        return True
    elif len(cardStack) == 1:
        return True
    else:
        return False


def main():    
    board = dealCards(shuffleDeck(createDeck()))
    print("cards in deck:",len(board[1]))
    showCardStacks(board[0])


    return 0



main()