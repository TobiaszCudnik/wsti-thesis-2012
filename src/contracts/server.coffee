# IMPORTS.
Dnode = require 'dnode'
Server = require('http').Server
# Signal contracts.
contracts_signals = require './signals'
TSignalCallback = contracts_signals.TSignalCallback
TSignalCheck = contracts_signals.TSignalCheck
TSignal = contracts_signals.TSignal
TAsyncSignalMap = contracts_signals.TAsyncSignalMap
TSignalRet = contracts_signals.TSignalRet

TCallback = ? -> Any

# Contract, depends on dnode.
TDnode = ?! (x) -> x instanceof Dnode

# Contract.
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

TServer = ? {
	close: (TSignalCallback?) -> !(ret) ->
		check :: TSignalCheck
		check = [ ret, $1 ]
	server: (TServerComposed?, TSignalCallback?) -> !(ret) ->
		check :: TSignalCheck
		check = [ ret, $1, $2 ]
	clients: ([...TDnodeClient]?, TSignalCallback?) -> !(ret) ->
		check :: TSignalCheck
		check = [ ret, $1, $2 ]

	host: Str
	port: Num
	dnode: TDnode?
	newClient: (TDnode, Any) -> None
}

# Contract.
TServerClass = ? (TAddress, Any, TCallback?) ==> TServer

# Contract.
TRestRoutes = ?! (x) -> yes
# TODO
#	for route in x
#		return no if x isnt Function

TRestServer = ? {
	close: (TCallback) -> Null
}
# TODO add super contract check
TRestServerClass = ? (TAddress, [...Str] or Null, Num, TRestRoutes?, TCallback?) ==> TRestServer

# EXPORTS
module.exports = {
	TAddress
	TServer
	TServerClass
	TRestServer
	TRestServerClass
	TDnodeClient
}