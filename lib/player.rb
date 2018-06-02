class Player
  attr_reader :deck

  def set_hand(deck)
    @deck = deck
  end

  def cards_left
    @deck.length
  end

  def take_winning (winnings)
    winnings.shuffle!
    winnings.each do |i|
      @deck.push(i)
    end
  end

  def play
    @deck.shift
  end
end
