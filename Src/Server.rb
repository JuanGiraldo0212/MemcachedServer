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
        @cache.purgeExpiredKeys
        command=data[0]

        if command.eql? "add"
            return @cache.add(data[1],data[2].to_i,data[3].to_i,data[4].to_i,data[5])
        elsif command.eql? "set"
            return @cache.set(data[1],data[2].to_i,data[3].to_i,data[4].to_i,data[5])

        elsif command.eql? "replace"
            return @cache.replace(data[1],data[2].to_i,data[3].to_i,data[4].to_i,data[5])

        elsif command.eql? "append"
            return @cache.append(data[1],data[2].to_i,data[3].to_i,data[4].to_i,data[5])

        elsif command.eql? "prepend"
            return @cache.preppend(data[1],data[2].to_i,data[3].to_i,data[4].to_i,data[5])

        elsif command.eql? "cas"
            return @cache.cas(data[1],data[2].to_i,data[3].to_i,data[4].to_i,data[5],data[6].to_i)

        elsif command.eql? "get"
            return @cache.get(data[1])

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

 

