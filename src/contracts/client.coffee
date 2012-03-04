# IMPORTS
Dnode = require 'dnode'
# Signal contracts.
contracts_signals = require './signals'
TSignalCallback = contracts_signals.TSignalCallback
TSignalCheck = contracts_signals.TSignalCheck
TSignal = contracts_signals.TSignal
TAsyncSignalMap = contracts_signals.TAsyncSignalMap
TSignalRet = contracts_signals.TSignalRet

# Contract, depends on dnode.
TDnode = ?! (x) -> x instanceof Dnode

TCallback = ? -> Any

TDnodeCallback = (TDnode, Any) -> Any
TConnectionInfo = ? {
	port: Num
	reconnect: Bool?
	proto: Str?
	host: Str
}
TDnodeConnect = ? (TConnectionInfo, TDnodeCallback) -> Any
TObj = ?! (x) -> typeof x in ['object', 'undefined', 'null']

TClient = {
	remote: Any
	connection: Any # TODO
	scope: Any # TODO
	close: (TCallback) -> Any
}

TClientClass = ? (TConnectionInfo, TObj, TCallback) ==> TClient

module.exports = {
	TDnodeConnect
	TDnodeCallback
	TClientClass
	TClient
}