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

    def getTime(time)
        if time==0
            return 0
        elsif time>2592000
            return Time.at(time)
        else
            return Time.new+time
        end
    end

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
        
            


            

