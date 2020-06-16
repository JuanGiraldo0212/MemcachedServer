require_relative "Cache"
#Class that represents a TCP Server
class Server
    #Constructor of the class, receives a port to start the application and the size of the cache
    def initialize(port,size)
        require 'socket'   
        puts("[Server] Server started")
        #The TCP server is initialized
        @server = TCPServer.new(port.to_i)
        #The LRU cache is initialized
        @cache=Cache.new(size)
        puts("[Server] Listening for clients...")
    end

    def processRetrievalPetition(data)
        @cache.purgeExpiredKeys
        if data.length()>=2
            command=data[0]
            if command.eql? "get"
                return @cache.get(data.drop(1))
        
            elsif command.eql? "gets" 
                return @cache.gets(data.drop(1))
            else
                return "ERROR\r\n" 
            end
        else
            return "CLIENT_ERROR the input doesn't conform to the protocol in some way\r\n"
        end


    end
    #Method to process a petition of a client, here the Cache is called to serve the client
    def processAdditionPetition(data,value)
        @cache.purgeExpiredKeys
        if data.length()>=5
            command=data[0]
            noreply=false
    
            if data.length()==6
                if data[5].eql? "noreply"
                    noreply=true
                end
            elsif data.length()==7
                if data[6].eql? "noreply"
                    noreply=true
                end
            end
    
            if command.eql? "add"
                @cache.add(data[1],data[2].to_i,data[3].to_i,data[4].to_i,value,noreply)
            elsif command.eql? "set"
                    @cache.set(data[1],data[2].to_i,data[3].to_i,data[4].to_i,value,noreply)
            elsif command.eql? "replace"
                    @cache.replace(data[1],data[2].to_i,data[3].to_i,data[4].to_i,value,noreply)
            elsif command.eql? "append"
                    @cache.append(data[1],data[2].to_i,data[3].to_i,data[4].to_i,value,noreply)
            elsif command.eql? "prepend"
                    @cache.preppend(data[1],data[2].to_i,data[3].to_i,data[4].to_i,value,noreply)
            elsif command.eql? "cas"
                    @cache.cas(data[1],data[2].to_i,data[3].to_i,data[4].to_i,value,data[5].to_i,noreply)
            else
                "ERROR\r\n"
            end
        else
            return "CLIENT_ERROR the input doesn't conform to the protocol in some way\r\n"
        end
    end

    
    #Method to handle multiple connections from clients to the server
    def hadleClients
        loop do
            Thread.start(@server.accept) do |connection|
                puts("[Server] Client connected")
              while line = connection.gets
                break if line =~ /quit/
                line.delete!("\n")
                puts "[Client] "+line
                info=line.split(' ')
                if info[0].eql? "get" or info[0].eql? "gets"
                    response=processRetrievalPetition(info)
                    response=response.gsub("\r\n","-")
                    connection.puts response
                else
                    value=connection.gets
                    value.delete!("\n")
                    puts "[Client] "+value
                    response=processAdditionPetition(info,value)
                    if response.nil? == false
                    response=response.gsub("\r\n","-")
                    connection.puts response
                    else
                     connection.puts ""
                    end

                end
              end
              connection.puts "Closing the connection. Bye!"
              connection.close
            end
          end 
        end

end

 

