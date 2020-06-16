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
    data=line.split(" ")
    if data[0].eql? "get" or data[0].eql? "gets"
      s.puts(line)
    else
      s.puts(line)
      value=gets
      s.puts(value)
    end
    #The server response is printed
    text=s.gets
    text=text.gsub "-","\r\n"
    puts text       
end

s.close            