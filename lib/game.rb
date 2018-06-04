require_relative('player')
require_relative('card_deck')


class Game
  attr_reader :player_one, :player_two, :game_winner

  def initialize
    @player_one = Player.new()
    @player_two = Player.new()
    prizepool = []
    @game_winner = ''
  end

  def begin_game
    @deck = CardDeck.new()
    @deck.shuffle
    new_deck = @deck.split_to_two_decks
    @player_one.set_hand(new_deck[0])
    @player_two.set_hand(new_deck[1])
  end

  def run_round(tie, prizepool=[])
    card_one = @player_one.play
    card_two = @player_two.play
    prizepool.push(card_one, card_two)
    if card_one.value > card_two.value

      if (tie)
        cards = prizepool
        @player_one.take_winning(prizepool)
        prizepool = []
        return "Player One used the #{cards[cards.size - 2].string_value} to win a war and take the prizepool!"

      else
        @player_one.take_winning(prizepool)
        prizepool = []
        return "Player One took the #{card_one.string_value}, and the #{card_two.string_value}!"
      end

    elsif card_two.value > card_one.value

      if (tie)
        cards  = prizepool
        @player_two.take_winning(prizepool)
        prizepool = []
        return "Player Two used the #{cards[cards.size - 2].string_value} to win a war and take the prizepool!"

      else
        @player_two.take_winning(prizepool)
        prizepool = []
        return "Player Two took the #{card_one.string_value}, and the #{card_two.string_value}!"
      end

    else
      run_round(true, prizepool)
    end
  end

  def winner
    if @player_one.cards_left < 1
      @game_winner = "Player Two!"
      true
    elsif @player_two.cards_left < 1
      @game_winner = "Player One!"
      true
    else
      false
    end
  end
end
