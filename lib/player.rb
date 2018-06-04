class Player
  attr_reader :deck

  def set_hand(deck)
    @deck = deck
  end

  def cards_left
    @deck.length
  end

  def take_winning (winnings)
    shuffled_winnings = winnings.shuffle
    shuffled_winnings.each do |i|
      @deck.push(i)
    end
  end

  def play
    @deck.shift
  end
end
