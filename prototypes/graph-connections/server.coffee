SocketServer = require("websocket-server").Server

class module.exports.Server extends SocketServer
	constructor: (port, next) ->
		super()

		@addListener 'listening', next

		@addListener "connection", (connection) =>
			connection.addListener "message", (msg) =>
				console.log "Server #{port} received message"
				# echo server
				@send msg

		console.log "Server listening on #{port}"
		@listen port