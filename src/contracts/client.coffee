# IMPORTS
Dnode = require 'dnode'
jsprops = require 'jsprops'
Property = jsprops.Property
Signal = jsprops.Signal
# Signal contracts.
contracts_signals = require './properties'
TSignalCallback = contracts_signals.TSignalCallback
TSignalCheck = contracts_signals.TSignalCheck
TSignal = contracts_signals.TSignal
TAsyncSignalMap = contracts_signals.TAsyncSignalMap
TSignalRet = contracts_signals.TSignalRet

# Contract, depends on dnode.
TDnode = ?! (x) -> x instanceof Dnode

TCallback = ? -> Any

TDnodeCallback = (TDnode, Any) -> Any
TAddress = ? {
	port: Num
	reconnect: Bool?
	proto: Str?
	host: Str
}
TDnodeConnect = ? (TAddress, TDnodeCallback) -> Any

# TODO move to common and signals
TObj = ?! (x) -> typeof x in ['object', 'undefined', 'null']
TProperty = ?! (x) -> x.constructor is Property
TSignal = ?! (x) -> x.constructor is Signal
TAnyProperty = ? (Any) -> Any?
# FIXME
TConnectionProperty = ? (Any?) -> Any?
TDnodeProperty = ? (TDnode?) -> TDnode?
TSignalCallback = ? (TSignalCallback?) -> !(ret) ->
	TSignalCheck(ret, $1)
TAddressProperty = ? (TAddress?) -> TAddress?
TCloseSignal = ? (TSignalCallback?) -> !(ret) ->
	check :: TSignalCheck
	check = [ ret, $1 ]

TClient = {
	remote: TAnyProperty and TProperty
	connection: TConnectionProperty and TProperty
	scope: TAnyProperty and TProperty
	dnode: TDnodeProperty and TProperty
	address: TAddressProperty and TProperty

	close: TCloseSignal and TSignal
}

# TODO describe Client callback
TClientClass = ? (TAddress, TObj, TCallback) ==> TClient

module.exports = {
	TDnodeConnect
	TDnodeCallback
	TClientClass
	TClient
}