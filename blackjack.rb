print "Enter your name: "
playerName = gets.chomp

class Player
    attr_accessor :name, :bank_roll, :hand, :total
    def initialize(name, bank_roll = 100)
        @name = name
        @bank_roll = bank_roll
        @hand = []
        @total = 0
    end

    def calculateTotal
        self.total = 0
        self.hand.each {|card| 
            self.total += card.value
        }
    end
end

player1 = Player.new(name = playerName)
house = Player.new(name = "House", 10000)

puts "Welcome to Blackjack, #{player1.name}"
puts "#################################"

deck = []

class Card
    attr_reader :value, :face, :suit
    def initialize (value, face, suit)
        @value = value
        @face = face
        @suit = suit
    end
end

suits = ["♥","♦","♠","♣"]
faceAndValues = [
    {:face => "Two", :value => 2},
    {:face => "Three", :value => 3},
    {:face => "Four", :value => 4},
    {:face => "Five", :value => 5},
    {:face => "Six", :value => 6},
    {:face => "Seven", :value => 7},
    {:face => "Eight", :value => 8},
    {:face => "Nine", :value => 9},
    {:face => "Ten", :value => 10},
    {:face => "Jack", :value => 10},
    {:face => "Queen", :value => 10},
    {:face => "King", :value => 10},
    {:face => "Ace", :value => 11}
]

# METHOD 1 to create deck
for suit in suits
    for faceAndValue in faceAndValues
        card = Card.new(faceAndValue[:value], faceAndValue[:face], suit)
        deck << card
    end
end

# This was not part of the homework requirement
# Method 2 to create deck (just for practice)
deck2 = []
suits.each { |suit| 
    faceAndValues.each { |faceAndValue| 
        card = Card.new(faceAndValue[:value], faceAndValue[:face], suit)
        deck2 << card
    }
}

# p deck.length # 52
# p deck2.length # 52

deck = deck.shuffle

def drawCard(player, deck)
    player.hand << deck.pop
    cardIndex = player.hand.length-1
    puts "#{player.name} drew #{player.hand[cardIndex].face} of #{player.hand[cardIndex].suit}"
    player.calculateTotal
end

continueGame = true

while continueGame do
    if (deck.length < 4)
        puts "########ENTERING IF CONDITION FOR LESS THAN 4#########################"
        deck = deck2.shuffle
    end
    drawCard(player1, deck)
    drawCard(house, deck)
    drawCard(player1, deck)
    drawCard(house, deck)
    # p deck.length
    # p player1
    # p house

    puts "#################################"

    def printTotal(player)
        puts "#{player.name}'s current total is #{player.total}"
    end

    printTotal(player1)
    printTotal(house)

    def checkHitOrStay(player1,deck,house)
        puts "#################################"
        print "Would you like to (h)it or (s)tay? "
        hitOrStay = gets.chomp
        if (hitOrStay == "h")
            puts "You have chosen to hit"
            drawCard(player1, deck)
            printTotal(player1)
            printTotal(house)
            if (player1.total < 21)
                checkHitOrStay(player1,deck,house)
            end
        elsif (hitOrStay == "s")
            puts "You have chosen to stay"
        else
            puts "Please enter only 'n' or 'q'. Try again."
            checkHitOrStay(player1,deck,house)
        end
    end

    checkHitOrStay(player1,deck, house)

    puts "#################################"

    def checkForAce(player)
        player.hand.each{ |card| 
            if card.value == 11
                card.value = 1
                player.calculateTotal
                return player
            end
        }
        if (player.name != "House")
            puts "Round has ended as a tie and current balance is #{player.bank_roll}"
        end
        return player
    end

    def checkWinCondition(player1, house)
        if ((player1.total > house.total || house.total > 21) && player1.total <= 21)
            player1.bank_roll += 10
            house.bank_roll -= 10
            puts "#{player1.name} has won this round and current balance is #{player1.bank_roll}"
        elsif ((player1.total < house.total || player1.total > 21) && house.total <= 21)
            player1.bank_roll -= 10
            house.bank_roll += 10
            puts "#{player1.name} has lost this round and current balance is #{player1.bank_roll}"
        else
            p player1.total
            p house.total
            player1 = checkForAce(player1)
            p player1
            house = checkForAce(house)
            p house
            checkWinCondition
        end
    end

    checkWinCondition(player1, house)

    player1.hand = []
    house.hand = []

    puts "#################################"
    p deck.length

    def checkGameStatus
        print "Would you like to play (n)ext round or (q)uit: "
        gameStatus = gets.chomp
        # p gameStatus
        if (gameStatus == "n") 
            puts "Starting next round"
            return true
        elsif (gameStatus == "q")
            puts "Exiting game"
            return false
        else
            puts "Please enter only 'n' or 'q'. Try again."
            return checkGameStatus
        end
    end
    continueGame = checkGameStatus
    # p continueGame
end