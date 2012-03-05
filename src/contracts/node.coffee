#### IMPORTS
node_ = require './node_'
common = require './common'
server = require './server'
properties = require './properties'
client = require './client'

# Node's internal contracts.
{
	TNodeAddr
	TRoutes
	TServicesSignal
	TServicesSignalListener
	TRoutesSignal
	TRoutesSignalListener
	TService
	TPlannerNode
} = node_

# Common contracts.
{ TCallback } = common

# Server contracts.
{ TServer } = server

# Properties contracts.
{
	TAsyncSignalMap
	TSignal
	TSignalCallback
} = properties

# Client contracts.
{ TClient } = client

#### TNode
# @TODO check for all signal initialized (on post constructor
# invatiant?)
TNode = ? (TNodeAddr, [...Any], TCallback) ==> {

	#### Properties
	address: (TNodeAddr?) -> TNodeAddr?
	server: (TServer?) -> TServer?
	scope: (TAsyncSignalMap?) -> TAsyncSignalMap?
	clients: ([...TClient]?) -> [...TClient]
	requires: ([...TService]?) -> [...TService]
	provides: ([...TService]?) -> [...TService]
	planner_node: ([...TPlannerNode]?) -> TPlannerNode

	#### Methods (local)
	initializeServer: (Any?, Any?, Any?, Any?, Any?) -> Any
	connectToPlannerNode: (Any?, Any?, Any?, Any?, Any?) -> Any
	connectToGraph: (TCallback) -> Any
	start: (Any?, Any?, Any?, Any?, Any?) -> (TSignal or Null)

	#### Signals (local & remote)
	restRoutes: TRoutesSignal
	getProvidedServices: TServicesSignal
	getRequiredServices: TServicesSignal
	close: (TSignalCallback?) -> !(ret) ->
		check :: TSignalCheck
		check = [ ret, $1 ]
}

#### EXPORTS

module.exports = {
	# Applies contracts on an exports scope.
	applyContracts: (scope) ->
		e = scope

		e.Node :: TNode
		e.Node = e.Node

	TNodeAddr
	TRoutes
	TServicesSignal
	TServicesSignalListener
	TRoutesSignal
	TRoutesSignalListener
	TNode
	TPlannerNode
	TService
}