class Entry 
    def initialize(keyIn,valueIn)
        @value=valueIn
        @key=keyIn
        @left=nil
        @right=nil
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