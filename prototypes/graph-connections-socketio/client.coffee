io = require("socket.io-client/socket.io").io

class module.exports.Client
	constructor: (port, next, name = '') ->
		@socket = new io.Socket 'localhost', port: port
		@socket.connect()
		@socket.on 'connect', ->
			console.log "connected #{port}"
			next()
		
		@socket.on 'message', (data) ->
			console.log "Message #{data}"
		
	send: (msg) ->
		@socket.send msg
		
#		socket.send 'some data'