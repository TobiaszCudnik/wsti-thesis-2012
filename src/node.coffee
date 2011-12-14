Server = require './server'
Client = require './client'

module.exports =
class Node
	servers_: null
	clients_: null
	sockets_: null
	connections: 
	requires: null
	provides: null

	construct: (requires, provides) ->
		@servers_ = []
		@clients_ = []
		@connections_ = []
		@requires = []
		@provides = []

		for r in requires
			@addRequire r

		for r in provides
			@addProvide provides

	addRequire: (req) ->
	deleteRequire: (req) ->

	addProvide: (provide) ->
	deleteProvide: (provide) ->

	# Signals
		
	transactionStarted: (next) ->
		next Transaction
	transactionFinished: (next) ->
		next Transaction
		
	connectionStarted: ->
	connectionFinished: ->
		
class GraphConnection
	started_at: null
	source_node: null
	target_node: null

class Transaction extends GraphConnection
	finished_at: null
		
class GraphPath
	# ordered array of nodes for the connection flow
	nodes: null
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