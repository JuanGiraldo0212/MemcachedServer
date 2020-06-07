require_relative "Cache"
class Server
    def initialize(port,size)
        require 'socket'   
        puts("[Server] Server started")
        @server = TCPServer.new(port.to_i)
        @cache=Cache.new(size)
        puts("[Server] Listening for clients...")
    end

    def processPetition(command,key,value)
        if command.eql? "get"
            return @cache.getEntry(key)
        elsif command.eql? "set"
            @cache.putEntry(key,value)
            return "Succesfully stored"
        elsif command.eql? "help"
            return "get [key]\ngets [cas]\nset [key] [value]\nadd \nreplace\nappend\nprepend\ncas"
        else
            return command+" is  not listed as a valid command, please use help to get a list of commands" 
        end
    end
    
    def hadleClients
        loop do
            Thread.start(@server.accept) do |connection|
                puts("[Server] Client connected")
              while line = connection.gets
                break if line =~ /quit/
                puts "[Client] "+line
                info=line.split(' ')
                command=info[0]
                key=info[1]
                value=info[2]
                connection.puts processPetition(command,key,value)
              end
          
              connection.puts "Closing the connection. Bye!"
              connection.close
            end
          end 
        end

end

 

