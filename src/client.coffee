dnode = require 'dnode'
config = require '../config'
Logger = require './logger'

jsprops = require 'jsprops'
property = jsprops.property
signal = jsprops.signal
SignalsMixin = jsprops.SignalsMixin
EventEmitter2Async = require('eventemitter2async').EventEmitter2

mixin = require('./utils').mixin


### CONTRACTS ###
if config.contracts
	contracts = require './contracts/client'
	TClientClass = contracts.TClientClass
	TDnodeConnect = contracts.TDnodeConnect
	dnode.connect :: TDnodeConnect
	dnode.connect = dnode.connect
### CONTRACTS END ###

# TODO mixin, inherit from common object
class Client extends EventEmitter2Async
	mixin Client, SignalsMixin

	remote: property 'remote'
	connection: property 'connection'
	scope: property 'scope'
	dnode: property 'dnode'
	address: property 'address'

	constructor: (connection_info, scope, next) ->
		@log "Connecting to ", connection_info
		@initSignals()

		@scope scope
		@dnode dnode @scope()
		@dnode().connect connection_info, (remote, connection) =>
			@log 'CONNECTED!'
			@remote remote
			@connection connection
			@connection().on 'error', (e) =>
				@log "[ClientError] #{e}"
			@connection().on 'end', =>
				@log "[ClientEnd] #{@address()}"
			next remote, connection
#			@connection.on 'read', ->
#				next remote, connection

	close: signal('close', on: (next, ret) ->
		@connection().once 'end', next.bind null, ret
		@connection().end()
	)

	# TODO test contracts on this buggy one
#	close: (next) ->
#		@connection.once 'end', next
#		@connection.end()

	log: signal('log', on: (next, ret, args...) ->
		return next ret if not Logger.log.apply @, args
		console.log "[CLIENT:#{@address()}] #{msg}"
	)

module.exports = Client

if config.contracts
	module.exports :: TClientClass
	module.exports = module.exports