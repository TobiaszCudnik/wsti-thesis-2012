dnode = require 'dnode'
http = require 'http'

config = require '../config'
Logger = require './logger'

module.exports = class Server
	dnode: null
	port: null
	server: null

	constructor: (@port, scope, next) ->
		@dnode = dnode scope
		@server = new http.Server

		@dnode.listen @server
		@log "Binding to port #{@port}"
		@server.listen @port, next

	close: -> @server.close()

	log: (msg) ->
		return if not Logger.log.apply @, arguments
		console.log "[SERVER:#{@port}] #{msg}"

#	send: (next) ->
#	listen: (next) ->