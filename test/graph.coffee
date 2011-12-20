config = require '../config'
Client = require '../src/client'
Server = require '../src/server'
flow = require 'flow'
net = require 'net'

# debug
config.debug = no
i = require('util').inspect
l = (ms...) -> console.log i m for m in ms

describe 'Connection Graph', ->
	port = 8756
	describe 'Milestone1', ->
		server = null
		scope = foo: 'bar'

		# TODO reduce overflow
		beforeEach (next) ->
			server = new Server ++port, scope, next

		afterEach ->
			# close all connections
			# TODO collect free ports, reuse
			server.close()

		describe 'server', ->

			it 'should listen on a port', (next) ->
				socket = net.connect port
				socket.on 'connect', ->
					socket.destroy()
					next()
				socket.on 'error', ->
					socket.destroy()
					'connection can be established'.should.be.ok
		#
		describe 'client', ->

			it 'should connect to a port', (done) ->
				client = new Client port, done

			it 'should send messages', (done) ->
				client = new Client port, ->
					client.send 'foo'
					done()
		#		no.should.eql yes
			it 'should receive messages', (done) -> 
				msg = 'foo'
				client = null
				server.addListener 'connection', (connection) ->
					server.send connection.id, msg

				client = new Client port, ->
					client.on 'message', (message) ->
						message.should.equal msg
						done()

		describe 'server', ->

			it 'should allow a client to connect', (done) ->
				client = null
				client = new Client port, ->
					server.server.connections.should.equal 1
					done()
				yes

			it 'should send messages', (done) -> 
				msg = 'foo'
				client = null
				server.addListener 'connection', (connection) ->
					server.send connection.id, msg
					done()

				client = new Client port

			it 'should receive messages', (done) -> 
				msg = 'foo'
				client = null
				# msg flow
				server.addListener 'connection', flow.define(
					(connection) -> connection.addListener "message", @
					(message) ->
						message.should.equal msg
						done()
				)

				client = new Client port, ->
					client.send msg

	describe 'Milestone2', ->
		server = null
		# TODO reduce overflow
		beforeEach (done) ->
			server = new Server ++port, done
		afterEach ->
			# close all connections
			server.manager.forEach flow.define(
				(conn) -> conn.close @MULTI()
				# TODO collect free ports, reuse
			)

		# TODO
		describe 'client', ->
			it 'TODO should reconnect if connection lost', ->
				no.should.be.ok
				server.addListener 'connection', (connection) ->
					server.send connection.id, ''

				client = new Client port, ->
					client.on 'message', (message) ->

		describe 'server', ->
			# TODO
			it 'TODO should be accessible thou HTTP', ->
				no.should.be.ok

	describe 'Milestone2', ->
		describe 'server', ->
			# TODO
			it 'TODO should have encrypted connection', ->
				no.should.be.ok