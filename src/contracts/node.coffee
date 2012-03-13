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
	TSignalCheck
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

#### TNode class object.
TNodeClass = ? {

	#### Properties
	address: (TNodeAddr?) -> TNodeAddr?
	server: (TServer?) -> TServer?
	scope: (TAsyncSignalMap?) -> TAsyncSignalMap?
	clients: ([...TClient]?) -> [...TClient]
	requires: ([...TService]?) -> [...TService]
	provides: ([...TService]?) -> [...TService]
	planner_node: ([...TPlannerNode]?) -> TPlannerNode

	#### Methods (local)
	initializeServer: -> Any
	connectToPlannerNode: -> Any
	connectToGraph: (TCallback) -> Any
	start: -> TSignal?

	#### Signals (local & remote)
	restRoutes: TRoutesSignal
	getProvidedServices: TServicesSignal
	getRequiredServices: TServicesSignal
	close: (TSignalCallback?) -> !(ret) ->
		check :: TSignalCheck
		check = [ ret, $1 ]
}

#### TNode class contructor
TNodeConstructor = ? (TNodeAddr, [...Any], TCallback) ==> TNodeClass

#### EXPORTS

module.exports = {
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