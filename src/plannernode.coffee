Node = require '../src/node'
_ = require 'underscore'

class PlannerNode extends Node
	constructor: (@graph, address, services, next) ->
		super address, services, next
		
		# TODO? move to signals
		@on 'getConnections', @getConnections
		
	# TODO
	getConnections: (next, ret, node_addr) ->
		matching_nodes = _.filter @graph, (v) ->
			v.host is node_addr.host and v.port is node_addr.port
		
		connections = matching_nodes.map (v) -> v.connections
		
		nodes_to_connect = []
		for c in connections
			nodes_to_connect.push @graph[ i ] for i in c
			
		next nodes_to_connect
		
module.exports = PlannerNode