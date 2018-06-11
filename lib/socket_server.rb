require 'pry'
require_relative 'game'

class SocketServer
  def initialize
    @games={}
    @pending_clients = []
  end

  def port_number
    3000
  end

  def stop
    @server.close if @server
  end

  def start
    @server = TCPServer.new(port_number)
  end

  def accept_new_client(client='Random Player')
    client_connection = @server.accept_nonblock
    @pending_clients.push(client_connection)
    if @pending_clients.size.odd?
      client_connection.puts "Welcome, no other player is available to battle yet. We will continue to search. You are Player One."
    else
      client_connection.puts "Welcome, a player is available for you to fight! You are Player Two."
    end
  rescue IO::WaitReadable, Errno::EINTR
    sleep(0.1)
  end

  def create_game_if_possible
    if @pending_clients.size > 1
      game = Game.new()
      game.begin_game
      games.store(game, @pending_clients.shift(2))
      return game
    else
      return false
    end
  end

  def ready_to_play?(game)
    client1_input = ''
    client2_input = ''
    until client1_input.include?("yes") && client2_input.include?("yes")
      sleep(0.1)
      if client1_input.include?("yes") == false
        client1_input = take_in_output(game, 0)
      end
      if client2_input.include?("yes") == false
        client2_input = take_in_output(game, 1)
      end
    end
    true
  end

  def cards_in_hands(game)
    first_client = games[game][0]
    second_client = games[game][1]
    first_client.puts "You have #{game.player_one.cards_left} cards left in your hand."
    second_client.puts "You have #{game.player_two.cards_left} cards left in your hand."
  end

  def run_round(game)
    first_client = games[game][0]
    second_client = games[game][1]
    results = game.run_round(false)
    first_client.puts results
    second_client.puts results
  end

  def number_of_games
    games.keys.count
  end

  def find_game(game)
    games.keys[game]
  end

  def set_player_hand(game, cards, player)
    if player == 'Player One'
      game.player_one.set_hand(cards)
    else
      game.player_two.set_hand(cards)
    end
  end

  def run_game(game)
    ready_players_for_game(game)
    ready_to_play?(game)
    until winner?(game)
      ready_players_for_round(game)
      ready_to_play?(game)
      run_round(game)
      cards_in_hands(game)
    end
    end_game(game)
  end

  def ready_players_for_round(game)
    ready_message = "Are you ready to start the round? Type yes and then enter to continue."
    games[game][0].puts ready_message
    games[game][1].puts ready_message
  end
  def ready_players_for_game(game)
    game_message = "The Game is starting... Are you ready?"
    games[game][0].puts game_message
    games[game][1].puts game_message
  end

  def winner?(game)
    game.winner
  end

  def end_game(game)
    complete_message = "The game has been completed!"
    games[game][0].puts complete_message
    games[game][1].puts complete_message
    client1 = games[game][0]
    client2 = games[game][1]
    client1.close
    client2.close
    games.reject! {|k| k == game}
  end

  private

  def take_in_output(game, chosen_client)
    sleep(0.1)
    output = ""
    client = games[game][chosen_client]
    output = client.read_nonblock(1000)
    return output
  rescue IO::WaitReadable
    output=''
  end
  def games
    @games
  end
end
