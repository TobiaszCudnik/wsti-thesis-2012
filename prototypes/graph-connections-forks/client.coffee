SocketClient = require('websocket-client').WebSocket

class module.exports.Client extends SocketClient
	# TODO support host
	constructor: (@port, next, name = '') ->
		@log "Connecting to localhost:#{@port}"
		super "ws://localhost:#{@port}/#{name}"

		@on 'open', (sessionId) =>
			next()
			@log "Websocket opened"

		@on 'close', (sessionId) ->
			@log "Websocket closed"

		@on 'message', (message) =>
			@log "Got message: #{message}"
#			@close()

	log: (msg) ->
		console.log "[CLIENT:#{@port}] #{msg}"