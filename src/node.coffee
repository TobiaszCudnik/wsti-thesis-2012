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
mixin = (tar, src) -> Object.merge tar.prototype, src.prototype

TNodeAddr = ? {
	port: Num
	host: Str
}
TCallback = ? -> Any
TSignalRet = ? ->
	on: (TCallback) -> Any
	once: (TCallback) -> Any
	before: (TCallback) -> Any
	after: (TCallback) -> Any
}
TRoutes = ? Any

TSignalCallback = ? (Any) ->

TSignalCheck = ?! (ret, p1, p2) ->
	if p1 is undefined and p2 is undefined
		ret_ :: TSignalRet
		ret_ = ret
	# TODO loop thou all arguments to cactch not undefined
	else if p1 isnt undefined and p2 isnt undefined
		yes
	else
		no

# Types signal
# (TFoo?, TSignalCallback?) -> !(ret) -> TSignalCheck(ret, $1, $2)
# Non types signal
TSignal = ?! (x) -> x instanceof jsprops.Signal
TProperty = ?! (x) -> x instanceof jsprops.Property
TService = ?! (x) -> x instanceof Service
TServer = ?! (x) -> x instanceof Server
TClient = ?! (x) -> x instanceof Client
TPlannerNode = ?! (x) -> x instanceof PlannerNode
TNode = ? (TNodeAddr, [...Any], TCallback) ==> {
#	address: NodeAddr
	address: (TNodeAddr?) -> TNodeAddr?
	# TODO dnode
	server: (TServer?) -> TServer?
	scope: (Any) -> Null
	clients: ([...TClient]?) -> [...TClient]
	requires: ([...TService]?) -> [...TService]
	provides: ([...TService]?) -> [...TService]
	planner_node: ([...TPlannerNode]?) -> TPlannerNode

	exposeSignals: -> [ ... ( -> Any ) ]
	connectToGraph: (TCallback) -> Any
	restRoutes: -> (TSignalCallback?, TRoutes?) -> !(ret) -> TSignalCheck(ret, $1, $2)
	start: -> (TSignal or Null)

	getRequiredServices: (Any?, TSignalCallback?) -> !(ret) -> TSignalCheck(ret, $1, $2)
	getProvidedServices: (Any?, TSignalCallback?) -> !(ret) -> TSignalCheck(ret, $1, $2)
}

# FIXME scope setter, maybe in contructor
Node :: TNode
Node = class Node extends EventEmitter2Async
	mixin Node, jsprops.SignalsMixin

	# @name address
	# @returns Object<host, port, rest_port>
	address: property 'address'
#	@name server
	# @returns Server
	server: property 'server'
	# @name scope
	# @returns Object
	scope: property('scope', null, {})
	# @name clients
	# @returns Array.<Client>
	clients: property('clients', null, [])
	# @name requires
	# @returns Array.<Service>
	requires: property 'requires'
	# @name provides
	# @returns Array.<Service>
	provides: property 'provides'
	# @name planner_node
	# @returns Client
	planner_node: property 'planner_node'

	constructor: (address, services, next) ->
		@initSignals()
		@requires = []
		@provides = []
		@address address

		@addRequire requires for requires in services?.requires?
		@addProvide provides for provides in services?.provides?

		@prepareScope()

		# creates @server
		@connectToGraph() if @address()

		@start().once next

	exposeSignals: -> @[ name ].bind @ for name in @getSignals()

	# TODO expose signals
	prepareScope: -> @exposeSignals()
#		@scope []
#		for fn in @
#			if fn.constructor is Function
#				@scope()[ fn ] = fn.bind @
#		@scope()
		
	#async
	close: signal( 'close', on: flow.define(
		(@next, ret) ->
			# TODO support no server scenario
			@this.server().close @MULTI 'server'
			if @this.clients()?
				for conn in @this.clients()
					conn.close @MULTI 'clients'
		# return from MULTI
		-> @next @ret
	))

	# Asyncly initialize all connections/servers 
	# Emits 'start' signal
	connectToGraph: flow.define(
		(@next) ->
			# Init REST server if applicable.
			addr = @this.address()
			if addr.rest_port
				@this.server new RestServer(
					addr.host, @this.address().rest_port, @this.getRestRoutes(),
					addr.port, @this.scope(), @MULTI()
				)
			# Init socket-only server if applicable.
			else
				@this.server new Server(
					addr.host, addr.port, @this.scope(), @MULTI()
				)
			# Connect to the planner node.
			# Only if node planner configured.
			# TODO define plannernode skip for this logic
			# override? setting flag?
			return if not config.planner_node? or @graph
			# Planner flow
			flow.exec.call( @this
				->
					@this.planner_node = @this.connectToNode(
						config.planner_node.host, config.planner_node.port, @
					)
				-> @this.planner_node.remote.emit 'getConnections', address, @
				@MULTI 'connections'
			)
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
		on: (next, ret, include_connections) ->
			include_connections ?= no
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