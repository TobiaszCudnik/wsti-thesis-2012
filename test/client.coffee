config = require '../config'
Client = require '../src/client'
Server = require('../src/server').Server
RestServer = require('../src/server').RestServer
flow = require 'flow'
net = require 'net'
events = require 'events'
request = require 'request'
_ = require 'underscore'

describe 'Client', ->
	port = 8756
	server = null
	addr = null
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
		addr = host: 'localhost', port: port
		server = new Server addr, scope, next

	afterEach (next) ->
		server.close next

	it 'should connect to a port', (done) ->
		client = new Client addr, {}, ->
			client.close done

	it 'should access scope on the server', (done) ->
		client = new Client addr, {}, ->
			client.remote().foo.should.equal 'bar'
			client.close done

	it 'should receive callbacks from the server', (done) ->
		flow.exec(
			->
				client_scope =
					callback: @MULTI('callback')
					bar: 'foo'
				@client = new Client addr, client_scope, @MULTI('dnode')
			(params) ->
				# TODO named results should be available
				params[1][0].should.equal 'foo'
				@client.close done
		)

	it 'should subscribe to a sync event from the server', (done) ->
		flow.exec(
			->
				@client = new Client addr, {}, @
			(remote, conn) ->
				# TODO check if this is sync-safe
				remote.on 'foo', @
				remote.emit 'foo', 'bar'
			(param) ->
				param.should.equal 'bar'
				@client.close done
		)

	it 'should subscribe to an ASYNC event from the server', (done) ->
		flow.exec(
			->
				@client = new Client addr, {}, @
			(remote, conn) ->
				remote.on 'foo', @
				remote.emitAsync 'foo', 'bar'
			(param) ->
				param.should.equal 'bar'
				@client.close done
		)

	# TODO
#	it 'should reconnect if connection lost', ->
#		no.should.be.ok