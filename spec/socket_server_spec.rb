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

  def take_in_output(delay=0.1)
    sleep(delay)
    @output = @socket.read_nonblock(2999)
  rescue IO::WaitReadable
    @output='No output to take.'
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
    expect(@server.number_of_games).to be 0
    client2 = MockSocketClient.new(@server.port_number)
    @clients.push(client2)
    @server.accept_new_client("Player 2")
    @server.create_game_if_possible
    expect(@server.number_of_games).to be 1
  end

  # Write other tests and test other things.
  it 'tells the player welcome' do
    @server.start
    client1 = MockSocketClient.new(@server.port_number)
    @clients.push(client1)
    @server.accept_new_client("Player 1")
    client2 = MockSocketClient.new(@server.port_number)
    @clients.push(client2)
    @server.accept_new_client("Player 2")
    expect(client1.take_in_output).to eq "Welcome, no other player is available to battle yet. We will continue to search.\n"
    expect(client2.take_in_output).to eq "Welcome, a player is available for you to fight!\n"
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
    @server.create_game_if_possible
    game = 0
    expect(@server.ready_to_play?(game)).to eq false
    client1.enter_input('yes')
    client2.enter_input('yes')
    expect(@server.ready_to_play?(game)).to eq true
  end

  # What other tests?
  it 'tells the third player to wait' do
    @server.start
    client1 = MockSocketClient.new(@server.port_number)
    @clients.push(client1)
    @server.accept_new_client("Player 1")
    client2 = MockSocketClient.new(@server.port_number)
    @clients.push(client2)
    @server.accept_new_client("Player 2")
    client3 = MockSocketClient.new(@server.port_number)
    @clients.push(client3)
    @server.accept_new_client("Player 3")
    @server.create_game_if_possible
    expect(client3.take_in_output).to eq "Welcome, no other player is available to battle yet. We will continue to search.\n"
  end

  context 'when running games' do
    before (:each) do
      @server.start
      client1 = @clients[0]
      client2 = @clients[1]
      client3 = MockSocketClient.new(@server.port_number)
      @clients.push(client3)
      @server.accept_new_client("Player 3")
      client4 = MockSocketClient.new(@server.port_number)
      @clients.push(client4)
      @server.accept_new_client("Player 4")
    end

    it 'returns the players card count of the first game' do
     client1 = @clients[0]
     client2 = @clients[1]
     game = 0
     @server.create_game_if_possible
     client1.take_in_output
     @server.cards_in_hands(game)
     expect(client1.take_in_output).to eq ("You have 26 cards left in your hand.\n")
    end
   # Should this run a round?
    it 'should return the cards left for a second game' do
      client1 = @clients[0]
      client2 = @clients[1]
      @server.create_game_if_possible
      client3 = MockSocketClient.new(@server.port_number)
      @clients.push(client3)
      @server.accept_new_client("Player 3")
      client4 = MockSocketClient.new(@server.port_number)
      @clients.push(client4)
      @server.accept_new_client("Player 4")
      @server.create_game_if_possible
      game = 1
      client4.take_in_output
      @server.cards_in_hands(game)
      expect(client4.take_in_output).to eq ("You have 26 cards left in your hand.\n")
    end
    it 'should return the proper output for player one winning a round' do
      client1 = @clients[0]
      client2 = @clients[1]
      @server.create_game_if_possible
      client1.take_in_output
      client2.take_in_output
      game_id = 0
      game = @server.find_game(game_id)
      @server.set_player_hand(game_id, [PlayingCard.new("10", "Spades")], 'Player One')
      @server.set_player_hand(game_id, [PlayingCard.new("4", "Clubs")], 'Player Two')
      @server.run_round(game_id)
      expect(client1.take_in_output).to eq ("Player One took the 10 of Spades, and the 4 of Clubs!\n")
      expect(client2.take_in_output).to eq ("Player One took the 10 of Spades, and the 4 of Clubs!\n")
    end
    # Test the whole starting process in one big shablooey.
    it 'should run every part up to the second round' do
      client1 = @clients[0]
      client2 = @clients[1]
      game_id = 0
       expect(client1.take_in_output).to eq "Welcome, no other player is available to battle yet. We will continue to search.\n"
       expect(client2.take_in_output).to eq "Welcome, a player is available for you to fight!\n"
      @server.create_game_if_possible
       expect(client1.take_in_output).to eq "This war is ready to commence, are you ready to play?\n"
       expect(client2.take_in_output).to eq "This war is ready to commence, are you ready to play?\n"
       expect(@server.ready_to_play?(game_id)).to eq false
      client1.enter_input('yes')
      client2.enter_input('yes')
       expect(@server.ready_to_play?(game_id)).to eq true
      @server.set_player_hand(game_id, [PlayingCard.new("Queen", "Diamonds"), PlayingCard.new("King", "Diamonds")], 'Player One')
      @server.set_player_hand(game_id, [PlayingCard.new("Jack", "Spades"), PlayingCard.new("2", "Spades")], 'Player Two')
      @server.run_round(game_id)
       expect(client2.take_in_output).to eq ("Player One took the Queen of Diamonds, and the Jack of Spades!\n")
       expect(client1.take_in_output).to eq ("Player One took the Queen of Diamonds, and the Jack of Spades!\n")
       expect(@server.ready_to_play?(game_id)).to eq false
      client1.enter_input('yes')
      client2.enter_input('yes')
       expect(@server.ready_to_play?(game_id)).to eq true
      @server.run_round(game_id)
       expect(client1.take_in_output).to eq ("Player One took the King of Diamonds, and the 2 of Spades!\n")
    end
    # Test winning the game possibly?
    # Test two games going on at the same time.
    it 'should return are you ready? output' do
      client1 = @clients[0]
      client2 = @clients[1]
      client1.take_in_output
      @server.create_game_if_possible
      expect(client1.take_in_output).to eq "This war is ready to commence, are you ready to play?\n"
    end

    it 'waits for input' do
      client1 = @clients[0]
      client2 = @clients[1]
      game_id = 0
      @server.create_game_if_possible
      expect(@server.ready_to_play?(game_id)).to eq false
      sleep(0.3)
      client1.enter_input('yes')
      client2.enter_input('yes')
      expect(@server.ready_to_play?(game_id)).to eq true
    end
  end
end
