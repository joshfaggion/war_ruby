require('rspec')
require ('player')

describe '#player?' do
  it "should initialize a player with a half a deck" do
    player_one_deck = CardDeck.new().split_to_two_decks
    player_one_deck.shuffle
    player = Player.new(player_one_deck, 0)
    expect(player.cards_left).to eq (26)
  end
  it 'should be able to take two cards and increase its deck' do
    player_deck = CardDeck.new().split_to_two_decks
    player_deck.shuffle
    player = Player.new(player_deck, 0)
    cards_won = [4,10]
    new_deck = player.take_winning(cards_won)
    expect(new_deck.length).to eq (27)
  end
  it 'should be able to lose a card' do
    player_deck = CardDeck.new().split_to_two_decks
    player_deck.shuffle
    player = Player.new(player_deck, 0)
    player.play
    expect(player.cards_left).to eq (25)
  end
end
