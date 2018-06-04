require('rspec')
require ('player')

describe '#player?' do
  it "should initialize a player with a half a deck" do
    player_deck = CardDeck.new().split_to_two_decks[0]
    player_deck.shuffle
    player = Player.new()
    player.set_hand(player_deck)
    expect(player.cards_left).to eq (26)
  end
  it 'should be able to lose a card' do
    player_deck = CardDeck.new().split_to_two_decks[0]
    player_deck.shuffle
    player = Player.new()
    player.set_hand(player_deck)
    player.play
    expect(player.cards_left).to eq (25)
  end
end
