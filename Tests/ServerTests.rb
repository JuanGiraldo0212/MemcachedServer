require 'rspec/autorun'
require 'socket'
require_relative '../src/Server'

describe Server do

    before(:all) do
        @clients =Array.new(100) #Change the number of concurrent users
        i=0
            while i<@clients.length() do
                @clients[i]= TCPSocket.new 'localhost', 1234 #Change the Ip and the port
                i+=1
            end
      end

    it "Test concurrent set" do
        i=0
        while i<@clients.length() do
            @clients[i].puts("set "+i.to_s+" "+i.to_s+" 1000 200")
            @clients[i].puts("Test"+i.to_s)
            expect(@clients[i].gets).to eq("STORED-\n")
            i+=1
        end

    end

    it "Test concurrent add" do
        i=0
        while i<@clients.length() do
            @clients[i].puts("add "+i.to_s+" "+i.to_s+" 1000 200")
            @clients[i].puts("Test"+i.to_s)
            expect(@clients[i].gets).to eq("STORED-\n")
            i+=1
        end

    end

    it "Test concurrent replace" do
        i=0
        while i<@clients.length() do
            @clients[i].puts("set "+i.to_s+" "+i.to_s+" 1000 200")
            @clients[i].puts("Test"+i.to_s)
            @clients[i].gets
            @clients[i].puts("replace "+i.to_s+" "+i.to_s+" 1000 200")
            @clients[i].puts("Replace"+i.to_s)
            expect(@clients[i].gets).to eq("STORED-\n")
            i+=1
        end

    end

    it "Test concurrent append" do
        i=0
        while i<@clients.length() do
            @clients[i].puts("set "+i.to_s+" "+i.to_s+" 1000 200")
            @clients[i].puts("Test"+i.to_s)
            @clients[i].gets
            @clients[i].puts("append "+i.to_s+" "+i.to_s+" 1000 200")
            @clients[i].puts("Appended"+i.to_s)
            expect(@clients[i].gets).to eq("STORED-\n")
            i+=1
        end

    end

    it "Test concurrent prepend" do
        i=0
        while i<@clients.length() do
            @clients[i].puts("set "+i.to_s+" "+i.to_s+" 1000 200")
            @clients[i].puts("Test"+i.to_s)
            @clients[i].gets
            @clients[i].puts("prepend "+i.to_s+" "+i.to_s+" 1000 200")
            @clients[i].puts("Prepend"+i.to_s)
            expect(@clients[i].gets).to eq("STORED-\n")
            i+=1
        end

    end

    it "Test concurrent cas" do
        i=0
        while i<@clients.length() do
            @clients[i].puts("set "+i.to_s+" "+i.to_s+" 1000 200")
            @clients[i].puts("Test"+i.to_s)
            @clients[i].gets
            @clients[i].puts("cas "+i.to_s+" "+i.to_s+" 1000 200 0")
            @clients[i].puts("Test"+i.to_s)
            expect(@clients[i].gets).to eq("STORED-\n")
            i+=1
        end

    end

    it "Test concurrent get" do
        i=0
        while i<@clients.length() do
            @clients[i].puts("set "+i.to_s+" "+i.to_s+" 1000 200")
            @clients[i].puts("Test"+i.to_s)
            @clients[i].gets
            @clients[i].puts("get "+i.to_s)
            expect(@clients[i].gets).to eq("Test"+i.to_s+" "+i.to_s+" "+i.to_s+" "+"200-END-\n")
            i+=1
        end

    end

    it "Test concurrent get" do
        i=0
        while i<@clients.length() do
            @clients[i].puts("set "+i.to_s+" "+i.to_s+" 1000 200")
            @clients[i].puts("Test"+i.to_s)
            @clients[i].gets
            @clients[i].puts("gets "+i.to_s)
            expect(@clients[i].gets).to eq("Test"+i.to_s+" "+i.to_s+" "+i.to_s+" "+"200 "+(i+1).to_s+"-END-\n")
            i+=1
        end

    end
    

end