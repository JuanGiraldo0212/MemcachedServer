require 'socket'
#Class to represent a TCP client that can use the functions of the LRU cache
puts "Server port:"
port=gets.to_i
#The client socket is initialized
s = TCPSocket.new 'localhost', port
puts "[Client] Started"
#The user input is processed
while line = gets 
    break if line =~ /quit/
    #The data is passed to the server
    s.puts(line)
    #The server response is printed
  puts "[Server] "+ s.gets         
end

s.close            