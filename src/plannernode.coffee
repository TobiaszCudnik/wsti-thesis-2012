Node = require '../src/node'
require 'sugar'
jsprops = require 'jsprops'
property = jsprops.property
signal = jsprops.signal
require '../src/utils'
mixin = require('./utils').mixin

PlannerNode = class PlannerNode extends Node
	mixin PlannerNode, jsprops.SignalsMixin

	constructor: (@graph, address, services, next) ->
		super address, services, next

	graph: property( 'graph', null, {} )

	# TODO
	# PlannerNode should expose these essential signals via REST API
#	restRoutes: @signal('restRoutes', on: (next, ret) ->
#		next (ret or []).union [
#			[ 'getGraph', @rest 'get', @getGraph_ ]
#			[ 'getConnections', @rest 'get', @getConnections_ ]
#		]
#	)

	getConnections: signal('getConnections',
		on: (next, ret, node_addr) ->
			debugger

			# find all connection for requested node from the graph object
			connections = @graph
				.filter (v) ->
					addr = v.address
					addr.host is node_addr.host and addr.port is node_addr.port
				.map (v) ->
					v.connections
				.flatten()

			nodes_to_connect = []
			for i in connections
				nodes_to_connect.push @graph[ i ].address

			next ( ret or [] ).union nodes_to_connect
	)

	getGraphMap: signal('getGraphMap',
		on: (next, ret) -> next (ret or []).union @graph
	)

	# disable connecting to the node graph
	connectToPlannerNode: null
		
module.exports = PlannerNode
