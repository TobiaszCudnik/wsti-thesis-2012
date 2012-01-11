dnode = require 'dnode'
http = require 'http'
_ = require 'underscore'

config = require '../config'
Logger = require './logger'

module.exports = class Server
	dnode: null
	host: null
	port: null
	server: null
	clients: null

	constructor: (@host, @port, scope, next) ->
		@log "Starting server on #{@host}:#{port}"
		@dnode = dnode scope
		@clients = []
		a = @

		# Socket listener
		params =
			host: 'localhost'
			port: @port
			block: (remote, connection) =>
				@clients.push remote: remote, connection: connection
				connection.on 'end', =>
					# remove the dead client, then remove empty array elements
					@clients = _.compact _.map @clients, (client) ->
						return client if client.connection isnt connection

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
		@server.on 'close', next
		@dnode.end()
		@dnode.close()

	log: (msg) ->
		return if not Logger.log.apply @, arguments
		console.log "[SERVER:#{@port}] #{msg}"

#	send: (next) ->
#	listen: (next) ->