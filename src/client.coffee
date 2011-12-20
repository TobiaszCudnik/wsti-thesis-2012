dnode = require 'dnode'
config = require '../config'
Logger = require './logger'

module.exports = class Client
	scope: null
	dnode: null
	connection: null
		
	# TODO support host
	constructor: (@port, next, name = '') ->
		@log "Connecting to localhost:#{@port}"
		opts =
			port: @port

		@dnode = dnode.connect opts, (scope, connection) =>
			@scope = scope
			@connection = connection
			next @scope

	close: ->
		@connection.end()

	log: (msg) ->
		return if not Logger.log.apply @, arguments
		console.log "[CLIENT:#{@port}] #{msg}"
		