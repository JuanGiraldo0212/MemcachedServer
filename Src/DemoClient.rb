require 'socket'

s = TCPSocket.new 'localhost', 1234

while line = gets 
    break if line =~ /quit/
    s.puts(line)
  puts s.gets         
end

s.close            