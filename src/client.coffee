SocketClient = require('websocket-client').WebSocket
config = require '../config'
Logger = require './logger'

module.exports = class Client extends SocketClient
	scope: null
		
	# TODO support host
	constructor: (@port, next, name = '') ->
		@log "Connecting to localhost:#{@port}"
		dnode.connect @port, =>
			@scope = dnode
			next @scope

	log: (msg) ->
		return if not Logger.log.apply @, arguments
		console.log "[CLIENT:#{@port}] #{msg}"
		