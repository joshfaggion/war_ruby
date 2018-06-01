require('rspec')
require('game')

describe '#game?' do
  it 'should decrease player ones hand while increasing player twos hand' do
    game_of_war = Game.new()
    game_of_war.player_one.set_hand([PlayingCard.new("10", "Diamonds")])
    game_of_war.player_two.set_hand([PlayingCard.new("Queen", "Diamonds")])
    game_of_war.run_round
    inside_of_deck = 0
    expect(game_of_war.player_one.cards_left).to eq (0)
    expect(game_of_=war.player_two.deck[inside_of_deck].size).to eq (2)
   end
  it 'should tie twice and then be won by player one on the third draw' do
    game_of_wars = Game.new
    game_of_wars.player_one.set_hand([PlayingCard.new("5", "Diamonds"), PlayingCard.new("Queen", "Hearts"), PlayingCard.new("6", "Clubs")])
    game_of_wars.player_two.set_hand([PlayingCard.new("5", "Hearts"), PlayingCard.new("Queen", "Spades"), PlayingCard.new("2", "Spades")])
    inside_of_deck = 0
    expect(game_of_wars.run_round).to eq ("Player One took the 6 of Clubs, and the 2 of Spades!")
    expect(game_of_wars.player_one.deck[0].length).to eq (6)
    expect(game_of_wars.player_two.deck.length).to eq (0)
  end
end
