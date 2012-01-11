config = require '../config'
Client = require '../src/client'
Server = require '../src/server'
flow = require 'flow'
net = require 'net'
events = require 'events'
_ = require 'underscore'

# debug
config.debug = no
i = require('util').inspect
l = (ms...) -> console.log i m for m in ms

describe 'Connection Graph', ->
	port = 8756
	describe 'Milestone1', ->
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
			server = new Server 'localhost', ++port, scope, next

		afterEach ->
			# close all connections
			# TODO collect free ports, reuse
			# TODO handle Error: connect ECONNRESET
#			server.close next
			# async server close
			server.close

		describe 'server', ->

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

			it 'should access the dispose client when disconnected', (next) ->
				client = new Client port, {}, ->
					client.close ->
						server.clients.length.should.equal 0
						next()

			it 'should access the client\'s scope', (next) ->
				client = new Client port, client_foo: 'bar', ->
					server.clients[0].remote.client_foo.should.equal 'bar'
					client.close next

		describe 'client', ->
#
			it 'should connect to a port', (done) ->
				client = new Client port, {}, ->
					client.close done

			it 'should access scope on the server', (done) ->
				client = new Client port, {}, ->
					client.remote.foo.should.equal 'bar'
					client.close done

			it 'should receive callbacks from the server', (done) ->
				flow.exec(
					->
						client_scope =
							callback: @MULTI('callback')
							bar: 'foo'
						@client = new Client port, client_scope, @MULTI('dnode')
					(params) ->
						# TODO named results should be available
						params[1][0].should.equal 'foo'
						@client.close done
				)

			it 'should subscribe to a sync event from the server', (done) ->
				flow.exec(
					->
						@client = new Client port, {}, @
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
						@client = new Client port, {}, @
					(remote, conn) ->
						remote.on 'foo', @
						remote.emitAsync 'foo', 'bar'
					(param) ->
						param.should.equal 'bar'
						@client.close done
				)

#		describe 'server', ->
#
#			it 'should access the client\'s scope', (done) ->
#			it 'should allow a client to connect', (done) ->
#				client = null
#				client = new Client port, ->
#					server.server.connections.should.equal 1
#					done()
#				yes
#
#			it 'should send messages', (done) ->
#				msg = 'foo'
#				client = null
#				server.addListener 'connection', (connection) ->
#					server.send connection.id, msg
#					done()
#
#				client = new Client port
#
#			it 'should receive messages', (done) ->
#				msg = 'foo'
#				client = null
#				# msg flow
#				server.addListener 'connection', flow.define(
#					(connection) -> connection.addListener "message", @
#					(message) ->
#						message.should.equal msg
#						done()
#				)
#
#				client = new Client port, ->
#					client.send msg
#
#	describe 'Milestone2', ->
#		server = null
#		# TODO reduce overflow
#		beforeEach (done) ->
#			server = new Server ++port, done
#		afterEach ->
#			# close all connections
#			server.manager.forEach flow.define(
#				(conn) -> conn.close @MULTI()
#				# TODO collect free ports, reuse
#			)
#
#		# TODO
#		describe 'client', ->
#			it 'TODO should reconnect if connection lost', ->
#				no.should.be.ok
#				server.addListener 'connection', (connection) ->
#					server.send connection.id, ''
#
#				client = new Client port, ->
#					client.on 'message', (message) ->
#
#		describe 'server', ->
#			# TODO
#			it 'TODO should be accessible thou HTTP', ->
#				no.should.be.ok
#
#	describe 'Milestone2', ->
#		describe 'server', ->
#			# TODO
#			it 'TODO should have encrypted connection', ->
#				no.should.be.ok