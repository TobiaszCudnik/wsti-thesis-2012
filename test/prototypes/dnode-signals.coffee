jsprops = require 'jsprops'
Server = require('../../src/server').Server
Client = require '../../src/client'
EventEmitter2Async = require('eventemitter2async').EventEmitter2
#expect = require 'expect'
require 'should'

describe 'dnode and signals prototype', ->
	it 'should work with fake event emitter', (test_done) ->
		addr = host: 'localhost', port: 1234

		class Foo
			constructor: ->
				@test1.init?()
			test1: jsprops.signal('test1')
			test2: ->

			emit: (name, next) -> do next

		foo = new Foo
		scope = test1: foo.test1.bind(foo), test2: foo.test2.bind(foo)

		server = new Server addr, scope, ->
			client = new Client addr, {}, ->
				client.remote().test2()
				client.remote().test1 ->
					client.close ->
						server.close test_done

	it 'should work with real event emitter', (test_done) ->
		addr = host: 'localhost', port: 1234

		class Foo extends EventEmitter2Async
			constructor: ->
				@test1.init?()
			test1: jsprops.signal('test1')
			test2: ->

		foo = new Foo
		scope = test1: foo.test1.bind(foo), test2: foo.test2.bind(foo)

		server = new Server addr, scope, ->
			client = new Client addr, {}, ->
				client.remote().test2()
				client.remote().test1 ->
					client.close ->
						server.close test_done

	it 'should work for a signal with a listener', (test_done) ->
		addr = host: 'localhost', port: 1234
		listener_called = no

		class Foo extends EventEmitter2Async
			constructor: ->
				@test1.init.call @
			test1: jsprops.signal('test1', on: (next, ret) ->
				listener_called = yes
				next 3
			)
			test2: ->

		foo = new Foo
		scope = test1: foo.test1.bind(foo), test2: foo.test2.bind(foo)

		server = new Server addr, scope, ->
			client = new Client addr, {}, ->
				client.remote().test2()
				client.remote().test1 ->
					client.close ->
						listener_called.should.be.ok
						server.close test_done

	it 'should work for a signal with a flowed listener', (test_done) ->
		addr = host: 'localhost', port: 1234
		listener_called = no

		class Foo extends EventEmitter2Async
			constructor: ->
				@test1.init.call @
			test1: jsprops.signal('test1', on: flow.define(
				(@next, ret) ->
					listener_called = yes
					@()
				->
					@next 3
			))
			test2: ->

		foo = new Foo
		scope = test1: foo.test1.bind(foo), test2: foo.test2.bind(foo)

		server = new Server addr, scope, ->
			client = new Client addr, {}, ->
				client.remote().test2()
				client.remote().test1 ->
					client.close ->
						listener_called.should.be.ok
						server.close test_done

	it 'should bind to signals', (test_done) ->
		addr = host: 'localhost', port: 1234
		listener_called = no

		class Foo extends EventEmitter2Async
			test1: jsprops.signal('test1')

		foo = new Foo
		scope =
			test1: foo.test1.bind foo
			test1_:
				on: foo.test1().on.bind foo

		server = new Server addr, scope, ->
			client = new Client addr, {}, ->
				client.remote().test1_.on (next, ret) ->
					listener_called = yes
					next ret
				client.remote().test1 ->
					client.close ->
						listener_called.should.be.ok
						server.close test_done