dnode = require 'dnode'
http = require 'http'
# TODO loose
_ = require 'underscore'
flow = require 'flow'
connect = require 'connect'

jsprops = require 'jsprops'
property = jsprops.property
signal = jsprops.signal
SignalsMixin = jsprops.SignalsMixin
EventEmitter2Async = require('eventemitter2async').EventEmitter2

config = require '../config'
Logger = require './logger'

mixin = require('./utils').mixin

### CONTRACTS ###
if config.contracts
	contracts = require './contracts/server'

	TServerClass = contracts.TServerClass
	TServer = contracts.TServer
	TRestServerClass = contracts.TRestServerClass
	TRestServer = contracts.TRestServer
### CONTRACTS END ###

# TODO mixin
class Server extends EventEmitter2Async
#	TODO mixin @, SignalsMixin
	mixin Server, SignalsMixin

	dnode: property 'dnode'
	address: property 'address'
	server: property 'server'
	clients: property 'clients'

	constructor: (address, scope, next) ->
		if config.contracts
			TThis :: TServer
			TThis = @
		@initSignals()
		@address address
#		@log "Starting server on #{address.host}:#{address.port}"
		@dnode dnode scope
		@clients []

		# Socket listener
		# TODO move to method
		params =
			host: address.host
			port: address.port
			block: @newClient.bind @

		@dnode().listen params
		@server @dnode().server
		@dnode().on 'ready', next

		# HTTP listener
#		@server = new http.Server
#		@dnode.listen @server
#		@log "Binding to port #{@port}"
#		@server.listen @port, next
	newClient: signal('newClient', on:
		(next, ret, remote, connection) ->
			# Add a new client.
			@clients().push
				remote: remote
				connection: connection

			# Bind signal to the connection.
			connection.on 'end', @clientDisconnect.bind @, connection

			@log "Client #{connection.id} connected."
			(ret ?= []).push connection.id
			next ret
	)

	clientDisconnect: signal('clientDisconnect', on:
		(next, ret, connection) ->
			# remove the dead client, then remove empty array elements
			# TODO use proto sugar
			@clients _.compact _.map @clients(), (client) ->
				client if client.connection isnt connection
	)

	close: signal( 'close', on: (next, ret) ->
		@server().once 'close', next.bind null, ret
		@dnode().end()
		@dnode().close()
	)

	log: signal('log', on: (next, ret, args...) ->
		return next ret if not Logger.log.apply @, args
		console.log "[SERVER:#{@address()}] #{args}"
		next ret
	)

#	send: (next) ->
#	listen: (next) ->

# TODO Turn me on
class RestServer extends Server
	rest: property 'rest'

	###
	@param routes Array.<[method, path, callback]>
	###
	constructor: (address, routes, scope, next) ->
		if config.contracts
			TThis :: TRestServer
			TThis = @
		@initSignals()

		handler = connect connect.router (app) ->
			app[ r[0] ] r[1], r[2] for r in routes

		@rest connect()
			.use('/', handler)
			.use (req, res) ->
				res.statusCode = 404
				res.end()

		@rest().listen address.rest_port

		super address, scope, next

	close: signal('close', on: (next, ret) ->
		this_ = @
		# WATCH OUT! Hardcoded class and method names!
		super_ = RestServer.__super__.close
		flow.exec(
			->
				this_.rest().once 'close', @MULTI()
				this_.rest().close()
				super_.call this_, @MULTI()
			next.bind null, ret
		)
	)

e = module.exports = {
	Server
	RestServer
}
if config.contracts
	e.RestServer :: TRestServerClass
	e.RestServer = e.RestServer
	e.Server :: TServerClass
	e.Server = e.Server