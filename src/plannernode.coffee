Node = require '../src/node'
require 'sugar'
jsprops = require 'jsprops'
property = jsprops.property
signal = jsprops.signal
require '../src/utils'

class PlannerNode extends Node

	constructor: (@graph, address, services, next) ->
		super address, services, next
		
		# bind to signals
		@onGetConnections @getConnections_
		@onGetGraphMap @getGraphMap_

	# TODO docme
	getRoutes: ->
		super().union [
			[ 'getGraph', @rest 'get', @getGraph_ ]
			[ 'getConnections', @rest 'get', @getConnections_ ]
		]

	getConnections: signal('getConnections', on: (next, ret, node_addr) ->
		debugger
		connections = $ [
				":root >"
				" :has( .host:val('#{node_addr.host}') )"
				":has( .port:val('#{node_addr.port}') )"
				" .connections"
			].join(''), @graph
#		matching_nodes = _.filter @graph, (v) ->
#			v.host is node_addr.host and
#				v.port is node_addr.port
#
#		connections = matching_nodes.map (v) -> v.connections

		nodes_to_connect = []
		for c in connections
			nodes_to_connect.push @graph[ i ] for i in c

		ret ?= []
		next (ret or []).union nodes_to_connect
	)

	getGraphMap: signal('getGraphMap', on: (next, ret, node_addr) ->
		# TODO
		next (ret or []).union @graph
	)
		
module.exports = PlannerNode