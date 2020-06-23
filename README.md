# MemcachedServer

## Intent

The present project is an implementation of a TCP memcached server. It was developed using Ruby 2.6 on a Windows 10 machine.

## Deliverables

A Memcached server that provides a sub-set of commands, like this:

### Retrieval commands:
- get
- gets

### Storage commands:
- set
- add
- replace
- append
- prepend
- cas

## Installation:

Clone this repository to any directory in your machine. Inside the cloned repo you will find a folder named src, and inside a file called MemcachedServer.rb,
this file should be executed in order to run the server. The command to run it is ruby MemcachedServer.rb. After running it the server will ask you on which port
you wish to run it and the size of the cache, after answering the server will start to accept clients. To use the services of the server you must start a TCP client,
you can do this in several ways, the most common is starting a telnet connection on the same ip and port as the server telnet (localhost 1234). This project also
provides a demo client, you can run it by executing the ruby file called Democlient.rb (ruby DemoClient.rb).

## Usage

As decribed before this implementation of the server complies with the Memached official protocol specification, so the commands described there work the same on this server. Some examples are:
```
set 1 1 10000 200
test1
```

```
set 2 2 10000 9 noreply
test2
```

```
append 1 1 20000 300
test3
```

```
cas 3 4 1000 300 1
test4
```

```
get 1 2
```

```
gets 1 2 3
```

## Tests

This project has two types of tests, the unitary test and the load tests, the first kind were implemented by using the gem rspec and the second one were implemented by using the gui provided by Apache Jmeter. Inside the project you will find a folder called Tests and inside there will be three files MemcachedServerTestPlan.jmx, CacheTests.rb and ServerTests, the .rb files are the files were the cache unitary tests and the server load tests were implemented, to run this tests you will have to download the rspec gem and the execute the following command <rspec CahceTests.rb> and <rspec ServerTests.rb>. On the other hand you will need to execute the Jmeter load tests manually by importing the .jmx file into Apache Jmeter (The test plan is implemented but there is some issues with the connection).
	 
