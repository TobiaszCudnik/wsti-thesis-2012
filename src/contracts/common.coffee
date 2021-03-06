#### COMMON CONTRACTS
# This file contains common contracts used by the main app contracts.

#### IMPORTS
#Dnode = require 'dnode'

#### CONTRACTS
TCallback = ? -> Any
#TFlowObj = ? {
#    MULTI: (Str?) -> Any
#}
#TFlow = ? ( () -> Any ) and TFlowObj

TEventEmitterAsync = ? {
	on: Any
	emit: Any
}

TEventEmitter = ? {
	on: Any
	emit: Any
}

TObj = ?! (x) -> typeof x is 'object'

#### EXPORTS
module.exports = {
		TCallback
#    TFlowObj
#    TFlow
		TEventEmitter
		TEventEmitterAsync
		TObj
}