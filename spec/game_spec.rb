require('rspec')
require ('game')

describe '#game?' do
  it('should return that the opposing card won that round') do
    deck = CardDeck.new()
    deck.shuffle()
    war = Game.new(deck)
    card_one = 1
    card_two = 13
    expect(war.evaluate_winner(card_one, card_two)).to(eq("The opposing card was victorious!"))
  end
  it('should return that the original card won that round') do
    deck = CardDeck.new()
    deck.shuffle()
    war = Game.new(deck)
    card_one = 11
    card_two = 10
    expect(war.evaluate_winner(card_one, card_two)).to(eq("The original card was victorious!"))
  end
  it('should run a tiebreaker script that will decide either original_card or opposing_card') do
    deck = CardDeck.new()
    deck.shuffle()
    war = Game.new(deck)
    card_one = 13
    card_two = 13
    expect(war.evaluate_winner(card_one, card_two)).to eq("The original card was victorious!").or eq ("The opposing card was victorious!")
  end
end
