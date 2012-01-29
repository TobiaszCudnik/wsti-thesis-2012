config = require '../config'
Client = require '../src/client'
Server = require('../src/server').Server
RestServer = require('../src/server').RestServer
flow = require 'flow'
net = require 'net'
events = require 'events'
request = require 'request'
_ = require 'underscore'

# debug
config.debug = no
i = require('util').inspect
l = (ms...) -> console.log i m for m in ms

describe 'Server', ->
	port = 8756
	server = null
	scope = (client, connection) ->
		emitter = new events.EventEmitter
		# string property
		@foo = 'bar'
		# echo function
		@echo = (echo) -> echo
		# echo callback
		@callback = (callback, args...) -> callback.apply null, args
		# event emitter func bindings
		@['on'] = emitter.on.bind emitter
		@emit = emitter.emit.bind emitter
		# async version of emit
		@emitAsync = (name, params...) ->
			params = _.union name, params
			setTimeout(
				-> emitter.emit.apply( emitter, params )
				0
			)
		connection.on 'ready', =>
			if client.callback
				callback = -> client.callback('foo')
				setTimeout callback, 0
		# undefined as return needed
		undefined

	# TODO reduce overflow
	beforeEach (next) ->
		server = new Server 'localhost', port, scope, next

	afterEach (next) ->
		server.close next

	it 'should listen on a port', (next) ->
		# check port by a socket connection
		socket = net.connect port
		socket.on 'connect', ->
			socket.destroy()
			next()
		socket.on 'error', ->
			socket.destroy()
			'connection can be established'.should.be.ok

	it 'should allow a client to connect', (next) ->
		client = new Client port, {}, ->
			server.clients.length.should.equal 1
			client.close next

	it 'should dispose the client when disconnected', (next) ->
		client = new Client port, {}, ->
			client.close ->
				server.clients.length.should.equal 0
				next()
	
	it 'should access the client\'s scope', (next) ->
		client = new Client port, client_foo: 'bar', ->
			server.clients[0].remote.client_foo.should.equal 'bar'
			client.close next

describe 'REST Server', ->
	server = null
	port = 8756
	rest_port = 8757
	routes = [
		['get', '/', (req, res) -> res.end 'GET /' ]
		['get', '/foo', (req, res) -> res.end 'GET /foo' ]
	]
	scope = foo: 'bar'

	beforeEach (next) ->
		server = new RestServer 'localhost', rest_port, routes, port, scope, next

	afterEach (next) ->
		server.close next

	it 'should be accessible thou HTTP by a REST API', (next) ->
		request "http://localhost:#{rest_port}", (err, res, body) ->
			body.should.equal 'GET /'
			next()