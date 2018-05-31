require('rspec')
require('game')

describe '#game?' do
  it 'should decrease player ones hand while increasing player twos hand' do
    game_of_war = Game.new()
    game_of_war.player_one.set_hand([PlayingCard.new("10", "Diamonds")])
    game_of_war.player_two.set_hand([PlayingCard.new("Queen", "Diamonds")])
    # keep going
    game_of_war.run_round
    inside_of_deck = 0
    #now you know what whould happen... including which cards
    expect(game_of_war.player_one.cards_left).to eq (0)
    expect(game_of_war.player_two.deck[inside_of_deck].size).to eq (2)
  end
  it 'should tie twice and then be won by player one on the third draw' do
    game_of_war = Game.new
    game_of_war.player_one.set_hand([PlayingCard.new("5", "Diamonds"), PlayingCard.new("Queen", "Hearts"), PlayingCard.new("6", "Clubs")])
    game_of_war.player_one.set_hand([PlayingCard.new("5", "Hearts"), PlayingCard.new("Queen", "Spades"), PlayingCard.new("2", "Spades")])
    inside_of_deck = 0
    expect(game_of_war.player_one.deck.length).to eq (0)
    expect(game_of_war.player_two.deck.length).to eq (6)
  end
end
