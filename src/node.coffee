RestServer = require('./server').RestServer
Server = require('./server').Server
Client = require './client'
_ = require 'underscore'
EventEmitter2Async = require('eventemitter2async').EventEmitter2
config = require '../config'

class Node extends EventEmitter2Async
	# @type Object<host, port, rest_port>
	address: null
	# @type Server
	server: null
	# @type Object
	scope: null
	# @type Array<Client>
	clients: null
	# @type Array<Service>
	requires: null
	# @type Array<Service>
	provides: null
	# @type Client
	planner_node: null

	construct: (@address, services, next) ->
		@requires = []
		@provides = []
		@clients = []

		@addRequire requires for requires in services.requires
		@addProvide provides for provides in services.provides

		@prepareScope()
		
		@connectToGraph if @address
		@initializeSignals()
		
	prepareScope: ->
		@scope = {}

	connectToGraph: ->		
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
				$.planner_node = $.connectToNode( 
					config.planner_node.host, config.planner_node.port, @MULTI()
				)
			->
				$.planner_node.remote.emit('getConnections', address, @)
			(graph_connections) ->
				for addr in graph_connections
					$.connectToNode( addr.host, addr.port, @MULTI() )
			->
		)
		
	getRestRoutes: -> []

	initializeSignals: ->
		# signals
		@onNewClient = (listener) => @on 'newClient', listener # TODO
		@onClientClose = (listener) => @on 'newClient', listener # TODO
		    
		@onaBeforeTransaction = (listener) => @on 'transaction', listener
		@onaTransaction = (listener) => @on 'transaction', listener
		@onaAfterTransaction = (listener) => @on 'transaction', listener
		    
		@onaGetProvidedServices = (listener) => @on 'transaction', listener
		@onaGetRequiredServices = (listener) => @on 'transaction', listener
		    
		@onServerStarted = (listener) => @server.on 'ready', listener
		@onDisconnect = (listener) => @server.on 'close', listener

	connectToNode: (host, port, next) ->
		@clients.push new Client host, port, next
		@clients[-1]
		
	getProvidedServices: (include_connections, next) ->
		include_connections ?= no
		if include_connections
			# TODO
		else
			next @provides
		    
	getRequiredServices: (include_connections, next) ->
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

	# getters / setters
	addRequire: (req) -> @requires.push req
	deleteRequire: (req) -> @requires = _.without @requires, req

	addProvide: (name, args...) ->
		@provides.push 
	deleteProvide: (provide) -> # TODO

	# events
	onConnection: (listener) ->
	onTransaction: (listener) ->
		    
	onNewClient: null
	oClientClose: null
		    
	## SYMBOLS  ##
	##----------##
	  
	onaBeforeTransaction: null
	onaTransaction: null
	onaAfterTransaction: null
	  
	onaGetProvidedServices: null
	onaGetRequiredServices: null
	  
	onServerStarted: null
	onDisconnect: null
		
module.exports = Node