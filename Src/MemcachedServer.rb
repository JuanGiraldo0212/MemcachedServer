require_relative "Server"
#Class to define the Memcached server and get some user inputs
puts "Define the server port:"
port = gets
puts "Define the cache size:"
size = gets

#Server is initialized
server=Server.new(port,size.to_i)
#The clients are being handled
server.hadleClients
