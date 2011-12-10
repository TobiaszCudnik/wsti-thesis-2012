io = require 'node2node' 

class module.exports.Client
	constructor: (port, next, name = '') ->
		@socket = new io.nodeClient 'localhost', port: port
		@socket.connect()
		@socket.on 'connect', ->
			console.log "connected #{port}"
			next()
		
		@socket.on 'message', (data) ->
			console.log "Message #{data}"
		
	send: (msg) ->
		@socket.send msg
		
#		socket.send 'some data'