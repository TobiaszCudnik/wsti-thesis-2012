dnode = require 'dnode'
config = require '../config'
Logger = require './logger'


### CONTRACTS ###
if config.contracts
	contracts = require './contracts/client'
	TClientClass = contracts.TClientClass
	TDnodeConnect = contracts.TDnodeConnect
	dnode.connect :: TDnodeConnect
	dnode.connect = dnode.connect
### CONTRACTS END ###

Client = class
	# FIXME signals
	remote: null
	connection: null
	scope: null

	constructor: (@connection_info, @scope, next) ->
		@log "Connecting to ", connection_info

		@dnode = dnode @scope
		@dnode.connect connection_info, (remote, connection) =>
			@log 'CONNECTED!'
			@remote = remote
			@connection = connection
			@connection.on 'error', (e) =>
				@log "[ClientError] #{e}"
			@connection.on 'end', (e) =>
				@log "[ClientEnd] #{@port}"
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

if config.contracts
	module.exports :: TClientClass
	module.exports = module.exports