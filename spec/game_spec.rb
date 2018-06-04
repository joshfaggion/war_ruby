require('rspec')
require('game')

describe '#game?' do
  it 'should decrease player ones hand while increasing player twos hand' do
    game_of_war = Game.new()
    breaking_tie = false
    game_of_war.player_one.set_hand([PlayingCard.new("10", "Diamonds")])
    game_of_war.player_two.set_hand([PlayingCard.new("Queen", "Diamonds")])
    game_of_war.run_round(breaking_tie)
    inside_of_deck = 0
    expect(game_of_war.player_one.cards_left).to eq (0)
    expect(game_of_war.player_two.deck.size).to eq (2)
   end
end
