class Entry 
    def initialize(keyIn,flag,valueIn,size,time)
        @value=valueIn
        @key=keyIn
        @left=nil
        @right=nil
        @size=size
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

    def flag
        @flag
    end

    def flag=(flag)
        @flag=flag
    end

    def cas
        @cas
    end

    def cas=(cas)
        @cas=cas
    end

    def size
        @size
    end

    def size=(size)
        @size=size
    end

    def time
        @time
    end

    def time=(time)
        @time=time
    end

    def value
        @value
    end

    def value=(value)
        @value=value
    end

    def key
        @key
    end

    def left
        @left
    end

    def right
        @right
    end

    def left=(left)
        @left=left
    end

    def right=(right)
        @right=right
    end
end