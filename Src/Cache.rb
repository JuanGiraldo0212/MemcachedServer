#Class that represents the LRU Cache
require_relative 'entry'
class Cache
	END_MESSAGE="END\r\n"
	NOT_STORED_MESSAGE="NOT_STORED\r\n"
	STORED_MESSAGE="STORED\r\n"
	EXISTS_MESSAGE="EXISTS\r\n"
	NOT_FOUND_MESSAGE="NOT_FOUND\r\n"

	#Constructor of the class, it recieves the size of the cache
	def initialize(size)
		@hashmap={}
		@start=nil
		@last=nil
		@size=size
		@cas=0
	end

		#Metohd to print the linked list
	def print_list
		node = @start
		while (node.nil? == false)
			puts(node.value)
			node=node.right
		end
	end

		#Method to get the size of the hashtable
	def get_hash_size()
		return @hashmap.size
	end

	def get_node(key)
		entry=@hashmap[key]
		remove_node(entry)
		add_at_top(entry)
		return entry
	end

		#Method that represents the "Get" command, receives a key or multiple keys
	def get(keys)
		data=''
		keys.each { |key|
			if @hashmap.key?(key)
				entry=get_node(key)
				data+="#{entry.value} #{entry.key.to_s} #{entry.flag.to_s} #{entry.size.to_s}\r\n"
			end
		}
		data+=END_MESSAGE
		return data
	end

		#Method that represents the "Gets" command, receives a key or multiple keys
	def gets(keys)
		data=''
		keys.each { |key|
			if @hashmap.key?(key)
				entry=get_node(key)
				@cas+=1
				entry.cas=@cas
				data+="#{entry.value} #{entry.key.to_s} #{entry.flag.to_s} #{entry.size.to_s} #{@cas.to_s}\r\n"
			end
		}
		data+=END_MESSAGE
		return data
	end

		#Method that returns the current size of the cache
	def cache_size
		sum=0
		node = @start
		while (node.nil? == false)
			sum+=node.size
			node=node.right
		end
		return sum
	end

		#Metohd that represents the command "Add", receives a key, a flag, a size, the ttl and the value
	def add(key,flag,time,size,value,noreply)
		if @hashmap.key?(key)
			entry=get_node(key)
			if noreply==false
				NOT_STORED_MESSAGE
			end
		else
			entry=Entry.new(key,flag,time,size,value)
			check_LRU_size(size)
			@hashmap[key]=entry
			if noreply == false
				STORED_MESSAGE
			end
		end
	end

	#Method that removes the items which ttl has come to an end
	def purge_expired_keys(keys)
		keys.each { |key|
			node=@hashmap[key]
			if node.nil? == false
				if node.time!=0 and node.time<Time.now
					@hashmap.delete(node.key)
					remove_node(node)
				end
			end
		}
	end

	#Method to return the correct time given an int 
	def get_time(time)
		if time==0
			return 0
		elsif time>2592000
			return Time.at(time)
		else
			return Time.new+time
		end
	end

	#Method that updates the attributes of a node but also updates it in the LRU
	def update_node(node,value,size,time,flag)
		node.value=value
		node.size=size
		node.time=time
		node.flag=flag
		remove_node(node)
		add_at_top(node)
	end

	#Metohd that represents the command "Append", receives a key, a flag, a size, the ttl and the value
	def append(key,flag,time,size,value,noreply)
		if @hashmap.key?(key)
			entry=@hashmap[key]
			update_node(entry,entry.value+value,entry.size+size,get_time(time),flag)
			check_LRU_size(size)
			if noreply==false
				STORED_MESSAGE
			end
		else
			if noreply==false
				NOT_STORED_MESSAGE
			end
		end
	end

	#Metohd that represents the command "Prepend", receives a key, a flag, a size, the ttl and the value
	def preppend(key,flag,time,size,value,noreply)
		if @hashmap.key?(key)
			entry=@hashmap[key]
			update_node(entry,value+entry.value,entry.size+size,get_time(time),flag)
			check_LRU_size(size)
			if noreply==false
				STORED_MESSAGE
			end
		else
			if noreply == false
				NOT_STORED_MESSAGE
			end
		end
	end

	#Metohd that represents the command "Replace", receives a key, a flag, a size, the ttl and the value
	def replace(key,flag,time,size,value,noreply)
		if @hashmap.key?(key)
			entry=@hashmap[key]
			update_node(entry,value,size,get_time(time),flag)
			check_LRU_size(size)
			if noreply == false 
				STORED_MESSAGE
			end
		else
			if noreply == false
				NOT_STORED_MESSAGE
			end
		end
	end

	#Metohd that represents the command "Cas", receives a key, a flag, a size, the ttl, the value and a cas value
	def cas(key,flag,time,size,value,cas,noreply)
		if @hashmap.key?(key)
			entry=@hashmap[key]
			if cas == entry.cas
				update_node(entry,value,size,get_time(time),flag)
				check_LRU_size(size)
				if noreply==false
					STORED_MESSAGE
				end
			else 
				if noreply==false
					EXISTS_MESSAGE
				end
			end
		else
			if noreply==false
				NOT_FOUND_MESSAGE
			end
		end
	end

	#Metohd that represents the command "Set", receives a key, a flag, a size, the ttl and the value
	def set(key,flag,time,size,value,noreply)
		if @hashmap.key?(key)
			entry=@hashmap[key]
			update_node(entry,value,size,get_time(time),flag)
			check_LRU_size(size)
		else
			entry=Entry.new(key,flag,time,size,value)
			check_LRU_size(size)
			add_at_top(entry) 
			@hashmap[key]=entry
		end
		if noreply==false
			STORED_MESSAGE
		end
	end

	#Checks if the current item size is larger than the LRU max size and deletes it if it is
	def check_LRU_size(size)
		if cache_size+size > @size
			@hashmap.delete(@last.key)
			remove_node(@last)
		end
	end

	#Method to move a node (Item) to the top of the LRU
	def add_at_top(node)
		#puts(node.key)
		node.right=@start
		node.left=nil
		if @start.nil? == false then @start.left=node end
		@start=node
		if @last.nil? then @last=@start end
	end

		#Method to remove a node(Item) from the LRU
	def remove_node(node)
		#puts(node.key)
		if node.left.nil? == false then node.left.right=node.right else	@start=node.right end
		if node.right.nil? == false then node.right.left=node.left else	@last=node.left end
	end
end