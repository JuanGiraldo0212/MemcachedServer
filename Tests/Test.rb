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

    #########################
    ####Tests for prepend####
    #########################

    #########################
    #####Tests for cas#######
    #########################

    #########################
    #####Tests for get#######
    #########################

    it "Gets a value from the cache normally" do
        cache.set("1",30,1000,200,"Test")
        expect(cache.get("1")).to eq("Test")
    end

    #########################
    #####Tests for gets######
    #########################


end