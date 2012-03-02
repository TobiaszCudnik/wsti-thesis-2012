dnode = require 'dnode'
#dnode = require 'dnode/browser/index'
config = require '../config'
Logger = require './logger'

### Contracts ###
TCallback = ? -> Any
# Depends on dnode.
TDnode = ?! (x) -> console.log(x); x instanceof dnode
TDnodeCallback = (TDnode, Any) -> Any
TConnectionInfo = ? {
	port: Num
	reconnect: Bool?
	proto: Str?
	host: Str
}
TDnodeConnect = ? (TConnectionInfo, TDnodeCallback) -> Any
TObj = ?! (x) -> typeof x in ['object', 'undefined', 'null']

TClient = ? (TConnectionInfo, TObj, TCallback) ==> {
	remote: Any
	connection: Any # TODO
	scope: Any # TODO
	close: (TCallback) -> Any
}

dnode.connect :: TDnodeConnect
dnode.connect = dnode.connect
### END Contracts ###

Client :: TClient
Client = class
	remote: null
	connection: null
	scope: null
		
	# FIXME support host
	constructor: (@connection_info, @scope, next) ->
		@log "Connecting to ", connection_info

		@dnode = dnode @scope
		@dnode.connect connection_info, (remote, connection) =>
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

module.exports = Client