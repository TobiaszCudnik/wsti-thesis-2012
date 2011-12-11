SocketServer = require("websocket-server").Server
http = require 'http'
config = require '../config'

Server = class module.exports extends SocketServer
	debug: true
	constructor: (@port, next) ->
		# TODO needed?
#		@server = http.createServer()
#		super server: @server, debug: @debug
		super debug: @debug

		@addListener 'listening', next

		@addListener "connection", (connection) =>
			@log "Got new connection #{connection.id}"
			connection.addListener "message", (message) =>
				@log "Got message: #{message}"
#				console.log "Server #{port} received message"
				# echo server
				@send connection.id, message
		
		@addListener "disconnect", (connection) =>
			@log "Disconnected with #{connection.id}"

		@log "Listening on #{@port}"
		@listen @port

	log: (msg) ->
		return if not config.debug
		config.log? and config.log.push msg 
		console.log "[SERVER:#{@port}] #{msg}"