config = require '../config'
PlannerNode = require '../src/plannernode'
sinon = require 'sinon'
$ = require('JSONSelect').match

describe 'plannernode', ->
	describe 'statnode data', ->

	describe 'graph structures', ->
		mock = planner_node = null
		graph = [
			{ host: 'localhost', port: '2000', connections: [ 1, 2 ] }
			{ host: 'localhost', port: '2001', connections: [ 2 ] }
			{ host: 'localhost', port: '2002' }
		]
		beforeEach (next) ->
			config.planner_node = port: 1234, host: 'localhost'
			planner_scope = {
				graph: graph
			}
			c = config.planner_node
			addr = host: c.host, port: c.port
			planner_node = new PlannerNode graph, addr, null, next
			mock = sinon.mock planner_node
		
		afterEach (next) ->
			planner_node.close next

		describe 'unit', ->
			it 'should return connections for a node', (next) ->
				callback = (connections) ->
					debugger
					connections.should.equal [ 1, 2 ]
					next()
				planner_node.getConnections_.restore()
				planner_node.graph = graph
				planner_node.getConnections_ callback, null, host: graph[0].host, port: graph[0].port

		describe 'properties', ->
			beforeEach ->
				class Foo
					bar: new Property
			it 'should accept read', ->

			it 'should accept write', ->
			describe 'signals', ->
				it 'should accept read with a callback', ->
				it 'should accept write with a callback', ->