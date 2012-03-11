#### IMPORTS

common = require './common'
properties = require './properties'

# Common contracts.
{
	TCallback
	TObj
} = common

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
TDnodeClient = ?! (x) ->
	console.log 'TDnodeClient', x
	x.remoteStore isnt undefined

TDnodeConnection = ? {
	id: Str
	remote: TObj
	localStore: TObj
	remoteStore: TObj
	stream: TObj
}

TDnodeCallback = ? (TObj, TCallback) -> Any
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
	TDnodeConnection
}