config = require '../config'
Client = require '../src/client'
Server = require '../src/server'
flow = require 'flow'

# debug
i = require('util').inspect
l = (ms...) -> console.log i m for m in ms  
config.debug = no

describe 'server', ->
	server = null
	port = 8756
	beforeEach (done) -> server = new Server ++port, done
		
	afterEach ->
		# close all connections
		server.manager.forEach flow.define(
			(conn) -> conn.close @MULTI()
			# TODO collect free ports, reuse
		)
				
	it 'should listen on a port', -> server.port.should.equal port
								
	it 'should allow a client to connect', (done) ->
		client = null
		client = new Client port, ->
			server.server.connections.should.equal 1
			done()
		yes
				
	it 'should send messages', (done) -> 
		msg = 'foo'
		client = null
		# msg flow
		server.addListener 'connection', (connection) ->
			server.send connection.id, msg
				
		client = new Client port, ->
			client.on 'message', (message) ->
				message.should.equal msg
				done()

  it 'should receive messages', (done) -> 
		msg = 'foo'
		client = null
		# msg flow
		server.addListener 'connection', flow.define(
			(connection) -> connection.addListener "message", @
			# echo server
			(message) -> message.should.equal msg
		)
				
		client = new Client port, ->
			client.send msg
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