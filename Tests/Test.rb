require 'rspec/autorun'
require_relative '../src/Cache'

describe Cache do
    let(:cache){Cache.new(1000)}
    it "Sets a value in the cache" do
        expect(cache.set("1",30,1000,200,"Test")).to eq("Data stored successfully")
    end
end