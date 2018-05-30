require('player')


class Game
  attr_reader :player_one, :player_two
  
  def initialize()
    @deck = CardDeck.new().split_to_two_decks
    @deck.shuffle
    @player_one = Player.new(@deck, 0)
    @player_two = Player.new(@deck, 1)
    @prizepool = []
  end

  def run_round
    card_one = @player_one.play
    card_two = @player_two.play
    @prizepool.push(card_one, card_two)
    if card_one > card_two
      @player_one.take_winning(@prizepool)
    elsif card_two > card_one
      @player_two.take_winning(@prizepool)
    elsif card_one == card_two

    end
  end

  def player_one
    @player_one
  end

  def player_two
    @player_two
  end
end
