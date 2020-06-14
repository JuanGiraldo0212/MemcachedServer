class Cache
    require_relative "Entry"
    def initialize(size)
        @hashmap={}
        @start=nil
        @last=nil
        @size=size
        @cas=0
    end

    def printList
        node = @start
        puts (node.key)
        while (node = node.right)
          puts (node.key)
        end
    end

    def getHashSize()
        return @hashmap.size
    end

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

    def gets(keys)
        data=""
        keys.each do |key|
            if @hashmap.key?(key)
                entry=@hashmap[key]
                removeNode(entry)
                addAtTop(entry)
                @cas+=1
                entry.cas=@cas
                data+= entry.value + " "+@cas+"\n"
            end
          end
          return data
    end

    def cacheSize
        sum=0
        node = @start
        if node.nil? == false
            sum+=node.size
            while (node = node.right)
            sum+=node.size
            return sum
            end
        end
        return sum
    end

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

    def purgeExpiredKeys
        node = @start
        if node.time<Time.now and node.time!=0
            @hashmap.delete(@node.key)
            removeNode(@node)
        end
        while (node = node.right)
            if node.time<Time.now and node.time!=0
                @hashmap.delete(@node.key)
                removeNode(@node)
            end
        end
    end


    def append(key,value,size,time)
        if @hashmap.key?(key)
            entry=@hashmap[key]
            entry.value = entry.value+value
            entry.size=size
            entry.time=time
            removeNode(entry)
            addAtTop(entry)
            return "Data stored successfully"
        else
            return "The data does not exist"
        end
        
    end

    def preppend(key,value,size,time)
        if @hashmap.key?(key)
            entry=@hashmap[key]
            entry.value = value+entry.value
            entry.size=size
            entry.time=time
            removeNode(entry)
            addAtTop(entry)
            return "Data stored successfully"
        else
            return "The data does not exist"
        end
    end

    def replace(key,flag,size,time,value)
        if @hashmap.key?(key)
            entry=@hashmap[key]
            entry.value = value
            entry.size=size
            entry.time=time
            removeNode(entry)
            addAtTop(entry)
            return "Data stored successfully"
        else
            return "Data does not exist"
        end
    end

    def cas(key,value,time,size,cas)
        if @hashmap.key?(key)
            entry=@hashmap[key]
            if cas == entry.cas
                entry.value = value
                entry.size=size
                entry.time=time
                removeNode(entry)
                addAtTop(entry)
                return "Data stored successfully"
            else 
                return "Data has been updated since you read it last"
            end
        end
    end

    def set(key,flag,time,size,value)
        if @hashmap.key?(key)
            entry=@hashmap[key]
            entry.value = value
            entry.size=size
            entry.time=time
            entry.flag=flag
            removeNode(entry)
            addAtTop(entry)
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
        end
        return "Data stored successfully"
    end

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
        
            


            

