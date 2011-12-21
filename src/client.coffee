dnode = require 'dnode'
#dnode = require 'dnode/browser/index'
config = require '../config'
Logger = require './logger'

module.exports = class Client
	remote: null
	connection: null
		
	# TODO support host
	constructor: (@port, scope, next) ->
		@log "Connecting to localhost:#{@port}"
		opts =
#			proto: 'http'
#			host: 'localhost'
			port: @port
			reconnect: yes

		# TODO support exposing clients scope
		dnode(scope).connect opts, (remote, connection) =>
			@log 'CONNECTED!'
			@remote = remote
			@connection = connection
			next()

	close: (next) ->
		@connection.once 'end', next
		@connection.end()

	log: (msg) ->
		return if not Logger.log.apply @, arguments
		console.log "[CLIENT:#{@port}] #{msg}"
		