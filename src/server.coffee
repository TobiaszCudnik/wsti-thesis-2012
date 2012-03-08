dnode = require 'dnode'
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

{
	TServer
	TServerClass
	TRestServer
	TRestServerClass
} = require './contracts/server'

# TODO mixin
Server :: TServerClass
Server = class extends EventEmitter2Async
#	TODO mixin @, SignalsMixin
	mixin @, SignalsMixin

	dnode: property 'dnode'
	address: property 'address'
	server: property 'server'
	clients: property 'clients'

	emit: (name) ->
		@log "emit #{name}" if config.debug
		super

	constructor: (address, scope, next) ->
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
#		@dnode().use (client, remote) =>
#			@newClient client, remote
		@server @dnode().server
		@dnode().on 'ready', next
		@dnode().on 'error', @error

	newClient: signal('newClient', on: (next, ret, remote, connection) ->
		@log 'newClient'
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

	close: signal( 'close', after: (next, ret) ->
		@server().once 'close', =>
			next ret
#			next.bind null, ret
		@dnode().end()
		@dnode().close()
	)

	start: signal('start')

	log: signal('log', on: (next, ret, args...) ->
#		return next ret if not Logger.log.apply @, args
		return if not config.debug
		{ host, port } = @address()
		console.log "[SERVER:#{host}:#{port}] #{args}"
		next ret
	)

	error: signal('error', on: (next, ret, msg) ->
		@log "[ERROR] #{msg}"
		next ret
	)

for prop, Tcontr of TServer.oc
	continue if not Server::[prop] or
		prop is 'constructor'
	Server.prototype :: Tcontr
	Server::[prop] = Server::[prop]

#	send: (next) ->
#	listen: (next) ->

# TODO Turn me on
RestServer :: TRestServerClass
RestServer = class extends Server
#	mixin @, SignalsMixin
	@signal = SignalsMixin.signal

	rest: property 'rest'

	constructor: (address, routes, scope, next) ->
#		@initSignals RestServer
		@initSignals()

		handler = connect connect.router (app) ->
			app[ r[0] ] r[1], r[2] for r in routes

		@rest connect()
			.use('/', handler)
			.use (req, res) ->
				res.statusCode = 404
				res.end()

		# Initialize servers in the same time.
		_this = @
		flow.exec(
			-> _this.initServers_.call @, _this, address, scope
			next
		)

	# TODO Address is passed, as signals aren't ready yet!
	# Inside a flow.
	initServers_: (_this, address, scope) ->
		# Init REST HTTP server.
		_this.rest().listen address.rest_port, address.host, @MULTI 'rest'
		# Init SocketServer from the super constructor.
		RestServer.__super__.constructor.call(
			_this, address, scope, @MULTI 'super'
		)

	close: @signal('close', after: (next, ret) ->
		@rest().once 'close',
			next.bind null,
				(ret or {})['rest'] = 'yes'
		@rest().close()
	)

#for prop, Tcontr of TRestServer.oc
#	continue if not RestServer::[prop] or
#		prop is 'constructor'
#	RestServer.prototype :: Tcontr
#	RestServer::[prop] = RestServer::[prop]

module.exports = {
	Server
	RestServer
}
