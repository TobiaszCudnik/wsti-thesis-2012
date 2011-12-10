io = require '../node_modules/node2node-socket.io' 
	
class module.exports.Server
	constructor: (port, next) ->
		@server = require('http').createServer ->
		@io = io.listen @server
		@server.listen port
		
		@io.sockets.on 'connection', (socket) ->
		  socket.emit 'news', hello: 'world'
		  console.log 'server connectioned'
		
		next()