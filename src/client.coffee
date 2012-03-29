dnode = require 'dnode'
config = require '../config'
Logger = require './logger'
{
	SignalsMixin
	property
	signal
} = require 'jsprops'
EventEmitter2Async = require('eventemitter2async').EventEmitter2

if config.contracts
	{
		TDnodeConnect
		TClientClass
		TClient
	} = require('./contracts/client')

mixin = require('./utils').mixin

# TODO mixin EventEmitter2Async, inherit from common object
Client :: TClientClass
Client = class Client extends EventEmitter2Async
	mixin Client, SignalsMixin

	# scope of the server client is connected to
	remote: property 'remote'
	connection: property 'connection'
	# scope of this client, exposed to the server
	scope: property 'scope'
	dnode: property 'dnode'
	address: property 'address'

	constructor: (connection_info, scope, next) ->
		@address connection_info
		@log "Connecting to ", @address()
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
				{ host, port } = @address()?
				@log "ClientEnd"
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
#		return next ret if not Logger.log.apply @, args
		return if not config.debug
				{ host, port } = @address()?
		console.log "[CLIENT:#{host}:#{port}] #{args?.join ', '}"
	)

if config.contracts
	for prop, Tcontr of TClient.oc
		continue if not Client::[prop] or
			prop is 'constructor'
		Client::[prop] :: Tcontr
		Client::[prop] = Client::[prop]

	dnode.connect :: TDnodeConnect
	dnode.connect = dnode.connect

module.exports = Client