RestServer = require('./server').RestServer
Client = require './client'
_ = require 'unserscore'
EventEmitter2Async = require('eventemitter2async').EventEmitter2Async
config = require '../config'

module.exports =
class Node extends EventEmitter2Async
	server: null
	scope: null
	clients: null
	requires: null
	provides: null
	planner: null

	construct: (address, services, next) ->
		@requires = []
		@provides = []
		@clients = []

		@addRequire requires for requires in services.requires
		@addProvide provides for provides in services.provides

		@scope =
			requires: @requires
			provides: @provides

		routes = []

		$ = @
		flow.exec(
			->
				$server = new RestServer address.host, address.port, address.rest_port,
					routes, address.port, $scope, @MULTI()
				$planner = new Client config.planner.host, config.planner.rest_port, @MULTI()
			->
				$planner.remote.emit.getConnections

		# signals
    @onNewClient = (listener) => @on 'newClient', listener
    @onTransaction = (listener) => @on 'transaction', listener
    @onRequiredServices = (listener) => @on 'transaction', listener
    @onProvidedServices = (listener) => @on 'transaction', listener
    @onConnection = (listener) => @on 'newConnection', listener
    @onDisconnect = (listener) => @on 'disconnect', listener

  connectToNode: (host, port, next) ->
  get_services_provided: (include_connections = no) ->
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