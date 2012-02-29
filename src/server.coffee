dnode = require 'dnode'
http = require 'http'
_ = require 'underscore'
flow = require 'flow'
connect = require 'connect'

config = require '../config'
Logger = require './logger'
debugger
# Contract.
TCallback = ? -> Any

# Contract, depends on dnode.
TDnode = ?! (x) -> x.constructor is dnode

# Contract.
TDnodeClient = ? {
	remote: TDnode
	# TODO typeme
	connection: Any
}

# TODO
#TEventEmitter = ?

# Contract.
TServer = ? (Str, Num, Any, TCallback?) ==> {
	close: (TCallback) -> Null
	# TODO
	server:
		on: (Str, TCallback) -> Any
		emit: -> Any
	clients: [...TDnodeClient]?
	host: Str
	port: Num
	dnode: TDnode?
	newClient: (TDnode, Any) -> None
}

# Contract.
TRestRoutes = ?! (x) -> yes
# TODO
#	for route in x
#		return no if x isnt Function

# Contract.
TRestServer = ? (Str, Num, [...Str] or Null, Num, TRestRoutes?, TCallback?) ==>
	{
		close: (TCallback) -> Null
	}

#Server :: TServer
Server = class Server
	dnode: null
	host: null
	port: null
	server: null
	clients: null

	constructor: (@host, @port, scope, next) ->
		@log "Starting server on #{@host}:#{port}"
		@dnode = dnode scope
		@clients = []

		# Socket listener
		# TODO move to method
		params =
			host: 'localhost'
			port: @port
			block: @newClient.bind @

		@dnode.listen params
		@server = @dnode.server
		@dnode.on 'ready', next

		# HTTP listener
#		@server = new http.Server
#		@dnode.listen @server
#		@log "Binding to port #{@port}"
#		@server.listen @port, next
	newClient: (remote, connection) =>
		@clients.push remote: remote, connection: connection
		connection.on 'end', =>
			# remove the dead client, then remove empty array elements
			@clients = _.compact _.map @clients, (client) ->
				client if client.connection isnt connection

		@log "Client #{connection.id} connected."

	close: (next) ->
		@server.once 'close', next
		@dnode.end()
		@dnode.close()

	log: (msg) ->
		return if not Logger.log.apply @, arguments
		console.log "[SERVER:#{@port}] #{msg}"

#	send: (next) ->
#	listen: (next) ->

RestServer :: TRestServer
RestServer = class extends Server
	rest: null
	rest_port: null

	###
	@param routes Array.<[method, path, callback]>
	###
	constructor: (host, @rest_port, routes, port, scope, next) ->
		handler = connect connect.router (app) ->
			app[ r[0] ] r[1], r[2] for r in routes

		@rest = connect()
			.use('/', handler)
			.use (req, res) ->
				res.statusCode = 404
				res.end()

		@rest.listen @rest_port

		super host, port, scope, next

	close: (next) ->
		this_ = @
		# WATCH OUT! Hardcoded class and method names!
		super_ = RestServer.__super__.close
		flow.exec(
			->
				this_.rest.once 'close', @MULTI()
				this_.rest.close()
				super_.call this_, @MULTI()
			next
		)

module.exports = {
	Server
	RestServer
}