require 'socket'
puts "Server port:"
port=gets.to_i
s = TCPSocket.new 'localhost', port
puts "[Client] Started"
while line = gets 
    break if line =~ /quit/
    s.puts(line)
  puts "[Server] "+ s.gets         
end

s.close            