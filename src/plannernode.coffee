Node = require '../src/node'
require 'sugar'
{
	property
	signal
	SignalsMixin
} = require 'jsprops'
{ mixin } = require './utils'
{ Graph } = require './graph'

class PlannerNode extends Node
	mixin PlannerNode, SignalsMixin

	graph: property( 'graph', null, {} )

	# TODO change @graph connections to services
	# once strategies will be implemented
	# then use implementation of GraphConnectionsStrategy
	constructor: (graph, address, next) ->
		@graph new Graph graph
		super address, next

	# TODO
	# PlannerNode should expose these essential signals via REST API
#	restRoutes: @signal('restRoutes', on: (next, ret) ->
#		next (ret or []).union [
#			[ 'getGraph', @rest 'get', @getGraph_ ]
#			[ 'getConnections', @rest 'get', @getConnections_ ]
#		]
#	)

	getGraph: signal('getGraph',
		on: (next, ret) ->
			# TODO manual casting to json, consider better options
			# TODO merge???
			ret ?= []
			next ret.union @graph().toJson()
	)

	setGraph: signal('setGraph',
		on: @flow(
			(@next, @ret, graph) ->
				for client in @this.clients()
					client.remote().setGraph graph, @MULTI()
				do @ if not @this.clients().length
			-> @next @ret
		)
	)
		
module.exports = PlannerNode
