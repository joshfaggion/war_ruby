require 'socket'
require 'pry'


loop do
  begin
  client = TCPSocket.new '192.168.0.5', 3000
  puts client.gets
  puts client.gets
  answer = ''
  until answer == "yes\n"
    answer = gets
  end
  client.puts answer
  puts "Waiting for opponent's response..."
  while true
    puts client.gets
    answer = ''
    until answer == "yes\n"
      answer = gets
     end
    client.puts answer
    puts "Waiting for opponent's response..."
    answer = ''
    puts client.gets
    puts client.gets
  end
  rescue Errno::ECONNREFUSED
    puts "Waiting for server to start..."
    sleep(2)
  end
end

#  def run_game(game)
#     game_id = @games.keys.index(game)
#     inform_clients_ready(game)
#     until winner?(game)
#       ready_to_play?(game)
#       run_round(game_id)
#       cards_in_hands(game)
#       inform_clients_ready(game)
#       end
#     end
#     end_game(game)
#   end
