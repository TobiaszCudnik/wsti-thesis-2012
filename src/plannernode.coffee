Node = require '../src/node'
_ = require 'underscore'
require '../src/utils'

class PlannerNode extends Node

	constructor: (@graph, address, services, next) ->
		super address, services, next
		
		# bind to signals
		@onGetConnections @getConnections_
		@onGetGraphMap @getGraphMap_

	getRoutes: ->
		_.merge([
				'getGraph', @rest 'get', @getGraph_
				'getConnections', @rest 'get', @getConnections_
			]
			super
		)

	@signal 'getConnections', (next, ret, node_addr) ->
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
		next _.union ret, nodes_to_connect

	@signal 'getGraphMap', (next, ret, node_addr) ->
		next @graph
		
module.exports = PlannerNode