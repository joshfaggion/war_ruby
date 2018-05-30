require('rspec')
require ('playing_card')

describe '#playing_card?' do
  it 'returns the value of an playing card.' do
    card = PlayingCard.new('Ace', 'Spades')
    expect(card.value).to eq (0)
  end
end
