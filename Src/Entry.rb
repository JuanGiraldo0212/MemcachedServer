#Class that represents an entry of the cache
class Entry 
	attr_accessor :value
	attr_accessor :key
	attr_accessor :left
	attr_accessor :right
	attr_accessor :size
	attr_accessor :time
	attr_accessor :cas
	attr_accessor :flag
	#Constructor of the entry, it receives a key, a flag, a size, the ttl and the value
	def initialize(keyIn,flag,time,size,value_in)
	  @value=value_in
		@key=keyIn
		@left=nil
		@right=nil
		@size=size
		#Comparation of time to manage the multiple inputs (0, seconds, or unix time)
		if time==0
			@time=0
		elsif time>2592000
			@time=Time.at(time)
		else
			@time=Time.new+time
		end
		@cas=0
		@flag=flag
	end
end
