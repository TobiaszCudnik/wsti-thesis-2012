RestServer = require('./server').RestServer
Server = require('./server').Server
Client = require './client'
Service = require './service'
PlannerNode = require './plannernode'
require 'sugar'
EventEmitter2Async = require('eventemitter2async').EventEmitter2
config = require '../config'
flow = require 'flow'
jsprops = require('jsprops')
#Semaphore = require('semaphores').Semaphore

# shorthands
property = jsprops.property
signal = jsprops.signal
mixin = require('./utils').mixin

### CONTRACTS ###
if config.contracts
	contracts = require './contracts/node'
	TNode = contracts.TNode
### CONTRACTS END ###

# FIXME scope setter, maybe in contructor
Node = class Node extends EventEmitter2Async
	mixin Node, jsprops.SignalsMixin

	address: property 'address'
	server: property 'server'
	scope: property('scope', null, {})
	clients: property('clients', null, [])
	requires: property 'requires'
	provides: property 'provides'
	planner_node: property 'planner_node'

	constructor: (address, services, next) ->
		# mixed in method from Signals
		@initSignals()

		@requires []
		@provides []
		@address address

		@addRequire requires for requires in services?.requires?
		@addProvide provides for provides in services?.provides?

		@initScope()

		# creates @server
		@connectToGraph()

		@start().once next

	# TODO expose signals
	initScope: ->
		signals = {}
		@getSignals().forEach (name) =>
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

	###*
	This signal is special, as it can't be fully async via network.
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

	initializeServer: ->
		addr = @this.address()
		if addr.rest_port
			@this.server new RestServer(
				addr, addr.rest_port, @this.getRestRoutes(), @this.scope(),
					@MULTI 'server'
			)
		# Init socket-only server if applicable.
		else @this.server new Server(
			addr, @this.scope(), @MULTI 'server'
		)

	connectToPlannerNode: flow.define(
		->
			@this.planner_node = @this.connectToNode(
				config.planner_node.host, config.planner_node.port, @
			)
		->
			@this.planner_node.remote.emit 'getConnections', address, @
		-> @MULTI 'connections'
	)

	# Asyncly initialize all connections/servers 
	# Emits 'start' signal
	connectToGraph: flow.define(
		(@next) ->
			# Init REST server if applicable.
			@this.initializeServer.call @
			# Connect to the planner node.
			# Only if node planner configured.
			# TODO define plannernode skip for this logic
			# override? setting flag?
			return if not config.planner_node? or @graph
			# Planner flow
			@this.connectToPlannerNode.call @
		(args) ->
			# connect only if node planner configured
			# TODO define plannernode skip for this logic (override?)
			return @() if not config.planner_node? or @graph
			graph_connections = args[1]
			for addr in graph_connections
				@this.connectToNode addr.host, addr.port, @MULTI()
		-> @this.start @
		-> @next?()
	)

	# just bind a listener, not override the signal
	restRoutes: signal('restRoutes', on: (next, ret) ->
#		ret.push ...
		next ret
	)

	start: signal('start')

	newClient: signal( 'newClient',
		(set, next) -> # TODO
	)

	clientClose: signal( 'clientClose',
		(set, next) -> # TODO
	)

	transaction: signal('transaction')
	getProvidedServices: signal( 'getProvidedServices',
		on: (next, ret, include_connections = no) ->
			if include_connections
				# TODO
			else
				next @provides()
	)

	getRequiredServices: signal( 'getRequiredServices', on: flow.define(
		(@next, @ret = [], include_connections = no) ->
			if not include_connections
				@next @ret.union @this.requires()
			return

			clients = @this.clients()
			# broadcast the request to all clients in parallel
			for client in clients
				client.getRequiredServices @MULTI()
		(services) ->
			# after fetching ALL callbacks, merge and push to main callback
			@next @ret.union services
	))

	###*
	Bind to server start event.
	###
	serverStart: signal( 'serverStart', (emit) ->
		@start().once (next, ret) =>
			@server().server.on 'ready', emit
#			console.log typeof @server().server.on
#			@server().server.on 'ready', new Function "console.log('aaa');"
			next ret
	)

	serverClose: signal( 'serverClose', (emit) ->
		@start().once (next, ret) =>
			@server().server.on 'close', emit
			next ret
	)

	connectToNode: (host, port, next) ->
		@clients.push new Client host, port, next
		@clients[-1]

	# getters / setters
	addRequire: (req) -> @requires.push req
	deleteRequire: (req) -> @requires = @requires.remove req

	addProvide: (name, args...) ->
		@provides.push 
	deleteProvide: (provide) -> # TODO

module.exports = Node

if config.contracts
	module.exports :: TNode
	module.exports = module.exports