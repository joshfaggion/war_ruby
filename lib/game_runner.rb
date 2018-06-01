require_relative('game')

war = Game.new()
war.begin_game

puts 'Beginning Game...'
until war.winner == true do
  puts "#{war.run_round(false)}"
end

puts "Winner: #{war.game_winner}"
