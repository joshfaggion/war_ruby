require('rspec')
require('card_deck')
require('pry')

describe '#card_deck?' do
  it('should start the deck with 52 cards') do
    deck = CardDeck.new()
    expect(deck.cards_left).to(eq(52))
  end

  it('should give a card that will not return nil') do
    deck = CardDeck.new()
    card = deck.deal()
    expect(card).to_not be_nil
  end

  it('should return the deck with one less card') do
    deck = CardDeck.new()
    deck.deal()
    expect(deck.cards_left).to(eq(51))
  end

  it('should shuffle the deck') do
    deck = CardDeck.new()
    deck.shuffle()
    cards = []
    deck.cards_left.times { cards.push(deck.deal) }
    standard_cards = []
    standard_deck = CardDeck.new
    standard_deck.cards_left.times { standard_cards.push(deck.deal) }
    expect(cards).to_not eq(standard_cards)
  end

  it 'should return an array of two decks' do
    deck = CardDeck.new()
    both_decks = deck.split_to_two_decks.to_a
    first_deck = 0
    expect(both_decks[first_deck].size).to eq (deck.cards_left / 2)
  end
end
