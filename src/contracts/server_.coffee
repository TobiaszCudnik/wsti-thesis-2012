#### IMPORTS
Dnode = require 'dnode'
SocketServer = require('net').Server
HTTPServer = require('connect').HTTPServer
Server = require('../server').Server
properties = require './properties'

# Properties contracts.
{
	TSignal
	TSignalCallback
	TSignalCheck
	TProperty
	TCallback
} = properties

#### TServer contracts.
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
TServerInstanceof = ?! (x) -> x instanceof Server

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

TNewClietSignal = ? (Any?, TDnodeClient?, TSignalCallback?) -> !(ret) ->
	check :: TSignalCheck
	check = [ ret, $1, $2 ]

TCloseSignal = ? (TSignalCallback?) -> !(ret) ->
	check :: TSignalCheck
	check = [ ret, $1 ]

#### TRestServer contracts.
TRestRouteRequest = ?! (x) ->
	x.toLowerCase() in ['get', 'post', 'head', 'put', 'info']

TRestRoutes = ? {
	0: TRestRouteRequest
	1: Str
	2: -> Any
}

TRestAddress = ? {
	port: Num
	rest_port: Num
	host: Str
}

#### EXPORTS
module.exports = {
	TNewClietSignal
	TCloseSignal
	TRestAddress
	TAddress
	TDnodeClient
	TServerInstanceof
	TServerComposed
	TServerClient
	TRestServerComposed
	TRestRouteRequest
	TRestRoutes
	TDnodeServer
}
