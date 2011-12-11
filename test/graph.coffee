config = require '../config'
Client = require '../src/client'
Server = require '../src/server'

# debug
i = require('util').inspect
l = (ms...) -> console.log i m for m in ms  
config.debug = no

describe 'server', ->
	server = null
	port = 8756
	beforeEach (done) ->
		# TODO dispose the old server
#		server? and server.
		server = new Server ++port, done
		
	it 'should listen on a port', ->
		server.port.should.equal port
				
	it 'should allow a client to connect', (done) ->
		client = null
		client = new Client port, ->
			server.server.connections.should.equal 1
			done()
		yes
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