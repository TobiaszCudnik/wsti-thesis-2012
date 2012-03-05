#### COMMON CONTRACTS
# This file contains common contracts used by the main app contracts.

#### IMPORTS
Dnode = require 'dnode'

#### CONTRACTS
TCallback = ? (Any?, Any?, Any?, Any?, Any?) -> Any
#TFlowObj = ? {
#    MULTI: (Str?) -> Any
#}
#TFlow = ? ( () -> Any ) and TFlowObj
TDnode = ?! (x) -> x instanceof Dnode
TEventEmitterAsync = ? {
	on: Any
	emit: Any
}
TEventEmitter = ? {
	on: Any
	emit: Any
}

#### EXPORTS
module.exports = {
		TCallback
		TDnode
#    TFlowObj
#    TFlow
		TEventEmitter
		TEventEmitterAsync
}