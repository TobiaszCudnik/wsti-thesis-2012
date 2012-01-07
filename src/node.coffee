Server = require './server'
Client = require './client'
_ = require 'unserscore'
EventEmitter2Async = require('eventemitter2async').EventEmitter2Async

module.exports =
class Node extends EventEmitter2Async
	servers_: null
	clients_: null
	sockets_: null # why?
	connections: null
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

    @onConnection = (listener) => @on 'connection', listener
    @onTransaction = (listener) => @on 'transaction', listener

  connect: (node_uri) ->
  get_services_provides: (include_connections = no) ->
  get_services_required: (include_connections = no) ->

  # getters / setters
	addRequire: (req) -> @requires.push req
	deleteRequire: (req) -> @requires = _.without @requires, req

	addProvide: (provide) ->
	deleteProvide: (provide) ->

  # events
	onConnection: (listener) ->
	onTransaction: (listener) ->
		
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