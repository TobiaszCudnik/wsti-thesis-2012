props = require '../src/utils'
Property = props.Property
AsyncProperty = props.AsyncProperty
Signal = props.Signal
#expect = require 'expect'
require 'should'
property = -> new Property arguments[0], arguments[1], arguments[2]
async_property = -> new AsyncProperty arguments[0], arguments[1], arguments[2]
signal = -> new Signal arguments[0], arguments[1], arguments[2]

describe 'Properties', ->
	obj = klass = null

#    describe 'setters', ->
#        beforeEach ->
#            class klass
#                property 'foo', @, { init: -> 'bar' }
#
#                constructor: ->
#            obj = new klass
#
#        it 'should work like getter', ->
#    #        expect( obj.foo() ).to.eql 'bar'
#            debugger
#            obj.foo().should.eql 'bar'
#
#        it 'should work like setter', ->
#            obj.foo 'baz'
#            obj.foo().should.eql 'baz'

	describe 'basics', ->
		beforeEach ->
			class klass
				property 'foo', @, 'bar'
#				@property 'foo', 'bar'

				constructor: ->
			obj = new klass

		it 'should work like getter', ->
	#        expect( obj.foo() ).to.eql 'bar'
			debugger
			obj.foo().should.eql 'bar'

		it 'should work like a setter', ->
			obj.foo 'baz'
			obj.foo().should.eql 'baz'

describe 'Signals', ->
	obj = klass = null

	describe 'basics', ->
		beforeEach ->
			class klass
				signal 'foo', @

				constructor: ->
			obj = new klass

		it 'should emit events', ->
			obj.foo 'param1', ->
			expect( @emit.calledWith 'param1' ).to.be.ok()

		it 'should bind to events', (next) ->
			obj.on.restore()
			obj.foo().on next
			obj.emit 'foo'

#describe 'AsyncProperties', ->
#	obj = klass = null
#
#	describe 'basics', ->
#		beforeEach ->
#			class klass
#				property 'foo', @,
#					init: -> 'bar'
#					set: (set, val, next) ->
#						setTimeout ->
#							set val
#							do next
#
#				constructor: ->
#			obj = new klass
#
#		it 'should work like a getter', ->
#	#        expect( obj.foo() ).to.eql 'bar'
#			debugger
#			obj.foo().should.eql 'bar'
#
#		it 'should work like setter', ->
#			obj.foo 'baz'
#			obj.foo().should.eql 'baz'