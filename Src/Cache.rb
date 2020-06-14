#Class that represents the LRU Cache
class Cache
    require_relative "Entry"
    #Constructor of the class, it recieves the size of the cache
    def initialize(size)
        @hashmap={}
        @start=nil
        @last=nil
        @size=size
        @cas=0
    end

    #Metohd to print the linked list
    def printList
        node = @start
        puts (node.key)
        while (node = node.right)
          puts (node.key)
        end
    end

    #Method to get the size of the hashtable
    def getHashSize()
        return @hashmap.size
    end

    #Method that represents the "Get" command, receives a key
    def get(key)
        if @hashmap.key?(key)
            entry=@hashmap[key]
            removeNode(entry)
            addAtTop(entry)
            return entry.value
        else
            return "Key not found"
        end
    end

    #Method that represents the "Gets" command, receives a key or multiple keys
    def gets(keys)
        data=""
        keys.each { |key|
            if @hashmap.key?(key)

                entry=@hashmap[key]
                removeNode(entry)
                addAtTop(entry)
                @cas+=1
                entry.cas=@cas
                data+=entry.value+" "+@cas.to_s+" "
            else
                data+="Key not found"
            end
        }
        return data
    end

    #Method that returns the current size of the cache
    def cacheSize
        sum=0
        node = @start
        while (node.nil? == false)
            sum+=node.size
            node=node.right
        end
        puts sum 
        return sum
    end

    #Metohd that represents the command "Add", receives a key, a flag, a size, the ttl and the value
    def add(key,flag,size,time,value)
        if @hashmap.key?(key)
            entry=@hashmap[key]
            removeNode(entry)
            addAtTop(entry)
            return "The data already exists"
        else
            entry=Entry.new(key,flag,size,time,value)
            if cacheSize+size > @size
                @hashmap.delete(@last.key)
                removeNode(@last)
                addAtTop(entry) 
            else
                addAtTop(entry)
            end
            @hashmap[key]=entry
            return "Data stored successfully"
        end
    
    end

    #Method that removes the items which ttl has come to an end
    def purgeExpiredKeys
        node = @start
        if node.nil? == false
            if node.time!=0 and node.time<Time.now
                @hashmap.delete(node.key)
                removeNode(node)
            end
            while (node = node.right)
                if node.time!=0 and node.time<Time.now
                    @hashmap.delete(node.key)
                    removeNode(node)
                end
            end
        end
        
    end

    #Method to return the correct time given an int 
    def getTime(time)
        if time==0
            return 0
        elsif time>2592000
            return Time.at(time)
        else
            return Time.new+time
        end
    end

    #Metohd that represents the command "Append", receives a key, a flag, a size, the ttl and the value
    def append(key,flag,size,time,value)
        if @hashmap.key?(key)
            entry=@hashmap[key]
            entry.value = entry.value+value
            entry.size=size
            entry.time=getTime(time)
            entry.flag=flag
            removeNode(entry)
            addAtTop(entry)
            return "Data stored successfully"
        else
            return "Data does not exist"
        end
        
    end

    #Metohd that represents the command "Prepend", receives a key, a flag, a size, the ttl and the value
    def preppend(key,flag,size,time,value)
        if @hashmap.key?(key)
            entry=@hashmap[key]
            entry.value = value+entry.value
            entry.size=size
            entry.time=getTime(time)
            entry.flag=flag
            removeNode(entry)
            addAtTop(entry)
            return "Data stored successfully"
        else
            return "Data does not exist"
        end
    end

    #Metohd that represents the command "Replace", receives a key, a flag, a size, the ttl and the value
    def replace(key,flag,size,time,value)
        if @hashmap.key?(key)
            entry=@hashmap[key]
            entry.value = value
            entry.size=size
            entry.time=getTime(time)
            entry.flag=flag
            removeNode(entry)
            addAtTop(entry)
            return "Data stored successfully"
        else
            return "Data does not exist"
        end
    end

    #Metohd that represents the command "Cas", receives a key, a flag, a size, the ttl, the value and a cas value
    def cas(key,flag,time,size,value,cas)
        if @hashmap.key?(key)
            entry=@hashmap[key]
            if cas == entry.cas
                entry.value = value
                entry.size=size
                entry.time=getTime(time)
                entry.flag=flag
                removeNode(entry)
                addAtTop(entry)
                return "Data stored successfully"
            else 
                return "Data has been updated since you read it last"
            end
        end
    end

    #Metohd that represents the command "Set", receives a key, a flag, a size, the ttl and the value
    def set(key,flag,size,time,value)
        if @hashmap.key?(key)
            entry=@hashmap[key]
            entry.value = value
            entry.size=size
            entry.time=getTime(time)
            entry.flag=flag
            removeNode(entry)
            addAtTop(entry)
        else
            entry=Entry.new(key,flag,size,time,value)
            if cacheSize+size > @size
                @hashmap.delete(@last.key)
                puts "Delted"
                removeNode(@last)
                addAtTop(entry) 
            else
                addAtTop(entry)
            end
            @hashmap[key]=entry
        end
        return "Data stored successfully"
    end

    #Method to move a node (Item) to the top of the LRU
    def addAtTop(node)
        #puts(node.key)
        node.right=@start
        node.left=nil
        unless @start.nil?
            @start.left=node
        end
        @start=node
        if @last.nil?
            @last=@start
        end
    end

    #Method to remove a node(Item) from the LRU
    def removeNode(node)
        #puts(node.key)
        unless node.left.nil?
            node.left.right=node.right
        else
            @start=node.right
        end

        unless node.right.nil?
            node.right.left=node.left
        else
            @last=node.left
        end
    end
end
        
            


            

