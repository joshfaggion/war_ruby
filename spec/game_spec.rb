require('rspec')
require('game')

describe '#game?' do
  it 'should decrease player ones hand while increasing player twos hand' do
    game_of_war = Game.new()
    game_of_war.run_round
    expect(game_of_war.player_one.cards_left?).to eq (25)
    expect(game_of_war.player_two.cards_left?).to eq (27)
  end
end
