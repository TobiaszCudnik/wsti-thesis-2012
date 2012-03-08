# IMPORTS.
Dnode = require 'dnode'
SocketServer = require('net').Server
HTTPServer = require('connect').HTTPServer
Server = require('../server').Server
common = require './common'
properties = require './properties'

# Properties contracts.
{
	TAsyncSignalMap
	TSignal
	TSignalCallback
	TProperty
	TCallback
	TSignalCheck
} = properties

# Commons contracts.
{
	TObj
} = common

#### CONTRACTS.
TDnodeClient = ?! (x) -> x.remoteStore isnt undefined

TServerClient = ? {
	remote: Any
	# TODO typeme
	connection: TDnodeClient
}

TDnodeServer = ?! (x) ->
	x.proto isnt undefined and
		x.streams isnt undefined

# Contract to check for instanceof the Server class.
TServerInstanceof = (x) -> x instanceof Server

# Contract for composed internal server (TCP or HTTP)
TServerComposed = ?! (x) -> x instanceof SocketServer
TRestServerComposed = ?! (x) -> x instanceof HTTPServer

#TRestServerComposed = ? {
#	on: (Str, TCallback) -> Any
#	emit: -> Any
#}

TAddress = ? {
	port: Num
	host: Str
}

TClientsProperty = ? ([...TServerClient]) -> [...TServerClient]?
TServerProperty = ? (TServerComposed?) -> TServerComposed?
TAddressProperty = ? (TAddress?) -> TAddress?
TDnodeProperty = ? (TDnodeServer?) -> TDnodeServer?

TNewClietSignal = ? (Any?, TDnodeClient?, TSignalCallback?) -> !(ret) ->
	check :: TSignalCheck
	check = [ ret, $1, $2 ]

TCloseSignal = ? (TSignalCallback?) -> !(ret) ->
	check :: TSignalCheck
	check = [ ret, $1 ]

###*
TServer instance object.
TODO Mixin SignalsMixin.
TODO TODO Mixin EventEmitter?
###
TServer = ? {
	server: TServerProperty
	clients: TClientsProperty
	address: TAddressProperty
	dnode: TDnodeProperty

	close: TCloseSignal
	newClient: TNewClietSignal

	on: -> Any
	emit: -> Any
}

###*
TServer class constructor.
###
TServerClass = ? (TAddress, Any, TCallback?) ==> TServer

TRestRouteRequest = ?! (x) ->
	x.toLowerCase() in ['get', 'post', 'head', 'put', 'info']
TRestRoutes = ? [ ...{
	0: TRestRouteRequest
	1: Str
	2: -> Any
}]
# TODO
#	for route in x
#		return no if x isnt Function

TRestAddress = ? {
	port: Num
	rest_port: Num
	host: Str
}

# TODO inherit from TServerClass
TRestServer = ? {
	rest: (TRestServerComposed?) -> TRestServerComposed
	address: TRestAddress
	initServers_: (Self, TAddress, TCallback, { MULTI: -> Any }) -> Any
	close: TCloseSignal
}

# TODO add super contract check
TRestServerClass = ? (TRestAddress, TRestRoutes, TObj, TCallback) ==> TRestServer

# EXPORTS
module.exports = {
	# Puts contracts on an export scope.
	applyContracts: (scope) ->
		e = scope

		e.Server :: TServerClass
		e.Server = e.Server

		e.RestServer :: TRestServerClass
		e.RestServer = e.RestServer

	TAddress
	TServer
	TServerClass
	TRestServer
	TRestServerClass
	TDnodeClient
	TServerInstanceof
	TServerComposed
}