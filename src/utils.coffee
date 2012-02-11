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

		setter = funcs['set']?(prop_value) or @getSetter prop_value
		getter = funcs['get']?(prop_value) or @getGetter prop_value
		init = funcs['init']?(prop_value) or @getInit prop_value
		      
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

	getPropertyName: (name) -> name
	getSetter: (prop_value) ->
		(v) -> @[ prop_value ] = v
	getGetter: (prop_value) ->
		-> @[ prop_value ]
	getInit: (prop_value) ->
		-> @[ prop_value ] = null
	# TODO set setter, getter, int

class exports.AsyncProperty extends exports.Property
	getter_args_length_: 1,
	@new: -> new exports.AsyncProperty arguments[0], arguments[1], arguments[1]

	constructor: (prop, @obj, funcs) ->
		super

	callSetter: (setter, ctx, args) ->
		# TODO cache setter
		setter = exports.Property::getSetter.call(ctx[1], arguments

	getSetter: (prop_value) ->
		throw new Error 'setter needed for AsyncProperty'
	getGetter: (prop_value) ->
		throw new Error 'getter needed for AsyncProperty'

class exports.Signal extends exports.Property
	getter_args_length_: 1,
	getSetter: (prop_value) ->
		(arg1, arg2, next) ->
			@obj.emit.apply @obj, arguments
	getGetter: (prop_value) ->
		(next) ->
			@on prop_value, next


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

