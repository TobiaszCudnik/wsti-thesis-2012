require 'sugar'
config = require '../config'
flow = require 'flow'
jsprops = require('jsprops')

class GraphNode extends Node

	##############
	# PROPERTIES #
	##############

	planner_node: property 'planner_node'
	graph: property 'graph'
	requires: property 'requires'
	provides: property 'provides'

	###########
	# METHODS #
	###########

	# TODO make it a flow
	constructor: (address, services, next) ->
		super address, =>

			@requires []
			@provides []

			@addRequire services.requires if services?.requires?
			@addProvide services.provides if services?.provides?

			@connectToGraph =>
				# bind next to the start signal
				@start().once next
				# emit the start signal
				@start ->

	connectToPlannerNode_: (address, next) ->
		@this.planner_node = @this.connectToNode(
			address.host, address.port, next
		)

	# Asyncly initialize all connections/servers
	# Emits 'start' signal
	connectToGraph: signal('connectToGraph', on: flow.define(
		(@next) ->
			# Connect to the planner node.
			# Only if planner node configured.
			if not config.planner_node or not @this.connectToPlannerNode
				@next()
			else
				@this.connectToPlannerNode config.planner_node, @
		->
			@this.planner_node().remote().getGraph @
		(graph_json) ->
			@this.setGraph graph_json, @
		->
			@next()
	))

	addProvide: (name, service_names...) ->
		@provides().push arg for arg in service_names

	deleteProvide: (service_name) ->
		@provides @provides().remove service_name

	addRequire: (name, service_names...) ->
		@requires().push arg for arg in service_names

	deleteRequire: (service_name) ->
		@requires @requires().remove service_name

	###########
	# SIGNALS #
	###########

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

	setGraph: signal('setGraph', on: flow.define(
		(@next, @ret, graph) ->
			@this.graph new Graph graph_json
			graph_connections = @this.graph().getConnections @this.address()
			for addr in graph_connections
				@this.connectToNode addr.host, addr.port, @MULTI()
		->
			@next @ret
	))

	establishGraphConnections: signal('establishConnections',
		init: (emit) ->
			# estabilish new connections if graph changes
			@setGraph().on (next, ret) ->
				emit next.fill ret
		on: flow.define(
			(@next, ret) ->
				# TODO preserve if connection overlaps
				for client in @this.clients()
					client.close @MULTI()
			->
				graph_connections = @this.graph().getConnections @this.address()
				for addr in graph_connections
					@this.connectToNode addr.host, addr.port, @MULTI()
			-> @next @ret
		)
	)