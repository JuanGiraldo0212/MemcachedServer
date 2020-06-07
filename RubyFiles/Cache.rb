class Cache
    require_relative "Entry"
    def initialize(size)
        @hashmap={}
        @start=nil
        @last=nil
        @size=size
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

    def getEntry(key)
        if @hashmap.key?(key)
            entry=@hashmap[key]
            removeNode(entry)
            addAtTop(entry)
            return entry.value
        else
            return -1
        end
    end

    def putEntry(key,value)
        if @hashmap.key?(key)
            entry=@hashmap[key]
            entry.value = value
            removeNode(entry)
            addAtTop(entry)
        else
            entry=Entry.new(key,value)
            if @hashmap.size == @size
                #puts("//")
                #puts(@last.key)
                @hashmap.delete(@last.key)
                removeNode(@last)
                addAtTop(entry) 
            else
                addAtTop(entry)
            end
            @hashmap[key]=entry
        end
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
        
            


            

