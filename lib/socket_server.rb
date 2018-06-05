require 'pry'
require_relative 'game'

class SocketServer
  attr_reader :player_one, :player_two
  def initialize
    @player_one="Available"
    @player_two="Available"
    @games=[]
  end
  def port_number
    2999
  end
  def stop
    @server.close if @server
  end
  def games
    @games
  end
  def start
    @server = TCPServer.new(port_number)
  end

  def accept_new_client(client)
    if @player_one == "Available"
      @player_one = @server.accept_nonblock
    else
      @player_two = @server.accept_nonblock
    end
  rescue IO::WaitReadable, Errno::EINTR
    puts "No client is available my lord!"
  end
  def create_game_if_possible
    if @player_one == "Available" || @player_two == "Available"
      return false
    else
      game = Game.new()
      @games.push(game)
    end
  end

  def prepare_player
    @player_one.puts "Prepare for war, my lord!"
    @player_two.puts "Prepare for war, my lord!"
  end
end
