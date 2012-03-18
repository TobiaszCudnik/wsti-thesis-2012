#### IMPORTS
server = require './server_'
common = require './common'
properties = require './properties'

# Properties contracts.
{
	TCallback
} = properties

# Server contracts.
{
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
} = server

# Commons contracts.
{
	TObj
} = common

#### CONTRACTS

#### TSserver
#TODO Mixin SignalsMixin.
#TODO TODO Mixin EventEmitter?

TClientsProperty = ? ([...TServerClient]) -> [...TServerClient]?
TServerProperty = ? (TServerComposed?) -> TServerComposed?
TAddressProperty = ? (TAddress?) -> TAddress?
TDnodeProperty = ? (TDnodeServer?) -> TDnodeServer?

# TServer instance object.
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

# TServer class constructor.
TServerClass = ? (TAddress, Any, TCallback?) ==> TServer

#### TRestServer
TRestAddressProperty = ? (TRestAddress?) -> TRestAddress?

# TRestServer instance object.
TRestServer = ? {
	rest: (TRestServerComposed?) -> TRestServerComposed
	address: TRestAddressProperty
	initServers_: (Self, TAddress, TCallback) -> Any
	close: TCloseSignal
}

# TRestServer class constructor.
TRestServerClass = ? (TRestAddress, [...TRestRoutes], TObj, TCallback) ==> TRestServer

# EXPORTS
module.exports = {
	TAddress
	TServer
	TServerClass
	TRestServer
	TRestServerClass
	TDnodeClient
	TServerInstanceof
	TServerComposed

	# Properties.
	TClientsProperty
	TDnodeServer
	TAddressProperty
	TDnodeProperty
	TServerProperty
}