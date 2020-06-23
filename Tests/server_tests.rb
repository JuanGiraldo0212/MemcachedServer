require 'rspec/autorun'
require 'socket'
require_relative '../src/server'
describe Server do
	before(:all) do
		@clients =Array.new(100) #Change the number of concurrent users
		i=0
		while i<@clients.length() do
			@clients[i]= TCPSocket.new 'localhost', 1234 #Change the Ip and the port
			i+=1
		end
	end
	after(:all) do
		i=0
		while i<@clients.length() do
			@clients[i].close
			i+=1
		end
	end

	it "Test concurrent set" do
		i=0
		while i<@clients.length() do
			@clients[i].puts("set "+i.to_s+" "+i.to_s+" 1000 4")
			@clients[i].puts("Test")
			expect(@clients[i].gets).to eq("STORED-\n")
			i+=1
		end
	end
	it "Test concurrent add" do
		i=100
		while i<@clients.length() do
			@clients[i].puts("add "+i.to_s+" "+i.to_s+" 1000 4")
			@clients[i].puts("Test")
			expect(@clients[i].gets).to eq("STORED-\n")
			i+=1
		end
	end
	it "Test concurrent replace" do
		i=0
		while i<@clients.length() do
			@clients[i].puts("set "+i.to_s+" "+i.to_s+" 1000 4")
			@clients[i].puts("Test")
			@clients[i].gets
			@clients[i].puts("replace "+i.to_s+" "+i.to_s+" 1000 7")
			@clients[i].puts("Replace")
			expect(@clients[i].gets).to eq("STORED-\n")
			i+=1
		end
	end
	it "Test concurrent append" do
		i=0
		while i<@clients.length() do
			@clients[i].puts("set "+i.to_s+" "+i.to_s+" 1000 4")
			@clients[i].puts("Test")
			@clients[i].gets
			@clients[i].puts("append "+i.to_s+" "+i.to_s+" 1000 8")
			@clients[i].puts("Appended")
			expect(@clients[i].gets).to eq("STORED-\n")
			i+=1
		end
	end
	it "Test concurrent prepend" do
		i=0
		while i<@clients.length() do
			@clients[i].puts("set "+i.to_s+" "+i.to_s+" 1000 4")
			@clients[i].puts("Test")
			@clients[i].gets
			@clients[i].puts("prepend "+i.to_s+" "+i.to_s+" 1000 7")
			@clients[i].puts("Prepend")
			expect(@clients[i].gets).to eq("STORED-\n")
			i+=1
		end
	end
	it "Test concurrent cas" do
		i=0
		while i<@clients.length() do
			@clients[i].puts("set "+i.to_s+" "+i.to_s+" 1000 4")
			@clients[i].puts("Test")
			@clients[i].gets
			@clients[i].puts("cas "+i.to_s+" "+i.to_s+" 1000 4 0")
			@clients[i].puts("Test")
			expect(@clients[i].gets).to eq("STORED-\n")
			i+=1
		end
	end
	it "Test concurrent get" do
		i=0
		while i<@clients.length() do
			@clients[i].puts("set "+i.to_s+" "+i.to_s+" 1000 4")
			@clients[i].puts("Test")
			@clients[i].gets
			@clients[i].puts("get "+i.to_s)
			expect(@clients[i].gets).to eq("Test "+i.to_s+" "+i.to_s+" "+"4-END-\n")
			i+=1
		end
	end
	it "Test concurrent gets" do
		i=0
		while i<@clients.length() do
			@clients[i].puts("set "+i.to_s+" "+i.to_s+" 1000 4")
			@clients[i].puts("Test")
			@clients[i].gets
			@clients[i].puts("gets "+i.to_s)
			expect(@clients[i].gets).to eq("Test "+i.to_s+" "+i.to_s+" "+"4 "+(i+1).to_s+"-END-\n")
			i+=1
		end
	end
end
