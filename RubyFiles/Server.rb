require_relative "Cache"
class Server
    def initialize(port,size)
        require 'socket'   
        puts("[Server] Server started")
        @server = TCPServer.new(port.to_i)
        @cache=Cache.new(size)
        puts("[Server] Listening for clients...")
    end

    def processPetition(data)
        command=data[0]

        if command.eql? "add"
            @cache.add(data[1],data[2],data[3],data[4])
        elsif command.eql? "set"
            @cache.putEntry(data[1],data[2],data[3],data[4])

        elsif command.eql? "replace"
            @cache.replace(data[1],data[2],data[3],data[4])

        elsif command.eql? "append"
            @cache.append(data[1],data[2],data[3],data[4])

        elsif command.eql? "prepend"
            @cache.preppend(data[1],data[2],data[3],data[4])

        elsif command.eql? "cas"
            @cache.cas(data[1],data[2],data[3],data[4],data[5])

        elsif command.eql? "get"
            return @cache.getEntry(key)

        elsif command.eql? "gets" 
            return @cache.gets(data.drop(1))

        else
            return command+" is  not listed as a valid command" 
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
                connection.puts processPetition(info)
              end
              connection.puts "Closing the connection. Bye!"
              connection.close
            end
          end 
        end

end

 

