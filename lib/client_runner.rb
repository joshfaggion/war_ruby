require 'socket'

quit_game = false

loop do
  begin
  client = TCPSocket.new 'localhost', 3000
  puts client.gets
  puts client.gets
  answer = ''
  until answer == "yes\n"
    answer = gets.downcase
  end
  client.puts answer
  puts "Waiting for opponent's response..."
  while true
    question = client.gets
    puts question
    answer = ''
    if question == "The game has been completed!\n"
      puts "Do you want to play again?"
      answer = gets.downcase
      if answer == "yes\n"
        break
      else
        quit_game = true
        break
      end
    end
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
  rescue Errno::EPIPE
    puts "We are having trouble with our server, but we will automatically try to connect, just sit back and relax."
  rescue Errno::ECONNRESET
    puts "Sorry, you are disconnected. The game you were playing is gone."
  end
  if quit_game == true
    break
  end
end
