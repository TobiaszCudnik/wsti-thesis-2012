#### IMPORTS

common = require './common'
properties = require './properties'
client = require './client'

# Common contracts.
{ TCallback } = common

# Properties contracts.
{
	TAsyncSignalMap
	TSignal
	TSignalCallback
	TProperty
} = properties

#### CONTRACTS

# Contract, depends on dnode.
TDnode = ?! (x) -> x instanceof Dnode

TCallback = ? -> Any

TDnodeCallback = (TDnode, Any) -> Any
TAddress = ? {
#	dnode: (TDnode?) -> TDnode?
	port: Num
	reconnect: Bool?
	proto: Str?
	host: Str
}
TDnodeConnect = ? (TAddress, TDnodeCallback) -> Any
TDnodeProperty = ? (TDnode?) -> TDnode?
TAddressProperty = ? (TAddress?) -> TAddress?
TCloseSignal = ? (TSignalCallback?) -> !(ret) ->
	check :: TSignalCheck
	check = [ ret, $1 ]

TClient = ? {
	remote: TProperty
	connection: TProperty
	scope: TProperty
	dnode: TProperty
	address: TAddressProperty and TProperty

	close: TCloseSignal and TSignal
}

# TODO describe Client callback
TClientClass = ? (TAddress, Any, TCallback) ==> TClient

module.exports = {
	# Puts contracts on an export scope.
	applyContracts: (scope, dnode) ->
		scope :: TClientClass
		scope = scope

		if dnode
			dnode.connect :: TDnodeConnect
			dnode.connect = dnode.connect

	TDnodeConnect
	TDnodeCallback
	TClientClass
	TClient
}