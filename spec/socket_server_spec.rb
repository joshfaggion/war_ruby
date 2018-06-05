require 'socket'
require 'pry'
require 'socket_server'
require 'rspec'

class MockSocketClient
  def initialize(port)
    @socket = TCPSocket.new 'localhost', port
  end

  def enter_input(input)
    @socket.puts(input)
  end

  def take_in_output(delay=0.4)
    sleep(delay)
    @output = @socket.read_nonblock(2999)
  rescue IO::WaitReadable
    @output=''
  end

  def close_socket
    @socket.close if @socket
  end
end

describe '#socket_server' do
  before(:each) do
    @clients = []
    @server = SocketServer.new
  end

  after(:each) do
    @server.stop
    @clients.each do |client|
      client.close_socket
    end
  end

  it 'is not listening to a port before it actually started' do
    expect {MockSocketClient.new(@server.port_number)}.to raise_error(Errno::ECONNREFUSED)
  end

  it 'accepts some clients and should run a game if its possible' do
    @server.start
    client1 = MockSocketClient.new(@server.port_number)
    @clients.push(client1)
    @server.accept_new_client("Player 1")
    @server.create_game_if_possible
    expect(@server.games.count).to be 0
    client2 = MockSocketClient.new(@server.port_number)
    @clients.push(client2)
    @server.accept_new_client("Player 2")
    @server.create_game_if_possible
    expect(@server.games.count).to be 1
  end
  # Write other tests and test other things.
  it 'tells the player to prepare for war!' do
    @server.start
    client1 = MockSocketClient.new(@server.port_number)
    @clients.push(client1)
    @server.accept_new_client("Player 1")
    @server.create_game_if_possible
    client2 = MockSocketClient.new(@server.port_number)
    @clients.push(client2)
    @server.accept_new_client("Player 2")
    @server.prepare_player()
    expect(client1.take_in_output.chomp).to eq "Prepare for war, my lord!"
    expect(client2.take_in_output.chomp).to eq "Prepare for war, my lord!"
  end
    #  Make sure the next round isn't played until both clients say they are ready to play
  it 'should say the game is not ready to be played until set to be ready' do
    @server.start
    client1 = MockSocketClient.new(@server.port_number)
    @clients.push(client1)
    @server.accept_new_client("Player 1")
    @server.create_game_if_possible
    client2 = MockSocketClient.new(@server.port_number)
    @clients.push(client2)
    @server.accept_new_client("Player 2")
    @server.prepare_player
    @server.create_game_if_possible
    expect(@server.ready_to_play?).to eq false
    client1.enter_input('yes')
    client2.enter_input('yes')
    expect(@server.ready_to_play?).to eq true
  end
  # What other tests?
end
