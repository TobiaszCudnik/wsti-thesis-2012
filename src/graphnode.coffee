require 'sugar'
config = require '../config'
flow = require 'flow'
{
	SignalsMixin
	property
	signal
} = require 'jsprops'
Node = require './node'
{ Graph } = require './graph'

class GraphNode extends Node

	##############
	# PROPERTIES #
	##############

	# (TClient?) -> TClient?
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

			# emit the start signal after conecting to the graph
			@connectToGraph @start.bind @, next

	connectToPlannerNode_: (address, next) ->
		@planner_node @connectToNode address, next

	connectToGraph: signal('connectToGraph', on: flow.define(
		(@next, @ret) ->
			# Connect to the planner node.
			# Only if planner node configured.
			if not config.planner_node
				@next()
			else
				@this.connectToPlannerNode_ config.planner_node, @
		->
			@this.planner_node().remote().getGraph @
		(graph_json) ->
			@this.setGraph graph_json, @
		->
			@next @ret
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
			@this.graph new Graph graph
			graph_connections = @this.graph().getConnections @this.address()
			for addr in graph_connections
				@this.connectToNode addr, @MULTI()
		->
			@next @ret
	))

	establishGraphConnections: signal('establishGraphConnections',
		init: (emit) ->
			# estabilish new connections if graph changes
			@setGraph().on (next, ret) ->
				# forward the return value
				emit next.bind undefined, ret
		on: flow.define(
			(@next, ret) ->
				# TODO preserve if connections overlaps
				for client in @this.clients()
					client.close @MULTI()
			->
				graph_connections = @this.graph().getConnections @this.address()
				for addr in graph_connections
					@this.connectToNode addr, @MULTI()
			-> @next @ret
		)
	)

module.exports = GraphNode