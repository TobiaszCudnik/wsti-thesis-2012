#### IMPORTS
node_ = require('../server').Server

# Node's internal contracts.
{
    TNodeAddr
    TRoutes
    TServicesSignal
    TServicesSignalListener
    TRoutesSignal
    TRoutesSignalListener
} = node_

#### TNode
# @TODO check for all signal initialized (on post constructor
# invatiant?)
TNode = ? (TNodeAddr, [...Any], TCallback) ==> {
    
    #### Properties
	address: (TNodeAddr?) -> TNodeAddr?
	dnode: (TDnode?) -> TDnode?
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
}