{
	RestServer
	Server
} = require './server'
Client = require './client'
Service = require './service'
require 'sugar'
EventEmitter2Async = require('eventemitter2async').EventEmitter2
config = require '../config'
flow = require 'flow'
{
	SignalsMixin
	property
	signal
} = require 'jsprops'

{ mixin } = require './utils'

if config.contracts
	{
		TNodeConstructor
		TNodeClass
	} = require './contracts/node'

# TODO EventEmitter2Async, inherit from general object
Node :: TNodeConstructor
Node = class Node extends EventEmitter2Async
	mixin Node, SignalsMixin

	##############
	# PROPERTIES #
	##############

	address: property 'address'
	server: property 'server'
	scope: property('scope', null, {})
	clients: property('clients', null, [])

	###########
	# METHODS #
	###########

	###*
	Callback is fired once servers are up.
	###
	constructor: (address, next) ->
		@address address
		# register callback
		# TODO expose a semaphore, merge with connecting to
		# the planner node
		@initializeServer_ next
		# mixed in method from Signals
		@initScope()
		@initSignals()

	initScope: ->
		signals = @scope()
		for name in @getSignals()
			# bind signal to this context, so it can be detached
			signals[ name ] = @[ name ].bind @
			# bind getter methods, so we'll be async safe
			# TODO find a better way to do this (support exports on a function)
			for getter, fn of @[ name ]()
				signals[ "#{name}_" ] ?= {}
				signals[ "#{name}_" ][ getter ] = fn.bind @
			# preserve constructor to allow type checking
			# TODO needed?
#			signals[ name ].constructor = jsprops.Signal
		@scope signals

	connectToNode: (address, next) ->
		@clients().push new Client address, @scope(), next
		@clients().last()

	initializeServer_: (next) ->
		addr = @address()
		if addr.rest_port
			@server new RestServer(
				addr, addr.rest_port, @getRestRoutes(), @scope(), next
			)
		# Init socket-only server if applicable.
		else @server new Server(
			addr, @scope(), next
		)

	emit: (name) ->
		@log "emit #{name}"
		super

	on: (name) ->
		@log "bind to #{name}"
		super

	log: (args...) ->
		console.log.apply null, args if config.debug-

	###########
	# SIGNALS #
	###########

	###*
	This signal is special, as it can't be fully async safe via network.
	Closing a connection prevents us from sending the callback back over the
	network, thus you shouldn't bind to an after event.
	###
	close: signal( 'close', after: flow.define(
		(@next, @ret) ->
			# TODO support no server scenario
			@this.server().close @MULTI 'server'
			for conn in @this.clients() or []
				conn.close @MULTI 'clients'
		-> @next @ret
	))

	start: signal('start')

	# TODO
	newClient: signal( 'newClient' )

	# clientClose().on :: (TCallback, Any, TClient) -> Any
	clientClose: signal( 'clientClose', on: (next, ret, client) ->
		@clients().remove client
		next ret
	)

	serverStart: signal( 'serverStart', (emit) ->
		@start().once (next, ret) =>
			@server().on 'ready', emit
			next ret
	)

	serverClose: signal( 'serverClose', (emit) ->
		# FIXME double once error in eventemitterasync !!!
		# rebasing the github fork should fix it
#		@start().once (next, ret) =>
#			@server().on 'close', emit
#			next ret
	)

	getClients: signal('getClient', on: (next, ret) ->
		next ret.union @clients()
	)

	setClients: signal('setClients', on: (next, ret, val) ->
		val ?= []
		new_clients = for i in val
			val[ i ] if val[ i ] not in @clients()
		val.forEach (client, i) =>
			new_clients[ i ].on 'close', =>
				@clientClose client, next
		# TODO unbind from non existing clients
		@clients val
	, [])

	# TODO
#	restRoutes: signal('restRoutes', on: (next, ret) ->
##		ret.push ...
#		next ret
#	)

if config.contracts
	for prop, Tcontr of TNodeClass.oc
		continue if not Node::[prop] or
			prop is 'constructor'
		Node::[prop] :: Tcontr
		Node::[prop] = Node::[prop]

module.exports = Node