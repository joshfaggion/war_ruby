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
