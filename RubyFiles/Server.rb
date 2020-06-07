require 'socket'   

=begin
server = TCPServer.new(1234)
begin
    puts "[Server] Server started"
    puts "[Server] Waiting for connections..."
    while connection = server.accept
        while line = connection.gets
            break if line =~ /quit/
            puts line
            connection.puts "Received!\n"
        end
        connection.puts "Closing the connection. Bye!\n"
        connection.close
        #server.close
    end
rescue Errno::ECONNRESET, Errno::EPIPE => e
    puts e.message
    retry
end    
=end
require_relative "Cache"

begin
    cache=Cache.new(4)
    cache.putEntry(1,1)
    cache.putEntry(10,15)
    cache.putEntry(15,10)
    cache.putEntry(10,16)
    cache.putEntry(12,15)
    cache.putEntry(18,10)
    cache.putEntry(13,16)
    puts(cache.getEntry(1))
    puts(cache.getEntry(10))
    puts(cache.getEntry(15))

end