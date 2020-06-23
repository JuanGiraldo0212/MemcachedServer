require_relative 'cache'
#Class that helps the server process the client requests and interacts with the cache
class Petition_handler

  CLIENT_ERROR_MESSAGE="CLIENT_ERROR the input does NOT conform to the protocol in some way\r\n"
	ERROR_MESSAGE="ERROR\r\n"
	GET_COMMAND='get'
	GETS_COMMAND='gets'
	SET_COMMAND='set'
	ADD_COMMAND='add'
	REPLACE_COMMAND='replace'
	APPEND_COMMAND='append'
	PREPEND_COMMAND='prepend'
	CAS_COMMAND='cas'
	NOREPLY_COMMAND='noreply'
  CLIENT_ERROR_SIZE="CLIENT_ERROR the data block does NOT match the defined size\r\n"

  #Method to start the handler, it recieves the size of the cache
  def initialize(size)
		@cache=Cache.new(size)
	end	
  
  #Method handle a petition of a user, it receives the petition and also the user 
  def handle_petition(petition,connection)
    info=petition.split(' ')
		if info[0].eql? GET_COMMAND or info[0].eql? GETS_COMMAND
		  response=process_retrieval_petition(info)
			response=response.gsub("\r\n","-")
			return response
		else
		  value=connection.gets
			value.delete!("\n")
			puts '[Client] '+value
			response=process_addition_petition(info,value)
			if response.nil? == false
				response=response.gsub("\r\n","-")
				return response
			else
				return ''
			end
    end
  end

  #Method to process a addition petition of a client, here the Cache is called to serve the client
	def process_addition_petition(data,value)
		if data.length()>=5
			command=data[0]
			noreply=false
			if data.length()==6
				if data[5].eql? NOREPLY_COMMAND
					noreply=true
				end
			elsif data.length()==7
				if data[6].eql? NOREPLY_COMMAND
					noreply=true
				end
			end
			if data[4].to_i == value.bytesize
				case command
				when ADD_COMMAND
					@cache.add(data[1],data[2].to_i,data[3].to_i,data[4].to_i,value,noreply)
				when  SET_COMMAND
					@cache.set(data[1],data[2].to_i,data[3].to_i,data[4].to_i,value,noreply)
				when  REPLACE_COMMAND
					@cache.replace(data[1],data[2].to_i,data[3].to_i,data[4].to_i,value,noreply)
				when  APPEND_COMMAND
					@cache.append(data[1],data[2].to_i,data[3].to_i,data[4].to_i,value,noreply)
				when  PREPEND_COMMAND
					@cache.preppend(data[1],data[2].to_i,data[3].to_i,data[4].to_i,value,noreply)
				when  CAS_COMMAND
					@cache.cas(data[1],data[2].to_i,data[3].to_i,data[4].to_i,value,data[5].to_i,noreply)
				else
					ERROR_MESSAGE
				end
			else
				return CLIENT_ERROR_SIZE
			end
		else
			return CLIENT_ERROR_MESSAGE
		end
  end
  
  ##Method to process a retrieval petition of a client, here the Cache is called to serve the client
  def process_retrieval_petition(data)
		if data.length()>=2
			command=data[0]
			keys=data.drop(1)
      @cache.purge_expired_keys(keys)
      case command
			when GET_COMMAND
				return @cache.get(keys)
			when GETS_COMMAND 
				return @cache.gets(keys)
			else
				return ERROR_MESSAGE 
			end
		else
			return CLIENT_ERROR_MESSAGE
		end
	end
end