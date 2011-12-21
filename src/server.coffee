dnode = require 'dnode'
http = require 'http'

config = require '../config'
Logger = require './logger'

module.exports = class Server
	dnode: null
	port: null
	server: null

	constructor: (@host, @port, scope, next) ->
		@dnode = dnode scope

		# Socket listener
		params =
			host: 'localhost'
			port: @port
			block: (client) =>
				@log "Client #{client} connected."

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