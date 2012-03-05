#### IMPORTS

common = require './common'
server = require './server'
client = require './client'
properties = require './properties'

# Properties contracts.
{
    TSignalCallback
    TSignalCheck
    TSignal
    TAsyncSignalMap
    TSignalRet
} = properties

# Common contracts.
{
    TDnode
    TCallback
} = common

# Server and client contracts.
TServer = server.TServer
TClient = client.TClient

#### PRIVATE CONTRACTS

# TODO import from service contracts
TService = ?! (x) -> x instanceof Service
# TODO import from planner node contracts
TPlannerNode = ?! (x) -> x instanceof PlannerNode

#### CONTRACTS

TNodeAddr = ? {
    port: Num
	host: Str
}
TRoutes = ? Any

TSignalCheckListener = ?! (data) ->
    ret = data[0]
	args = data[1...]
    # TODO make dynamic by type, merge with TSignalCheck
    type = data[-1]
	# no params
	args_undefined = args.filter (x) -> x is undefined
	if args_undefined.length is args.length
		ret :: type
		ret = ret
	# all params present
	else if not args_undefined.length
		yes
	else no

# Services-like signals contract.
TServicesSignalListener = (TSignalCallback, Any, [...TService]) -> Any
TServicesRet = ? TSignalRet and {
    on: (TServicesSignalListener) -> Any
}
TServicesSignal = (include_connections?, TSignalCallback?) -> !(ret) ->
	check :: TSignalCheckListener
	check = [ ret, $1, $2, TServicesRet ]

# REST Routes signal contract.
TRoutesSignalListener = (TSignalCallback, Any, TRoutes) -> Any
TRoutesRet = ? TSignalRet and {
    on: (TRoutesSignalListener) -> Any
}
TRoutesSignal = (include_connections?, TSignalCallback?) -> !(ret) ->
    check :: TSignalCheckListener
	check = [ ret, $1, $2, TRoutesRet ]

#### EXPORTS

module.exports = {
    TNodeAddr
    TRoutes
    TServicesSignal
    TServicesSignalListener
    TRoutesSignal
    TRoutesSignalListener
}