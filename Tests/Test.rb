require 'rspec/autorun'
require_relative '../src/Cache'

describe Cache do
    let(:cache){Cache.new(1000)}
    #########################
    #####Tests for set#######
    #########################
    it "Sets a value in the cache normally" do
        expect(cache.set("1",30,1000,200,"Test",false)).to eq("STORED\r\n")
    end

    #########################
    #####Tests for add#######
    #########################

    it "Adds a value in the cache normally" do
        expect(cache.add("1",30,1000,200,"Test",false)).to eq("STORED\r\n")
    end

    it "Adds a value in the cache and it already exists" do
        cache.set("1",30,1000,200,"Test",false)
        expect(cache.add("1",30,1000,200,"Test",false)).to eq("NOT_STORED\r\n")
    end

    #########################
    ####Tests for replace####
    #########################

    it "Replaces a value in the cache normally" do
        cache.set("1",30,1000,200,"Test",false)
        expect(cache.replace("1",30,1000,200,"Test",false)).to eq("STORED\r\n")
    end

    it "Replaces a value in the cache and it does not exist" do
        expect(cache.replace("1",30,1000,200,"Test",false)).to eq("NOT_STORED\r\n")
    end

    #########################
    ####Tests for append#####
    #########################

    it "Appends a value to an already stored value in the cache" do
        cache.set("1",30,1000,200,"Test",false)
        expect(cache.append("1",30,1000,200,"Ok",false)).to eq("STORED\r\n")
    end

    it "Appends a value in the cache and it does not exist" do
        expect(cache.append("1",30,1000,200,"Ok",false)).to eq("NOT_STORED\r\n")
    end

    #########################
    ####Tests for prepend####
    #########################

    it "Prepends a value to an already stored value in the cache" do
        cache.set("1",30,1000,200,"Test",false)
        expect(cache.preppend("1",30,1000,200,"Ok",false)).to eq("STORED\r\n")
    end

    it "Prepends a value in the cache and it does not exist" do
        expect(cache.preppend("1",30,1000,200,"Ok",false)).to eq("NOT_STORED\r\n")
    end

    #########################
    #####Tests for cas#######
    #########################

    it "Cas a value to an already stored value in the cache" do
        cache.set("1",30,1000,200,"Test",false)
        cache.gets(["1"])
        expect(cache.cas("1",30,1000,200,"Ok",1,false)).to eq("STORED\r\n")
    end

    it "Cas a value in the cache and it was updated" do
        cache.set("1",30,1000,200,"Test",false)
        cache.gets(["1"])
        cache.gets(["1"])
        expect(cache.cas("1",30,1000,200,"Ok",1,false)).to eq("EXISTS\r\n")
    end

    #########################
    #####Tests for get#######
    #########################

    it "Gets a value from the cache normally" do
        cache.set("1",30,1000,200,"Test",false)
        expect(cache.get(["1"])).to eq("Test 1 30 200\r\nEND\r\n")
    end

    it "Gets multiple values from the cache normally" do
        cache.set("1",30,1000,200,"Test1",false)
        cache.set("2",30,1000,200,"Test2",false)
        cache.set("3",30,1000,200,"Test3",false)
        expect(cache.get(["1","2","3"])).to eq("Test1 1 30 200\r\nTest2 2 30 200\r\nTest3 3 30 200\r\nEND\r\n")
    end

    it "Can not find they specified key" do
        expect(cache.get(["1"])).to eq("END\r\n")
    end

    it "Gets a value from the cache after replacing" do
        cache.set("1",30,1000,200,"Test",false)
        cache.replace("1",30,1000,200,"Test2",false)
        expect(cache.get(["1"])).to eq("Test2 1 30 200\r\nEND\r\n")
    end

    it "Get a value after appending" do
        cache.set("1",30,1000,200,"Test",false)
        cache.append("1",30,1000,200,"Ok",false)
        expect(cache.get(["1"])).to eq("TestOk 1 30 200\r\nEND\r\n")
    end

    it "Get a value after prepending" do
        cache.set("1",30,1000,200,"Test",false)
        cache.preppend("1",30,1000,200,"Ok",false)
        expect(cache.get(["1"])).to eq("OkTest 1 30 200\r\nEND\r\n")
    end

    it "Get a value after being deleted by the LRU" do
        cache.set("1",30,1000,200,"Test",false)
        cache.set("2",30,1000,500,"Test",false)
        cache.set("3",30,1000,500,"Test",false)
        expect(cache.get(["1"])).to eq("END\r\n")
    end

    #########################
    #####Tests for gets######
    #########################

    it "Gets a value from the cache normally" do
        cache.set("1",30,1000,200,"Test",false)
        expect(cache.gets(["1"])).to eq("Test 1 30 200 1\r\nEND\r\n")
    end

    it "Gets multiple values from the cache normally" do
        cache.set("1",30,1000,200,"Test1",false)
        cache.set("2",30,1000,200,"Test2",false)
        cache.set("3",30,1000,200,"Test3",false)
        expect(cache.gets(["1","2","3"])).to eq("Test1 1 30 200 1\r\nTest2 2 30 200 2\r\nTest3 3 30 200 3\r\nEND\r\n")
    end

    it "Gets a value from the cache but it does not exist" do
        expect(cache.gets(["1"])).to eq("END\r\n")
    end

end