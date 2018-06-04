require('rspec')
require ('playing_card')

describe '#playing_card?' do
  it 'returns the value of an playing card.' do
    card = PlayingCard.new('Ace', 'Spades')
    expect(card.value).to eq (0)
  end
  it 'returns the rank of a playing card' do
    card = PlayingCard.new('9', 'Clubs')
    expect(card.rank).to eq ('9')
  end
  it 'returns the suit of a playing card' do
    card = PlayingCard.new('Queen', 'Diamonds')
    expect(card.suit).to eq ('Diamonds')
  end
  it 'returns the string value of a playing card' do
    card = PlayingCard.new('6', 'Spades')
    expect(card.string_value).to eq ('6 of Spades')
  end
end
