#### COMMON.

TCallback = ? -> Any

# TODO
TEventEmitterAsync = {
	on: -> Any
	emit: -> Any
}

#### PROPERTIES.

TPropertyData = ? {
	set: (Any?) -> Any?
	get: -> Any?
}

#TPropertyMethod = ? TPropertyMethodFunc
TPropertyMethodFunc = ? (Any?) -> Any?
#TPropertyMethodObj = ? {
#	init: -> Any
#	set: -> Any
#	get: -> Any
#	constructor: -> Any
#}

TPropertyMethodObj = ?! (x) ->
	# TODO chec kProperties instanceof for the constructor
	console.log x
	x.init and
#		x.get and
		x.set and
		x.constructor

TPropertyMethod = ? TPropertyMethodFunc and TPropertyMethodObj

#### SIGNALS.

TSignalCallback = ? (Any) -> Any

TSignalData = ? {
	on: -> Any
	after: -> Any
	before: -> Any
	once: -> Any
	init: -> Any
}

TSignalGetter = -> TSignalData

TSignalMethodFunc = ? -> Any
#TSignalMethodObj = ? {
#
#}

#TSignalMethod = ? TSignalMethodFunc and TSignalMethodOb
TSignalMethod = ? TSignalMethodFunc and TPropertyMethodObj

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

# Type signals, set custom type and number of params
# (TFoo?, TSignalCallback?) -> !(ret) -> TSignalCheck(ret, $1, $2)
# Non types signal
TSignalInstanceof = ?! (x) ->
	x instanceof jsprops.Signal or x.constructor is jsprops.Signal
#TSignalMap = ?! (x) ->
#	for name, fn of x
#		fn :: TSignal
#		fn = fn
#	yes
TAsyncSignalMap = ?! (map) ->
	methods = ['on', 'once', 'before', 'after']
	for name, fn of map
		for m in methods
			method :: (TCallback) -> Any
			method = fn[ m ]
	yes

TSignalRet = ? {
	on: (TCallback) -> Any
	once: (TCallback) -> Any
	before: (TCallback) -> Any
	after: (TCallback) -> Any
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