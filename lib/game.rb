
class Game
  def initialize(deck)
    @deck = deck
  end
  def evaluate_winner(original_card, opposing_card)
    if original_card == opposing_card
      evaluate_winner(@deck.deal, @deck.deal)
    elsif original_card > opposing_card
      "The original card was victorious!"
    else
      "The opposing card was victorious!"
    end
  end
end
