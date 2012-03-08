dnode = require 'dnode'
config = require '../config'
Logger = require './logger'

jsprops = require 'jsprops'
property = jsprops.property
signal = jsprops.signal
SignalsMixin = jsprops.SignalsMixin
EventEmitter2Async = require('eventemitter2async').EventEmitter2

{
	TDnodeConnect
	TClientClass
	TClient
} = require('./contracts/client')

mixin = require('./utils').mixin

# TODO mixin, inherit from common object
Client :: TClientClass
Client = class Client extends EventEmitter2Async
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
		console.log "[CLIENT:#{@address()}] #{args?.join ', '}"
	)

for prop, Tcontr of TClient.oc
	continue if not Client::[prop] or
		prop is 'constructor'
	Client.prototype :: Tcontr
	Client::[prop] = Client::[prop]

module.exports = Client

if config.contracts
	dnode.connect :: TDnodeConnect
	dnode.connect = dnode.connect