require('player')


class Game
  attr_reader :player_one, :player_two

  def initialize
    @player_one = Player.new()
    @player_two = Player.new()
    @prizepool = []
  end

  def begin_game
    @deck = CardDeck.new().split_to_two_decks
    @deck.shuffle
    player_one.set_hand
    player_two.set_hand
  end

  def run_round
    card_one = @player_one.play
    card_two = @player_two.play
    @prizepool.push(card_one, card_two)
    if card_one.value > card_two.value
      @player_one.take_winning(@prizepool)
      @prizepool = []
      return "Player One took the #{card_one.rank} of #{card_one.suit}, and the #{card_two.rank} of #{card_two.suit}!"
    elsif card_two.value > card_one.value
      @player_two.take_winning(@prizepool)
      @prizepool = []
      return "Player Two took the #{card_one.rank} of #{card_one.suit}, and the #{card_two.rank} of #{card_two.suit}!"
    elsif card_one.value == card_two.value
      run_round()
    end
  end
end
