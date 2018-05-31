require('player')


class Game
  attr_reader :player_one, :player_two

  def initialize
    @player_one = Player.new()
    @player_two = Player.new()
  end

  def begin_game
    @deck = CardDeck.new().shuffle.split_to_two_decks
    player_one.set_hand
    player_two.set_hand
  end

  def run_round
    card_one = @player_one.play
    card_two = @player_two.play
    prizepool = []
    prizepool.push(card_one, card_two)
    if card_one.value > card_two.value
      @player_one.take_winning(prizepool)
    elsif card_two.value > card_one.value
      @player_two.take_winning(prizepool)
    elsif card_one.value == card_two.value

    end
  end
end
