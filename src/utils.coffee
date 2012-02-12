$ = require('JSONSelect').match

String.prototype.$ = (sel) -> $ sel, this

class exports.Property
	value: undefined,
	getter_args_length_: 0,
	@new: -> new exports.Property arguments[0], arguments[1], arguments[2]

	constructor: (prop, @obj, funcs) ->
		# prepare default value
		if funcs typeof String
			funcs = init: funcs
		name = @getPropertyName prop
		return if obj[ name ]

		getter_args_length_ = @getter_args_length_
		prop_value = "#{name}_value"

		set = @setObjectValue()
		get = @setObjectValue()
		setter = funcs['set'] or @getSetter set
		getter = funcs['get'] or @getGetter get
		init = funcs['init'] or @getInit set
		      
		# attach to the prototype
		obj.prototype[ name ] = (v) ->
#                console.log 'arguments.length', arguments.length
			# init property when undefined
			if @[ "#{name}_value" ] is undefined
				console.log 'setup property val'
				@[ "#{name}_value" ] = init()
				console.log @[ "#{name}_value" ]

			# regular getter/setter code
			if arguments.length > getter_args_length_
				console.log 'set property val'
				@callSetter setter, [ @, prop_value ], arguments
			else
				console.log 'get property val'
				@callGetter getter, [ @, prop_value ], arguments

	setObjectValue: (prop_value) -> (v) -> @[ prop_value ] = v
	getObjectValue: (prop_value) -> @[ prop_value ]

	getPropertyName: (name) -> name
	getGetter: (prop_value) -> @getObjectValue
	getSetter: (prop_value) -> @setObjectValue
	getInit: (prop_value) -> @setObjectValue.bind null
	# TODO set setter, getter, int

class exports.AsyncProperty extends exports.Property
	getter_args_length_: 1,
	@new: -> new exports.AsyncProperty arguments[0], arguments[1], arguments[1]

	constructor: (prop, @obj, funcs) ->
		super

	callSetter: (setter, ctx, args) ->
		# TODO cache setter
		setter = exports.Property::getSetter.call ctx[1], arguments

	getSetter: (prop_value) ->
		throw new Error 'setter needed for AsyncProperty'
	getGetter: (prop_value) ->
		throw new Error 'getter needed for AsyncProperty'

# TODO init
class exports.Signal extends exports.Property
	getter_args_length_: 1,

	getGetter: ( set ) ->
		(arg1, arg2, next) ->
			set.apply arguments
	getSetter: ( get ) ->
		(next) ->
			set.call next
	getInit: ( set, prop_value ) ->
		-> @[ prop_value] = 'signal'

	setObjectValue: (prop_value) ->
		@on.apply.bind @, prop_value

	getObjectValue: (prop_value) ->
		@emit.bind @ prop_value


`if (!Number.prototype.times) {
  Object.defineProperty(Number.prototype, 'times', {
    enumerable: false,
    value: function times (f) {
      var times= +this;
      var n= 0;
      while (n < times) f(n++);
      return this;
    }
  });
}

/*
(5).times(function (i) {
	console.log(i);
});
->
0
1
2
3
4
*/

if (!Array.prototype.upto) {
  Object.defineProperty(Array.prototype, 'upto', {
    enumerable: false,
    value: function upto (f) {
      var start= +this[0];
      var end= +this[1];
      while (start <= end) f(start++);
      return this;
    }
  });
}

/*
[-2,3].upto(function (i) {
	console.log(i);
});
->
-2
-1
0
1
2
3
*/

if (!Array.prototype.downto) {
  Object.defineProperty(Array.prototype, 'downto', {
    enumerable: false,
    value: function downto (f) {
      var start= +this[0];
      var end= +this[1];
      while (start >= end) f(start--);
      return this;
    }
  });
}

/*
[2,-2].downto(function (i) {
	console.log(i);
});
->
2
1
0
-1
-2
*/`

