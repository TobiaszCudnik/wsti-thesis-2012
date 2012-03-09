#### IMPORTS

common = require './common'
properties = require './properties'
client = require './client_'

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
	TProperty
} = properties

# Client internal contracts.
{
	TDnodeClient
	TDnodeConnect
	TDnodeCallback
	TCloseSignal
	TAddress
	TDnodeConnection
} = client

#### CONTRACTS

TDnodeProperty = ? (TDnodeClient?) -> TDnodeClient?
TAddressProperty = ? (TAddress?) -> TAddress?

TClient = ? {
	remote: (TObj?) -> TObj
	connection: (TDnodeConnection?) -> TDnodeConnection?
	scope: (TObj?) -> TObj
#	dnode: TDnodeProperty
	address: TAddressProperty

	close: TCloseSignal
}

# TODO describe Client callback
TClientClass = ? (TAddress, Any, TCallback) ==> TClient

#### EXPORTS

module.exports = {
	TDnodeConnect
	TDnodeProperty
	TAddressProperty
	TDnodeCallback
	TClientClass
	TClient
	TDnodeConnection
}