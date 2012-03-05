# IMPORTS.
Dnode = require 'dnode'
SocketServer = require('net').Server
Server = require('../server').Server
common = require './common'

# Signal contracts.
contracts_signals = require './properties'
TSignalCallback = contracts_signals.TSignalCallback
TSignalCheck = contracts_signals.TSignalCheck
TSignal = contracts_signals.TSignal
TAsyncSignalMap = contracts_signals.TAsyncSignalMap
TSignalRet = contracts_signals.TSignalRet

# Commons contracts.
{
		TDnode
} = common

TCallback = ? -> Any

TDnodeClient = ? {
	remote: TDnode
	# TODO typeme
	connection: Any
}

# Contract to check for instanceof the Server class.
ServerInstanceof = (x) -> x instanceof Server

# Contract for composed internal server (TCP or HTTP)
TServerComposed = ?! (x) -> x instanceof SocketServer

#TRestServerComposed = ? {
#	on: (Str, TCallback) -> Any
#	emit: -> Any
#}

TAddress = ? {
	port: Num
	host: Str
}

TClientsProperty = ? ([...TDnodeClient]) -> [...TDnodeClient]?
TServerProperty = ? (TServerComposed?) -> TServerComposed?
TAddressProperty = ? (TAddress?) -> TAddress?
TDnodeProperty = ? (TDnode?) -> TDnode?

TNewClietSignal = ? (TDnode?, TSignalCallback?) -> !(ret) ->
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

TRestRoutes = ?! (x) -> yes
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
	address: TRestAddress
}

# TODO add super contract check
TRestServerClass = ? (TRestAddress, [...Str] or Null, Num, TRestRoutes?, TCallback?) ==> TRestServer

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
	ServerInstanceof
}