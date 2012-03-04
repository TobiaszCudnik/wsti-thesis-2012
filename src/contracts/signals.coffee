TCallback = ? -> Any

TSignalCallback = ? (Any) -> Any

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
TSignal = ?! (x) ->
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

module.exports =
	TSignalCallback: TSignalCallback
	TSignalRet: TSignalRet
	TAsyncSignalMap: TAsyncSignalMap
	TSignal: TSignal
	TSignalCheck: TSignalCheck
	TSignalCallback: TSignalCallback
	TCallback: TCallback