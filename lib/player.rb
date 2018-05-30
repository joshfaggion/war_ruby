class Player
  def initialize (deck, pos)
    @deck = deck[pos]
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
