config = require '../config'
PlannerNode = require '../src/plannernode'
sinon = require 'sinon'
{ Graph } = require '../src/graph'
require 'sugar'

describe 'plannernode', ->
	describe 'statnode data', ->

	describe 'graph structures', ->

		mock = planner_node = null
		config_planner_node = config.planner_node
		graph = [
			{
				address: { host: 'localhost', port: '2000' },
				connections: [ 1, 2 ]
			}
			{
				address: { host: 'localhost', port: '2001' },
				connections: [ 2 ]
			}
			{
				address: { host: 'localhost', port: '2002' }
			}
		]

		beforeEach (next) ->
			addr = port: 1234, host: 'localhost'
			config_planner_node = config.planner_node
			config.planner_node = addr
			planner_node = new PlannerNode graph, addr, next
#			mock = sinon.mock planner_node
		afterEach (next) ->
			config.planner_node = config_planner_node
			planner_node.close next

		describe 'unit', ->
			it 'should return connections for a node', (done) ->
				planner_node.getGraph (graph_json) ->
					graph = Graph.fromJson graph_json
					connections = graph.getConnections graph_json[0].address
					connections.should.eql [ graph_json[1].address, graph_json[2].address ]
					done()

			it 'should expose signals', ->
				scope = planner_node.scope()
				signals = [ 'getGraph' ]
				scope[ signal].should.be.a 'function' for signal in signals

#		describe 'properties', ->
#			beforeEach ->
#				class Foo
#					bar: new Property
#			it 'should accept read', ->
#
#			it 'should accept write', ->
#			describe 'signals', ->
#				it 'should accept read with a callback', ->
#				it 'should accept write with a callback', ->