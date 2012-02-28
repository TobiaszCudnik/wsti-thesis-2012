dnode = require 'dnode'
#dnode = require 'dnode/browser/index'
config = require '../config'
Logger = require './logger'

# Contract.
TCallback = ? -> Any

# Contract, depends on dnode.
TDnode = ?! (x) -> x.constructor is dnode

# Contract.
dnode.connect :: ({
		port: Num, reconnect: Bool?, proto: Str?, host: Str?
	}, ( (TDnode, Any) -> Any ) ) -> Any
dnode.connect = dnode.connect

# Contract.
module.exports :: (Num, Any, TCallback) -> {
	remote: TDnode
	connection: Any # TODO
	scope: Any # TODO
	close: (TCallback) -> Any
}

module.exports = class Client
	remote: null
	connection: null
	scope: null
		
	# FIXME support host
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
