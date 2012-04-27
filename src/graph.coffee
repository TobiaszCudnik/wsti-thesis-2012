require 'sugar'
{
	property
} = require 'jsprops'

# candidate class
#class GraphConnection
#	started_at: null
#	connect_log: []
#	source_node: null
#	target_node: null

class GraphPath
	# ordered array of nodes for the connection flow
	nodes: property('nodes', null, [])
	visited_nodes: property('visited_nodes', null, [])

# TODO
class Transaction extends GraphPath
	finished_at: null
	started_at: null

	requires: [
		# []< []<service_name, []service_params>
	]

	provides: [
		# []< []<service_name, []service_params>
	]

class Graph
	@fromJson: (json) -> new Graph json

	map: property('map',
		set: (set, val) ->
			# TODO uncovered?
			set val
		, []
	)

	constructor: (map = null) ->
		@map map if map

	addNode: (address, connections) ->
		# TODO support
		@map().push { address, connections }

	removeNode: (address) ->
		index = @getNodeIndex address
		@map().removeAt index

	getNode: (address) ->
		index = @getNodeIndex address
		@map()[ index ] if index

	getNodeIndex: (address) ->
		@map.find (row) ->
			row.address.host is address.host and
				row.address.port is address.port

	# TODO include connection weight
	getConnections: (address) ->
		# find all connection for requested node from the graph object
		map = @map()
#		console.log 'in', map
		connections = map
			.filter (v) ->
				addr = v.address
				addr.host is address.host and addr.port is address.port
			.map (v) ->
				v.connections or []
			.flatten()

#		console.log 'out', connections
#		console.log (new Error).stack
		# -> [...TAddress?]
		map[ i ].address for i in connections

	toJson: -> @map()

# TODO
# contract
# :: (Graph) -> GraphConnectionsStrategyClass
class GraphConnectionsStrategy
	construct: (graph) -> # TODO

	getConnectionsForNode: (node) -> # TODO

module.exports = {
	Graph
}