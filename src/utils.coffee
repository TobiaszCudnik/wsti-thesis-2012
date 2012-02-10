$ = require('JSONSelect').match

String.prototype.$ = (sel) -> $ sel, this

class exports.Property
	value: undefined,
	getter_args_length_: 0,
	@new: -> new exports.Property arguments[0], arguments[1]

	constructor: (@obj, prop, funcs) ->
		name = @getPropertyName prop
		if not obj[ name ]
			setter = funcs['set'] or @getSetter prop
			getter = funcs['get'] or @getGetter prop
			init = funcs['init'] or @getInit prop
			obj[ name ] = (v) =>
				if arguments.length > @getter_args_length_
					setter.apply @, arguments
				else
					getter.apply @, arguments
			obj[ name ].init = _.bind init, @
			# TODO wrap constructor and init the property?

	getPropertyName: (prop) ->
		@prop
	getSetter: (v) ->
		-> @value = v
	getGetter: ->
		-> @value
	getInit: ->
		-> @value = undefined
	# TODO set setter, getter, int

class exports.AsyncProperty extends exports.Property
	@new: -> new exports.AsyncProperty arguments[0], arguments[1]
	getter_args_length_: 1,
	getSetter: (prop) ->
		throw new Error 'setter needed for AsyncProperty'
	getGetter: (prop) ->
		throw new Error 'getter needed for AsyncProperty'

class exports.Signal extends exports.Property
	getter_args_length_: 1,
	getSetter: (prop) ->
		(arg1, arg2, next) ->
			@obj.emit.apply @obj, arguments
	getGetter: (prop) ->
		(next) ->
			@on prop, next


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

