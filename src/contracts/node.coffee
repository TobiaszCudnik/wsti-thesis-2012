# IMPORTS
Server = require('../server').Server
# Signals contracts.
signals = require './signals'
TSignalCallback = signals.TSignalCallback
TSignalCheck = signals.TSignalCheck
TSignal = signals.TSignal
TAsyncSignalMap = signals.TAsyncSignalMap
TSignalRet = signals.TSignalRet

server = require './server'
TServer = server.TServer

client = require './client'
TClient = client.TClient

TNodeAddr = ? {
	port: Num
	host: Str
}
TCallback = ? -> Any
TRoutes = ? Any
TProperty = ?! (x) -> x instanceof jsprops.Property
TService = ?! (x) -> x instanceof Service
TPlannerNode = ?! (x) -> x instanceof PlannerNode

###*
TODO check for all signal initialized (on post constructor
	invatiant)
###
TNode = ? (TNodeAddr, [...Any], TCallback) ==> {
	address: (TNodeAddr?) -> TNodeAddr?
	# TODO dnode
	server: (TServer?) -> TServer?
#	scope: (TAsyncSignalMap?) -> TAsyncSignalMap?
	clients: ([...TClient]?) -> [...TClient]
	requires: ([...TService]?) -> [...TService]
	provides: ([...TService]?) -> [...TService]
	planner_node: ([...TPlannerNode]?) -> TPlannerNode

	connectToGraph: (TCallback) -> Any
	restRoutes: -> (TRoutes?, TSignalCallback?) -> !(ret) ->
		TSignalCheck(ret, $1, $2)
	start: -> (TSignal or Null)

	# TODO Define listener contracts
	# TODO optional params???
	getProvidedServices: (TSignalCallback?) -> !(ret) ->
		check :: TSignalCheck
		check = [ ret, $1, $2 ]
	getRequiredServices: (TSignalCallback?) -> !(ret) ->
		check :: TSignalCheck
		check = [ ret, $1, $2 ]

	initializeServer: ({ MULTI: (-> Any) }) -> Any
	connectToPlannerNode: ({ MULTI: (-> Any) }) -> Any

#	close: (TSignalCallback?) -> !(ret) ->
#		check :: TSignalCheck
#		check = [ ret, $1 ]
}

# EXPORTS
module.exports = {
	TNode
	TNodeAddr
}