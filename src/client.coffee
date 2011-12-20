dnode = require 'dnode'
config = require '../config'
Logger = require './logger'

module.exports = class Client
	remote: null
	dnode: null
	connection: null
		
	# TODO support host
	constructor: (@port, next) ->
		@log "Connecting to localhost:#{@port}"
		opts =
			port: @port
			reconnect: yes

		# TODO support exposing clients scope
		@dnode = dnode.connect opts, (remote, connection) =>
			@log 'CONNECTED!'
			@remote = remote
			@connection = connection
			next()

	close: -> @connection.end()

	log: (msg) ->
		return if not Logger.log.apply @, arguments
		console.log "[CLIENT:#{@port}] #{msg}"
		