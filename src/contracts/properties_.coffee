#### Properties internal contracts.
# @link https://github.com/TobiaszCudnik/jsprops

#### COMMON

TCallback = ? Any

# TODO
TEventEmitterAsync = {
	on: Any
	emit: Any
}

#### PROPERTIES

TPropertyData = ? {
	set: Any
	get: Any
}

#TPropertyMethod = ? TPropertyMethodFunc
TPropertyMethodFunc = Any
# ```
#TPropertyMethodObj = ? {
#	init: Any
#	set: Any
#	get: Any
#	constructor: Any
#}
# ```

TPropertyMethodObj = ?! (x) ->
	x.init and
# ```
#		x.get and
# ```
		x.set and
		x.constructor

TPropertyMethod = ? TPropertyMethodFunc and TPropertyMethodObj


#### SIGNALS

TSignalCallback = Any

# Signal input data.
# All is optional.
TSignalData = ? {
	on: Any
	after: Any
	before: Any
	once: Any
	init: Any
}

# Signal getter is used internally in getters defined by the developer.
TSignalGetter = -> TSignalData

# Functional aspect of TSignalMethod.
TSignalMethodFunc = ? Any
# This isn't needed for for now.
# ```
# TSignalMethodObj = ? {
#
# }
# ```

# Signal method supposed to be attached to the prototype.
#TSignalMethod = ? TSignalMethodFunc and TSignalMethodOb
TSignalMethod = ? TSignalMethodFunc and TPropertyMethodObj

# Conatract used in signal return to validate the call pattern.
TSignalCheck = ?! (data) ->
	ret = data[0]
	args = data[1..]
	# no params
	args_undefined = args.filter (x) -> x is undefined
	if args_undefined.length is args.length
		ret :: TSignalRet
		ret = ret
	# all params present
	else if not args_undefined.length
		yes
	else no

#### Custom signals
# Custom signals can be done using following snippet.
# Type signals, set custom type and number of params
# ```
# (TFoo?, TSignalCallback?) -> !(ret) -> TSignalCheck(ret, $1, $2)
# ```

# Instance of like signal contract.
TSignalInstanceof = ?! (x) ->
	x instanceof jsprops.Signal or x.constructor is jsprops.Signal

# Collection of async signals with names.
# Used eg in DNode remote scope.
TAsyncSignalMap = ?! (map) ->
	methods = ['on', 'once', 'before', 'after']
	for name, fn of map
		for m in methods
			method :: (TCallback) -> Any
			method = fn[ m ]
	yes

# Signal getter value, allows to bind to the signal.
TSignalRet = ? {
	on: (TCallback, Any?, Any?, Any?, Any?, Any?) -> Any
	once: (TCallback, Any?, Any?, Any?, Any?, Any?) -> Any
	before: (TCallback, Any?, Any?, Any?, Any?, Any?) -> Any
	after: (TCallback, Any?, Any?, Any?, Any?, Any?) -> Any
}

#### EXPORTS.
	
module.exports = {
	TCallback
	TEventEmitterAsync
	TPropertyData
	TPropertyMethodFunc
	TPropertyMethodObj
	TPropertyMethod
	TSignalCallback
	TSignalData
	TSignalGetter
	TSignalMethodFunc
	TSignalMethod
	TSignalCheck
	TSignalInstanceof
	TAsyncSignalMap
	TSignalRet
}