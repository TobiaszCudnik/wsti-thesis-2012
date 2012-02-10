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

	getConnections: new Signal @, 'getConnections'

	#
	# getConnections
	#
		
	### 
	@param listener Function.<ret>
	###
	getConnections: (next, node_addr) -> @emit 'getConnections', next
		
	###
	@param listener Function.<next, ret>
	Map reduce event listener. Push return val to the next one.
	###
	onGetConnections: (listener) -> @on 'getConnections', listener

	###
	Returns all sibling connection for a specific node. 
	###
	getConnections_: (next, ret, node_addr) ->
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

	#
	# getGraphMap
	#
		
	### 
	@param listener Function.<ret>
	ret can be an Error
	@see getGraphMap_
	###
	getGraphMap: (next) -> @emit 'getGraphMap', next
		
	###
	@param listener Function.<next, ret>
	Map reduce event listener. Push return val to the next one.
	@see getGraphMap_
	###
	onGetGraphMap: (listener) -> @on 'getGraphMap', listener

	###
	Returns whole graph map.
	###
	getGraphMap_: (next, ret, node_addr) ->
		next @graph
		
module.exports = PlannerNode