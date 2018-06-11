require 'socket'

quit_game = false

loop do
  begin
  client = TCPSocket.new 'localhost', 3000
  puts client.gets # welcome message
  puts client.gets # ready to play game message
  answer = ''
  until answer == "yes\n"
    answer = gets.downcase
  end
  client.puts answer
  puts "Waiting for opponent's response..."
  while true
    question = client.gets # Are you ready to play next round message
    puts question
    answer = ''
    if question == "The game has been completed!\n" # whether they want to play again or not
      puts "Do you want to play again?"
      answer = gets.downcase # recieving input from the user
      if answer == "yes\n"
        break
      else
        quit_game = true # will break the program entirely out of the loop
        break
      end
    end
    until answer == "yes\n"
      answer = gets
     end
    client.puts answer
    puts "Waiting for opponent's response..."
    answer = ''
    puts client.gets # game output - what just got played
    puts client.gets # cards left
  end
  rescue Errno::ECONNREFUSED
    puts "Waiting for server to start..."
    sleep(2)
  rescue Errno::EPIPE
    puts "We are having trouble with our server, but we will automatically try to connect, just sit back and relax."
  rescue Errno::ECONNRESET
    puts "Sorry, you are disconnected. The game you were playing is gone."
  end
  if quit_game # breaks totally out of the loop
    break
  end
end
