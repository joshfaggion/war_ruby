class Player
  attr_reader :deck
  
  def set_hand(deck)
    @deck = deck
  end

  def cards_left
    @deck.length
  end

  def take_winning (winnings)
    @deck.push(winnings)
  end

  def play
    @deck.pop
  end
end
