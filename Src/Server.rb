require_relative 'petition_handler'
require 'socket'   
#Class that represents a TCP Server
class Server
	#Constructor of the class, receives a port to start the application and the size of the cache
	def initialize(port,size)
		puts('[Server] Server started')
		#The TCP server is initialized
		@server = TCPServer.new(port.to_i)
		#The LRU cache is initialized
		@handler=Petition_handler.new(size)
		puts('[Server] Listening for clients...')
	end	

	#Method to handle multiple connections from clients to the server
	def hadleClients
		semaphore = Mutex.new
		loop do
			Thread.start(@server.accept) do |connection|
				puts('[Server] Client connected')
				while line = connection.gets
					break if line =~ /quit/
					line.delete!("\n")
					puts '[Client] '+line
					semaphore.synchronize {
						connection.puts (@handler.handle_petition(line,connection))
					}
				end
				connection.puts 'Closing the connection. Bye!'
				connection.close
			end
		end 
	end
end
