require('rspec')
require('game')

describe '#game?' do
  it 'should decrease player ones hand while increasing player twos hand' do
    game_of_war = Game.new()
    game_of_war.player_one.set_hand([PlayingCard.new("10", "Diamonds")])
    game_of_war.player_two.set_hand([PlayingCard.new("Queen", "Diamonds")])
    # keep going
    game_of_war.run_round
    the_inside_of_deck = 0
    #now you know what whould happen... including which cards
    expect(game_of_war.player_one.cards_left).to eq (0)
    expect(game_of_war.player_two.deck[the_inside_of_deck].size).to eq (2)
  end
end
