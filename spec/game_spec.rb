require('rspec')
require('game')

describe '#game?' do
  it 'should decrease player ones hand while increasing player twos hand' do
    game_of_war = Game.new()
    game_of_war.player_one.set_hand([])
    # keep going
    game_of_war.run_round
    #now you know what whould happen... including which cards
    expect(game_of_war.player_one.cards_left).to eq (25)
    expect(game_of_war.player_two.cards_left).to eq (27)
  end
end
