require_relative "Server"
puts "Define the server port:"
port = gets
puts "Defina the cache size:"
size = gets

server=Server.new(port,size)
server.hadleClients