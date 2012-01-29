dnode = require 'dnode'
http = require 'http'
_ = require 'underscore'
flow = require 'flow'
connect = require 'connect'

config = require '../config'
Logger = require './logger'

module.exports.Server = class Server
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
		params =
			host: 'localhost'
			port: @port
			block: (remote, connection) =>
				@clients.push remote: remote, connection: connection
				connection.on 'end', =>
					# remove the dead client, then remove empty array elements
					@clients = _.compact _.map @clients, (client) ->
						client if client.connection isnt connection

				@log "Client #{connection.id} connected."

		@dnode.listen params
		@server = @dnode.server
		@dnode.on 'ready', next

		# HTTP listener
#		@server = new http.Server
#		@dnode.listen @server
#		@log "Binding to port #{@port}"
#		@server.listen @port, next

	close: (next) ->
		@server.once 'close', next
		@dnode.end()
		@dnode.close()

	log: (msg) ->
		return if not Logger.log.apply @, arguments
		console.log "[SERVER:#{@port}] #{msg}"

#	send: (next) ->
#	listen: (next) ->

module.exports.RestServer = class RestServer extends Server
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