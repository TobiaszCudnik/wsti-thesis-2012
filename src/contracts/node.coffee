#### IMPORTS
Server = require('../server').Server
Dnode = require 'dnode'
signals = require './properties'
server = require './server'
client = require './client'

#### LEGEND
# Signals contracts.
TSignalCallback = signals.TSignalCallback
TSignalCheck = signals.TSignalCheck
TSignal = signals.TSignal
TAsyncSignalMap = signals.TAsyncSignalMap
TSignalRet = signals.TSignalRet
# Server and client.
TServer = server.TServer
TClient = client.TClient

# Depends on dnode.
TDnode = ?! (x) -> x instanceof Dnode

TNodeAddr = ? {
	port: Num
	host: Str
}
TCallback = ? (Any?, Any?, Any?, Any?, Any?) -> Any
TRoutes = ? Any
TProperty = ?! (x) -> x instanceof jsprops.Property
TService = ?! (x) -> x instanceof Service
TPlannerNode = ?! (x) -> x instanceof PlannerNode

TFlow = ? {
	MULTI: (Str?) -> Any
}
#### TNode
# @TODO check for all signal initialized (on post constructor
# invatiant?)
TNode = ? (TNodeAddr, [...Any], TCallback) ==> {
	address: (TNodeAddr?) -> TNodeAddr?
	dnode: (TDnode?) -> TDnode?
	server: (TServer?) -> TServer?
	scope: (TAsyncSignalMap?) -> TAsyncSignalMap?
	clients: ([...TClient]?) -> [...TClient]
	requires: ([...TService]?) -> [...TService]
	provides: ([...TService]?) -> [...TService]
	planner_node: ([...TPlannerNode]?) -> TPlannerNode

	connectToGraph: (TCallback) -> Any
	restRoutes: -> (TRoutes?, TSignalCallback?) -> !(ret) ->
		TSignalCheck(ret, $1, $2)
	start: -> (TSignal or Null)

	# @**TODO** Define listener contracts
	# @**TODO** optional params???
	getProvidedServices: (TSignalCallback?) -> !(ret) ->
		check :: TSignalCheck
		check = [ ret, $1, $2 ]
	getRequiredServices: (TSignalCallback?) -> !(ret) ->
		check :: TSignalCheck
		check = [ ret, $1, $2 ]

	initializeServer: (Any?, Any?, Any?, Any?, Any?, { MULTI: TFlow }) -> Any
	connectToPlannerNode: (Any?, Any?, Any?, Any?, { MULTI: TFlow }) -> Any

#	```
# close: (TSignalCallback?) -> !(ret) ->
#		check :: TSignalCheck
#		check = [ ret, $1 ]
# ```
}

#### EXPORTS
module.exports = {
	TNode
	TNodeAddr
}