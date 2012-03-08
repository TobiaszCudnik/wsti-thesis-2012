#### IMPORTS

common = require './common'
properties = require './properties'

# Common contracts.
{ TCallback } = common

# Properties contracts.
{
	TAsyncSignalMap
	TSignal
	TSignalCallback
	TSignalCheck
	TProperty
} = properties

#### CONTRACTS

# Contract, depends on dnode.
TDnodeClient = ?! (x) -> x.remoteStore isnt undefined

TDnodeCallback = (TDnode, Any) -> Any
TAddress = ? {
#	dnode: (TDnode?) -> TDnode?
	port: Num
	reconnect: Bool?
	proto: Str?
	host: Str
}

TDnodeConnect = ? (TAddress, TDnodeCallback) -> Any
TCloseSignal = ? (TSignalCallback?) -> !(ret) ->
	check :: TSignalCheck
	check = [ ret, $1 ]

#### EXPORTS

module.exports = {
	TDnodeClient
	TDnodeCallback
	TDnodeConnect
	TCloseSignal
	TAddress
}