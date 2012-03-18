class GraphConnection
	started_at: null
	connect_log: []
	source_node: null
	target_node: null

class GraphPath
	# ordered array of nodes for the connection flow
	nodes: null
	visited_nodes: []

class Transaction extends GraphPath
	finished_at: null
	started_at: null

	requires: [
		# []< []<service_name, []service_params>
	]

	provides: [
		# []< []<service_name, []service_params>
	]

class GraphDirectionStrategy
	getPath: (source, target, service) ->
		GraphPath

class Graph
	nodes: null

	constructor: (nodes) ->
		@nodes = []

		for node in nodes
			@addNode node

	addNode: (node) ->
	removeNode: (node) ->

class GraphConnectionsStrategy
	getConnections: (limit_to_nodes) ->
	getConnectionsForNode: (node) ->