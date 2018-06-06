require 'pry'
require_relative 'game'

class SocketServer
  def initialize
    @games={}
    @pending_clients = []
  end

  def port_number
    2999
  end

  def stop
    @server.close if @server
  end

  def start
    @server = TCPServer.new(port_number)
  end

  def accept_new_client(client='Random Player')
    client_connection = [client , @server.accept_nonblock]
    @pending_clients.push(client_connection)
    if @pending_clients.size.odd?
      client_connection[1].puts "Welcome, no other player is available to battle yet. We will continue to search."
    else
      client_connection[1].puts "Welcome, a player is available for you to fight!"
    end
  rescue IO::WaitReadable, Errno::EINTR
    puts "No client is available my lord!"
  end

  def create_game_if_possible
    if @pending_clients.size > 1
      game = Game.new()
      game.begin_game
      @games.store(game, @pending_clients.shift(2))

      inform_clients_ready()
    else
      return false
    end
  end

  def ready_to_play?(delay=0.1, game_id)
    sleep(delay)
    responses = [@games.values[game_id][0][1].read_nonblock(1000).chomp, @games.values[game_id][1][1].read_nonblock(1000).chomp]
    if responses[0] == 'yes'
      if responses[1] == 'yes'
        true
      else
        false
      end
    else
      client if responses[1] == 'yes'
      false
    end
  rescue IO::WaitReadable
    return false
  end
  def cards_in_hands(game_id)
    # Fill with code.
    game = @games.keys[game_id]
    first_client = @games.values[game_id][0][1]
    second_client = @games.values[game_id][1][1]
    first_client.puts "You have #{game.player_one.cards_left} cards left in your hand."
    second_client.puts "You have #{game.player_two.cards_left} cards left in your hand."
  end
  def run_round(game_id)
    game = @games.keys[game_id]
    first_client = @games.values[game_id][0][1]
    second_client = @games.values[game_id][1][1]
    results = game.run_round(false)
    first_client.puts results
    second_client.puts results
  end

  def number_of_games
    @games.keys.count
  end

  def find_game(game)
    @games.keys[game]
  end

  def set_player_hand(game_id, cards, player)
    game = find_game(game_id)
    if player == 'Player One'
      game.player_one.set_hand(cards)
    else
      game.player_two.set_hand(cards)
    end
  end

  def run_game(game)
    inform_clients_ready(game)
    until winner? do
      if ready_to_play(game)
        result = game.run_round
        inform_clients_result(game, result)
      end
    end
    end_game(game)
  end

  def inform_clients_ready()
    @games.values.last[0][1].puts "This war is ready to commence, are you ready to play?"
    @games.values.last[1][1].puts "This war is ready to commence, are you ready to play?"
  end

  def winnner?(game)
    game = @games.keys[game_id]
    game.winner
  end
  def inform_clients_results(game, result)
    @games.values.last[0][1].puts result
    @games.values.last[1][1].puts result

  end
end
