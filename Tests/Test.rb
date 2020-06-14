require 'rspec/autorun'
require_relative '../src/Cache'

describe Cache do
    let(:cache){Cache.new(1000)}
    #########################
    #####Tests for set#######
    #########################
    it "Sets a value in the cache normally" do
        expect(cache.set("1",30,1000,200,"Test")).to eq("Data stored successfully")
    end

    #########################
    #####Tests for add#######
    #########################

    it "Adds a value in the cache normally" do
        expect(cache.add("1",30,1000,200,"Test")).to eq("Data stored successfully")
    end

    it "Adds a value in the cache and it already exists" do
        cache.set("1",30,1000,200,"Test")
        expect(cache.add("1",30,1000,200,"Test")).to eq("The data already exists")
    end

    #########################
    ####Tests for replace####
    #########################

    it "Replaces a value in the cache normally" do
        cache.set("1",30,1000,200,"Test")
        expect(cache.replace("1",30,1000,200,"Test")).to eq("Data stored successfully")
    end

    it "Replaces a value in the cache and it does not exist" do
        expect(cache.replace("1",30,1000,200,"Test")).to eq("Data does not exist")
    end

    #########################
    ####Tests for append#####
    #########################

    it "Appends a value to an already stored value in the cache" do
        cache.set("1",30,1000,200,"Test")
        expect(cache.append("1",30,1000,200,"Ok")).to eq("Data stored successfully")
    end

    it "Appends a value in the cache and it does not exist" do
        expect(cache.append("1",30,1000,200,"Ok")).to eq("Data does not exist")
    end

    #########################
    ####Tests for prepend####
    #########################

    it "Prepends a value to an already stored value in the cache" do
        cache.set("1",30,1000,200,"Test")
        expect(cache.preppend("1",30,1000,200,"Ok")).to eq("Data stored successfully")
    end

    it "Prepends a value in the cache and it does not exist" do
        expect(cache.preppend("1",30,1000,200,"Ok")).to eq("Data does not exist")
    end

    #########################
    #####Tests for cas#######
    #########################

    it "Cas a value to an already stored value in the cache" do
        cache.set("1",30,1000,200,"Test")
        cache.gets(["1"])
        expect(cache.cas("1",30,1000,200,"Ok",1)).to eq("Data stored successfully")
    end

    it "Cas a value in the cache and it was updated" do
        cache.set("1",30,1000,200,"Test")
        cache.gets(["1"])
        cache.gets(["1"])
        expect(cache.cas("1",30,1000,200,"Ok",1)).to eq("Data has been updated since you read it last")
    end

    #########################
    #####Tests for get#######
    #########################

    it "Gets a value from the cache normally" do
        cache.set("1",30,1000,200,"Test")
        expect(cache.get("1")).to eq("Test")
    end

    it "Can not find they specified key" do
        expect(cache.get("1")).to eq("Key not found")
    end

    it "Gets a value from the cache after replacing" do
        cache.set("1",30,1000,200,"Test")
        cache.replace("1",30,1000,200,"Test2")
        expect(cache.get("1")).to eq("Test2")
    end

    it "Get a value after appending" do
        cache.set("1",30,1000,200,"Test")
        cache.append("1",30,1000,200,"Ok")
        expect(cache.get("1")).to eq("TestOk")
    end

    it "Get a value after prepending" do
        cache.set("1",30,1000,200,"Test")
        cache.preppend("1",30,1000,200,"Ok")
        expect(cache.get("1")).to eq("OkTest")
    end

    it "Get a value after being deleted by the LRU" do
        cache.set("1",30,1000,200,"Test")
        cache.set("2",30,1000,500,"Test")
        cache.set("3",30,1000,500,"Test")
        expect(cache.get("1")).to eq("Key not found")
    end

    #########################
    #####Tests for gets######
    #########################

    it "Gets a value from the cache normally" do
        cache.set("1",30,1000,200,"Test")
        expect(cache.gets(["1"])).to eq("Test 1\n")
    end

    it "Gets multiple values from the cache normally" do
        cache.set("1",30,1000,200,"Test1")
        cache.set("2",30,1000,200,"Test2")
        cache.set("3",30,1000,200,"Test3")
        expect(cache.gets(["1","2","3"])).to eq("Test1 1\nTest2 2\nTest3 3\n")
    end

    it "Gets a value from the cache but it does not exist" do
        expect(cache.gets(["1"])).to eq("Key not found\n")
    end

end