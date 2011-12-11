SocketClient = require('websocket-client').WebSocket
config = require '../config'

Client = class module.exports extends SocketClient
	# TODO support host
	constructor: (@port, next, name = '') ->
		@log "Connecting to localhost:#{@port}"
		super "ws://localhost:#{@port}/#{name}"

		@on 'open', (sessionId) =>
			next()
			@log "Websocket opened"

		@on 'close', (sessionId) ->
			@log "Websocket closed"

#		@on 'message', (message) =>
#			@log "Got message: #{message}"
#			@close()

	log: (msg) ->
		return if not config.debug
		config.log? and config.log.push msg
		console.log "[CLIENT:#{@port}] #{msg}"