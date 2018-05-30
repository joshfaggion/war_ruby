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

class PlayingCard
  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def string_value
    "#{@rank} of #{@suit}"
  end

  def value
    ranks=%w[Ace 2 3 4 5 6 7 8 9 10 Jack Queen King]
    ranks.index("#{@rank}")
  end
end

class Game
  def initialize(deck)
    @deck = deck
  end
  def evaluate_winner(original_card, opposing_card)
    if original_card == opposing_card
      evaluate_winner(@deck.deal, @deck.deal)
    elsif original_card > opposing_card
      "The original card was victorious!"
    else
      "The opposing card was victorious!"
    end
  end
end
