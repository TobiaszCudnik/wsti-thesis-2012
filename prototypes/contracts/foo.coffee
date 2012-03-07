#Callback = ? () -> Any
#Node :: (NodeAddr, [...Any], Callback) ==> {
#	address: (NodeAddr) -> Any or -> NodeAddr

#foo :: (NodeAddr, Any, Any) -> Any
#foo = (a, b, c) -> yes

#	foo = __contracts.guard(
#		__contracts.fun(
#				[NodeAddr, Any, Any],
#				Any,
#				{}
#			), function (a, b, c) {
#		return true;
#	});

NodeAddr = ? {
	port: Num
	host: Str
}
#Node :: (NodeAddr, Any, Any) -> Any
Callback = ? -> Any

TNodeObj = ? {
#	addr: NodeAddr
#	address: (NodeAddr) -> Any
#	exposeSignals: ([ ...Str ]) -> Any
	exposeSignals: (None) -> Any
}
TNode = ? (NodeAddr, [...Any], Callback) ==> TNodeObj
Node :: TNode
Node = class
	constructor: (address, services, next) ->

	addr: null
	address: (addr) ->
		if not addr
			@addr
		else
			@addr = addr

	exposeSignals: ->

#Node :: (NodeAddr, Any, Any) ==> {
#	address: (NodeAddr?) -> Any
#}

def_addr = {
	port: 1
	host: 'foo'
}
foo = new Node def_addr, [], ->
foo.exposeSignals 123

#Func1 = ? (Num) -> Str
#Func2 = ? () -> Any
#
#foo :: Func1 or Func2
#foo = (a) -> a
#foo 'a'

#exposeSignals :: (Str) -> Any
#exposeSignals = (a) -> a.push 2

#exposeSignals :: ([...Str]) -> Any
#exposeSignals = (a) -> a.push 2
#exposeSignals 123
#
#exposeSignals 123



#average :: ({name: Str, age: Num}, [...Num]) -> Str
#average = (person, loc) ->
#	loc2 :: Str
#	loc2 = loc
#	sum = loc2.reduce (s1, s2) -> s1 + s2
#	"#{person.name} wrote on average
	 #{sum / loc.length} lines of code."
#average name: 'aaa', age: 13







#console.log foo.address()
#foo.address host: 'bar', port: 123
#console.log foo.address()
#foo.address host: 'bar', port: 'foo'

#	@new: (address, services, next) -> return new @(address, services, next)
#	constructor :: (NodeAddr, Any, Any) -> Any
#	exposeSignals: ->
#		[
#			-> 'a'
#			-> 'b'
#		]
#
#def_addr = {
#	port: 1
#	host: 'foo'
#}
#
## test valid
#console.log 'test start'
##foo = new Node g_addr, [], ->
#foo = new Node 'aaa', [], ->
##foo = new Foo 'aaa', [], ->
#	console.log 'callback'
#
#console.log foo.address()
#foo.address port: 2, host: 'bar'
#console.log foo.address()
#
#console.log foo.exposeSignals()

# test invalid
#foo.address host: 'bar'