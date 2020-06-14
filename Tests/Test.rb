require 'rspec/autorun'
require_relative '../src/Cache'

describe Cache do
    let(:cache){Cache.new(1000)}
    #########################
    #####Tests for set#######
    #########################
    it "Sets a value in the cache normally" do
        expect(cache.set("1",30,200,1000,"Test")).to eq("Data stored successfully")
    end

    #########################
    #####Tests for add#######
    #########################

    it "Adds a value in the cache normally" do
        expect(cache.add("1",30,200,1000,"Test")).to eq("Data stored successfully")
    end

    it "Adds a value in the cache and it already exists" do
        cache.set("1",30,200,100,"Test")
        expect(cache.add("1",30,200,1000,"Test")).to eq("The data already exists")
    end

    #########################
    ####Tests for replace####
    #########################

    it "Replaces a value in the cache normally" do
        cache.set("1",30,200,1000,"Test")
        expect(cache.replace("1",30,200,1000,"Test")).to eq("Data stored successfully")
    end

    it "Replaces a value in the cache and it does not exist" do
        expect(cache.replace("1",30,200,1000,"Test")).to eq("Data does not exist")
    end

    #########################
    ####Tests for append#####
    #########################

    it "Appends a value to an already stored value in the cache" do
        cache.set("1",30,200,1000,"Test")
        expect(cache.append("1",30,200,1000,"Ok")).to eq("Data stored successfully")
    end

    it "Appends a value in the cache and it does not exist" do
        expect(cache.append("1",30,200,1000,"Ok")).to eq("Data does not exist")
    end

    #########################
    ####Tests for prepend####
    #########################

    it "Prepends a value to an already stored value in the cache" do
        cache.set("1",30,200,1000,"Test")
        expect(cache.preppend("1",30,200,1000,"Ok")).to eq("Data stored successfully")
    end

    it "Prepends a value in the cache and it does not exist" do
        expect(cache.preppend("1",30,200,1000,"Ok")).to eq("Data does not exist")
    end

    #########################
    #####Tests for cas#######
    #########################

    it "Cas a value to an already stored value in the cache" do
        cache.set("1",30,200,1000,"Test")
        cache.gets(["1"])
        expect(cache.cas("1",30,200,1000,"Ok",1)).to eq("Data stored successfully")
    end

    it "Cas a value in the cache and it was updated" do
        cache.set("1",30,200,1000,"Test")
        cache.gets(["1"])
        cache.gets(["1"])
        expect(cache.cas("1",30,200,1000,"Ok",1)).to eq("Data has been updated since you read it last")
    end

    #########################
    #####Tests for get#######
    #########################

    it "Gets a value from the cache normally" do
        cache.set("1",30,200,1000,"Test")
        expect(cache.get("1")).to eq("Test")
    end

    it "Can not find they specified key" do
        expect(cache.get("1")).to eq("Key not found")
    end

    it "Gets a value from the cache after replacing" do
        cache.set("1",30,200,1000,"Test")
        cache.replace("1",30,200,1000,"Test2")
        expect(cache.get("1")).to eq("Test2")
    end

    it "Get a value after appending" do
        cache.set("1",30,200,1000,"Test")
        cache.append("1",30,200,1000,"Ok")
        expect(cache.get("1")).to eq("TestOk")
    end

    it "Get a value after prepending" do
        cache.set("1",30,200,1000,"Test")
        cache.preppend("1",30,200,1000,"Ok")
        expect(cache.get("1")).to eq("OkTest")
    end

    it "Get a value after being deleted by the LRU" do
        cache.set("1",30,200,1000,"Test")
        cache.set("2",30,500,1000,"Test")
        cache.set("3",30,500,1000,"Test")
        expect(cache.get("1")).to eq("Key not found")
    end

    #########################
    #####Tests for gets######
    #########################

    it "Gets a value from the cache normally" do
        cache.set("1",30,200,1000,"Test")
        expect(cache.gets(["1"])).to eq("Test 1 ")
    end

    it "Gets multiple values from the cache normally" do
        cache.set("1",30,200,1000,"Test1")
        cache.set("2",30,200,1000,"Test2")
        cache.set("3",30,200,1000,"Test3")
        expect(cache.gets(["1","2","3"])).to eq("Test1 1 Test2 2 Test3 3 ")
    end

    it "Gets a value from the cache but it does not exist" do
        expect(cache.gets(["1"])).to eq("Key not found")
    end

end