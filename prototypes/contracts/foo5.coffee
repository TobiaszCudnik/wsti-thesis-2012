#Foo :: (Num, Any) ==> { attr1: Any, attr2: Any, x: Any }
TCustomContract = ? { a: Num }
foo :: ({ TCustomContract }) -> Any
foo = ->

foo.call a: 2

#signal_val2 = new Bar 1
#
##console.log '--------------'
##console.log 'constructor', signal_val.constructor is Foo
##console.log 'typeof', typeof signal_val.constructor is 'Foo'
##console.log 'instanceof', signal_val instanceof Foo
##console.log '--------------'
##console.log 'constructor 2', signal_val2.constructor is Foo
##console.log 'typeof 2', typeof signal_val2.constructor is 'Foo'
##console.log 'instanceof 2', signal_val2 instanceof Foo
##console.log '--------------'
##console.log 'constructor 3', signal_val2.constructor is Bar
##console.log 'typeof 3', typeof signal_val2.constructor is 'Bar'
##console.log 'instanceof 3', signal_val2 instanceof Bar
##console.log '--------------'
#console.log '--------------'
#foo = new Foo 3
#console.log foo instanceof Foo
#console.log foo.constructor instanceof Foo
#console.log foo.prototype instanceof Foo
#console.log '--------------'
#
##TFoo = ?! (x) -> x.constructor is Foo
#TFoo = ?! (x) -> x instanceof Foo
#
#TPropertyCheck = (ret, p1) ->
#	if p1 is undefined
#		ret_ :: TFoo
#		ret_ = ret
#	yes
#TProperty = ? (TFoo?) -> !(ret) -> TPropertyCheck ret, $1
#
#TSignalRet = ? ->
#	on: (TCallback) -> Any
#	once: (TCallback) -> Any
#	before: (TCallback) -> Any
#	after: (TCallback) -> Any
#}
#
#TSignalCallback = ? (Any) ->
#
#TSignalCheck = ?! (ret, p1, p2) ->
#	if p1 is undefined and p2 is undefined
#		ret_ :: TSignalRet
#		ret_ = ret
#	else if p1 isnt undefined and p2 isnt undefined
#		yes
#	else
#		no
#
#TSignal_ = ? (TFoo?, TSignalCallback?) -> !(ret) -> TSignalCheck(ret, $1, $2)
#
#signal :: TProperty
#signal = (x) -> if x then signal_val = x; null else signal_val
#
#
#console.log signal()
#console.log signal new Foo 2