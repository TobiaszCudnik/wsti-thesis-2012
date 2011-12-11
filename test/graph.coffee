config = require '../config'
Client = require '../src/client'
Server = require '../src/server'

# debug
i = require('util').inspect
l = (ms...) -> console.log i m for m in ms  

config.debug = yes

describe 'server', ->
	it 'should listen on a port', (done) -> 
		server = new Server 8756, ->
			i server
			debugger
		yes
#  it 'should allow a client to connect', -> 
#		no.should.eql yes
#  it 'should send messages', -> 
#		no.should.eql yes
#  it 'should receive messages', -> 
#		no.should.eql yes
#
#describe 'client', ->
#	it 'should connect to a port', -> 
#		no.should.eql yes
#	it 'should send messages', -> 
#		no.should.eql yes
#	it 'should receive messages', -> 
#		no.should.eql yes
#	it 'should reconnect if connection lost', -> 
#		no.should.eql yes