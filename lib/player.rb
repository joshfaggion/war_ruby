class Player
  def initialize (deck)
    @deck = deck[0]
  end

  def cards_left?
    @deck.length
  end

  def take_winning (cards_won)
    @deck.push(cards_won)
  end
  
  def play
    @deck.pop
  end
end
