dnode = require 'dnode'
#dnode = require 'dnode/browser/index'
config = require '../config'
Logger = require './logger'

module.exports = class Client
	remote: null
	connection: null
	scope: null
		
	# TODO support host
	# TODO? support scope as optional param?
	constructor: (@port, @scope, next) ->
		@log "Connecting to localhost:#{@port}"
		opts =
#			proto: 'http'
#			host: 'localhost'
			port: @port
			reconnect: yes

		@dnode = dnode @scope
		@dnode.connect opts, (remote, connection) =>
			@log 'CONNECTED!'
			@remote = remote
			@connection = connection
			next remote, connection
#			@connection.on 'read', ->
#				next remote, connection

	close: (next) ->
		@connection.once 'end', next
		@connection.end()

	log: (msg) ->
		return if not Logger.log.apply @, arguments
		console.log "[CLIENT:#{@port}] #{msg}"
		