require('pry')

class CardDeck
  def initialize
    @cards = []
    ranks=%w[Ace 2 3 4 5 6 7 8 9 10 Jack Queen King]
    suits=%w[Hearts Spades Diamonds Clubs]
    suits.each do |suit|
      ranks.each do |rank|
        card = PlayingCard.new(rank, suit)
        @cards.push(card.value)
      end
    end
  end

  def cards
    @cards
  end

  def cards_left?
    @cards.length
  end

  def deal
    @cards.pop()
  end

  def shuffle
    @cards.shuffle!
  end
end
