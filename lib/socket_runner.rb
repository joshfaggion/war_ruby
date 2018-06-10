require 'socket'
require_relative 'socket_server'

server = SocketServer.new
server.start
loop do
  server.accept_new_client
  game = server.create_game_if_possible
  threads = []
  if game
    threads << Thread.new {
      thread = threads.last
      # server.set_player_hand(game,[PlayingCard.new("Queen", "Diamonds")], 'Player One')
      # server.set_player_hand(game,[PlayingCard.new("5", "Diamonds")], 'Player Two')
      server.run_game(game)
      thread.exit
     }
  end
rescue
  server.stop
end
