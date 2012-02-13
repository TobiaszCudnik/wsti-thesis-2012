RestServer = require('./server').RestServer
Server = require('./server').Server
Client = require './client'
_ = require 'underscore'
EventEmitter2Async = require('eventemitter2async').EventEmitter2
config = require '../config'
flow = require 'flow'
#Semaphore = require('semaphores').Semaphore

# FIXME scope setter, maybe in contructor
class Node extends EventEmitter2Async
	# @type Object<host, port, rest_port>
	address: null
	# @type Server
	server: null
	# @type Object
	scope: null
	# @type Array.<Client>
	clients: null
	# @type Array.<Service>
	requires: null
	# @type Array.<Service>
	provides: null
	# @type Client
	planner_node: null

	constructor: (@address, services, next) ->
		@requires = []
		@provides = []
		@clients = []

		@addRequire requires for requires in services?.requires?
		@addProvide provides for provides in services?.provides?

		@initSignals()
		@prepareScope()
				
		# creates @server
		@connectToGraph() if @address
		
		@once 'start', -> next
				
	prepareScope: ->
		@scope = []
		for fn in @
			if fn.constructor is Function
				@scope[ fn ] = fn.bind @
		@scope
		
	#async
	@signal 'close', on: (next, ret) ->
		$ = @
		flow.exec(
			->
				$.server.close @MULTI 'server'
				if $.connections?
					for conn in $.connections
						conn.close @MULTI 'clients'
			# return from MULTI
			next
		)

	# Asyncly initialize all connections/servers 
	# Emits 'start' signal
	connectToGraph: (next) ->
		throw new Error 'no-address' if not @address
		$ = @
		flow.exec(
			->
				# Init REST server if applicable. 
				if $.address.rest_port
					$.server = new RestServer(
						$.address.host, $.address.rest_port, $.getRestRoutes(), 
						$.address.port, $.scope, @MULTI()
					)
				# Init socket-only server if applicable.
				else
					$.server = new Server(
						$.address.host, $.address.port, $.scope, @MULTI()
					)
				# Connect to the planner node.
				# Only if node planner configured.
				# TODO define plannernode skip for this logic
				# override? setting flag?
				return if not config.planner_node? or @graph
				# Planner flow
				MULTI = @MULTI()
				flow.exec(
					->
						$.planner_node = $.connectToNode( 
							config.planner_node.host, config.planner_node.port, @
						)
					-> $.planner_node.remote.emit 'getConnections', address, MULTI
				)				
			(args) ->
				# connect only if node planner configured
				# TODO define plannernode skip for this logic (override?)
				return @() if not config.planner_node? or @graph
				graph_connections = args[1]
				for addr in graph_connections
					$.connectToNode addr.host, addr.port, @MULTI()
			-> $.start @
			next
		)

	# just bind a listener, not override the signal
	@signal 'getRestRoutes', on: ->
		[]

	@signal 'start'

	@signal 'newClient', (get, next) -> # TODO

	@signal 'clientClose', (get, next) -> # TODO

	@signal 'transaction'
	@signal 'getProvidedServices', on: (include_connections, next) ->
		include_connections ?= no
		if include_connections
			# TODO
		else
			next @provides

	@signal 'getRequiredServices', on: (include_connections, next) ->
		include_connections ?= no
		if include_connections
			clients = @clients
			# broadcast to all client the request in parallel
			flow.exec(
				->
					for client in clients
						client.getRequiredServices @MULTI()
				(services) ->
					# after fetching ALL callbacks, merge and push to main callback
					next _.merge.apply null, services
			)
		else
			next @requires

	@signal 'serverStart', (set) ->
		@server.on 'ready', @emit.bind 'serverStart'

	@signal 'serverClose', (set) ->
		@server.on 'close', @emit.bind 'serverClose'

	connectToNode: (host, port, next) ->
		@clients.push new Client host, port, next
		@clients[-1]

	# getters / setters
	addRequire: (req) -> @requires.push req
	deleteRequire: (req) -> @requires = _.without @requires, req

	addProvide: (name, args...) ->
		@provides.push 
	deleteProvide: (provide) -> # TODO
				
module.exports = Node