# IMPORTS.
Dnode = require 'dnode'
Server = require('http').Server
# Signal contracts.
contracts_signals = require './properties'
TSignalCallback = contracts_signals.TSignalCallback
TSignalCheck = contracts_signals.TSignalCheck
TSignal = contracts_signals.TSignal
TAsyncSignalMap = contracts_signals.TAsyncSignalMap
TSignalRet = contracts_signals.TSignalRet

TCallback = ? -> Any

# Depends on dnode.
TDnode = ?! (x) -> x instanceof Dnode

TDnodeClient = ? {
	remote: TDnode
	# TODO typeme
	connection: Any
}

# TODO
#TEventEmitter = ?

TServerComposed = ?! (x) -> x instanceof Server

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
	TAddress
	TServer
	TServerClass
	TRestServer
	TRestServerClass
	TDnodeClient
}