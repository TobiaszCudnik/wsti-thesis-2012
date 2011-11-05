SocketClient = require('websocket-client').WebSocket

class module.exports.Client extends SocketClient
	constructor: (port, name = '') ->
		console.log "module.exports.Client #{name}#{port}"
		super "ws://localhost:#{port}/#{name}", "#{name}#{port}"

		@on 'open', (sessionId) =>
		    console.log "Websocket open with session id: #{sessionId}"
		    @send 'This is a test message'

		@on 'close', (sessionId) ->
		    console.log "Websocket closed with session id: #{sessionId}"

		@on 'message', (message) =>
		    console.log "Got message: #{message}"
		    @close()