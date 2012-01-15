RestServer = require('./server').RestServer
Client = require './client'
_ = require 'underscore'
EventEmitter2Async = require('eventemitter2').EventEmitter2Async
config = require '../config'

e = module.exports
class e.Node extends EventEmitter2Async
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
		)

		# signals
		@onNewClient = (listener) => @on 'newClient', listener # TODO
		@onClientClose = (listener) => @on 'newClient', listener # TODO
    
		@onaBeforeTransaction = (listener) => @on 'transaction', listener
		@onaTransaction = (listener) => @on 'transaction', listener
		@onaAfterTransaction = (listener) => @on 'transaction', listener
    
		@onaGetProvidedServices = (listener) => @on 'transaction', listener
		@onaGetRequiredServices = (listener) => @on 'transaction', listener
    
		@onServerStarted = (listener) => @server.on 'ready', listener
		@onDisconnect = (listener) => @server.on 'close', listener

	connectToNode: (host, port, next) ->
	getProvidedServices: (include_connections, next) ->
    include_connections ?= no
    if include_connections
      # TODO
    else
      next @provides
    
	getRequiredServices: (include_connections, next) ->
    include_connections ?= no
    if include_connections
      clients = @clients
      # broadcast to all client the request in parallel
      flow.exec(
        ->
          for client in clients
            client.getRequiredServices @MULTI()
        (services) ->
          # after fetching ALL callbacks, merge and push to main callback
          next _.merge.apply null, services
      )
    else
      next @requires

	# getters / setters
	addRequire: (req) -> @requires.push req
	deleteRequire: (req) -> @requires = _.without @requires, req

	addProvide: (name, args...) ->
    @provides.push 
	deleteProvide: (provide) -> # TODO

	# events
	onConnection: (listener) ->
	onTransaction: (listener) ->
    
  ## SYMBOLS  ##
  ###--------###
    
  onNewClient: null
  oClientClose: null
  
  onaBeforeTransaction: null
  onaTransaction: null
  onaAfterTransaction: null
  
  onaGetProvidedServices: null
  onaGetRequiredServices: null
  
  onServerStarted: null
  onDisconnect: null