RestServer = require('./server').RestServer
Server = require('./server').Server
Client = require './client'
Service = require './service'
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

if config.contracts
	{
		TNodeConstructor
		TNodeClass
	} = require './contracts/node'

Node :: TNodeConstructor
Node = class Node extends EventEmitter2Async
	mixin Node, jsprops.SignalsMixin
	# TODO EventEmitter2Async, inherit from general object

	address: property 'address'
	server: property 'server'
	scope: property('scope', null, {})
	clients: property('clients', null, [])
	requires: property 'requires'
	provides: property 'provides'
	planner_node: property 'planner_node'

	emit: (name) ->
		@log "emit #{name}" if config.debug
		super

	on: (name) ->
		@log "bind to #{name}" if config.debug
		super

	constructor: (address, services, next) ->
		# mixed in method from Signals
		@initSignals()

		# register callback
		@start().once next

		@requires []
		@provides []
		@address address

		@addRequire services.requires if services?.requires?
		@addProvide services.provides if services?.provides?

		@initScope()

		# creates @server
		if @connectToGraph?
			@connectToGraph?()
		else
			@start ->

	initScope: ->
		signals = {}
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

	connectToPlannerNode_: (address, next) ->
		@this.planner_node = @this.connectToNode(
			address.host, address.port, next
		)

	initializeServer_: (flow) ->
		addr = @address()
		if addr.rest_port
			@server new RestServer(
				addr, addr.rest_port, @getRestRoutes(), @scope(),
					flow.MULTI 'server'
			)
		# Init socket-only server if applicable.
		else @server new Server(
			addr, @scope(), flow.MULTI 'server'
		)

	# Asyncly initialize all connections/servers 
	# Emits 'start' signal
	connectToGraph: flow.define(
		->
			# Init REST server if applicable, pass the flow object.
			@this.initializeServer_ @
			# Connect to the planner node.
			# Only if node planner configured.
			if not config.planner_node or not @this.connectToPlannerNode
				do @MULTI 'planner_node'
			else
				@this.connectToPlannerNode config.planner_node, @MULTI 'planner_node'
		(args) ->
			# emit 'start' if there's no planner node
			if not args.planner_node
				@this.start ->
			# continue otherwise
			else do @
		->
			@this.planner_node().remote().getConnections @this.address(), @
		(graph_connections) ->
			for addr in graph_connections
				@this.connectToNode addr.host, addr.port, @MULTI()
		-> @this.start @
	)

#	restRoutes: signal('restRoutes', on: (next, ret) ->
##		ret.push ...
#		next ret
#	)

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

	getRequiredServices: signal( 'getRequiredServices',
		on: flow.define(
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
		)
	)

	###*
	Bind to server start event.
	###
	serverStart: signal( 'serverStart', (emit) ->
		@start().once (next, ret) =>
			@server().on 'ready', emit
			next ret
	)

	serverClose: signal( 'serverClose', (emit) ->
		@start().once (next, ret) =>
			@server().on 'close', emit
			next ret
	)

	connectToNode: (address, port, next) ->
		@clients.push new Client address, port, next
		@clients[-1]

	addProvide: (name, service_names...) ->
		@provides().push arg for arg in service_names
		
	deleteProvide: (service_name) ->
		@provides @provides().remove service_name

	addRequire: (name, service_names...) ->
		@requires().push arg for arg in service_names
		
	deleteRequire: (service_name) ->
		@requires @requires().remove service_name

if config.contracts
	for prop, Tcontr of TNodeClass.oc
		continue if not Node::[prop] or
			prop is 'constructor'
		Node.prototype :: Tcontr
		Node::[prop] = Node::[prop]

module.exports = Node