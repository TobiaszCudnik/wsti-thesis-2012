dnode = require 'dnode'
config = require '../config'
Logger = require './logger'

module.exports = class Server
	dnode: null
		
	constructor: (@port, scope, next) ->
		@dnode = dnode scope
		@dnode.listen @port
		@log "Binding to port #{@port}"

	log: (msg) ->
		return if not Logger.log.apply @, arguments
		console.log "[SERVER:#{@port}] #{msg}"

#	send: (next) ->
#	listen: (next) ->