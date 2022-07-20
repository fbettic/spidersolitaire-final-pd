

def createDeck():
    deck = []
    for i in range(1,13):
        for j in range(1,8):
            card = (i,False)
            deck.append(card)
    return deck 

def shuffleDeck(deck):
    import random
    random.shuffle(deck)
    return deck

def showDeck(deck):
    for i in range(len(deck)):
        if deck[i][1] == False:
            print('X')
        else:
            print(deck[i][0])
    return 0

def main():
    deck = createDeck()
    deck = shuffleDeck(deck)
    showDeck(deck)
    return 0

main()