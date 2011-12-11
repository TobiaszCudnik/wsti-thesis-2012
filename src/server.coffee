SocketServer = require("websocket-server").Server
config = require '../config'
Logger = require './logger'

module.exports = class Server extends SocketServer
	constructor: (@port, next) ->
		super debug: config.debug

		@addListener 'listening', next

		@addListener "connection", (connection) =>
			@log "Got new connection #{connection.id}"
		
		@addListener "disconnect", (connection) =>
			@log "Disconnected with #{connection.id}"

		@log "Binding to port #{@port}"
		@listen @port

	log: (msg) ->
		return if not Logger.log.apply @, arguments
		console.log "[SERVER:#{@port}] #{msg}"