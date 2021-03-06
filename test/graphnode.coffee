config = require '../config'
GraphNode = require '../src/graphnode'
Client = require '../src/client'
PlannerNode = require '../src/plannernode'
Service = require '../src/service'
flow = require 'flow'
_ = require 'underscore'
require '../src/utils'
require 'should'
sinon = require 'sinon'

describe 'GraphNode', ->

		config_planner_node = config.planner_node
		graph = [
			{
				address: { host: 'localhost', port: 2000 },
				connections: [ 1, 2 ]
			}
			{
				address: { host: 'localhost', port: 2001 },
				connections: [ 2 ]
			}
			{
				address: { host: 'localhost', port: 2002 }
			}
		]
		planner_node_address = host: 'localhost', port: 1234
		planner_node = nodes = null

		beforeEach (done) ->
			flow.exec(
				->
					# disable planner node in the config
					config.planner_node = planner_node_address
					planner_node = new PlannerNode graph, planner_node_address, @
				->
					nodes = []
					for row in graph
						nodes.push new GraphNode row.address, null, @MULTI()
				->
					do done
			)

		afterEach (done) ->
			flow.exec(
				->
					# restore planner node in the config
					config.planner_node = config_planner_node
					planner_node.close @MULTI()
					node.close @MULTI() for node in nodes
				-> do done
			)

		it 'should connect to the planner node', ->
			planner_node.server().clients().length.
				should.equal 3

		it 'should connect to the other nodes according to the graph map', ->
			nodes[0].clients().length
				.should.equal 3
			nodes[1].clients().length
				.should.equal 2
			nodes[2].clients().length
				.should.equal 1

		it 'should update graph connections\' state when the graph changes', (done) ->
			graph2 = clone graph
			graph2.push {
				address: { host: 'localhost', port: 2003 },
				connections: [ 0, 2 ]
			}
			graph = new Graph graph2
			planner_node.setGraph graph, done


#		it 'should fetch the graph structure', ->
#			throw new Error 'not implemented'
#		it 'should connect to nodes according to the graph', ->
#			throw new Error 'not implemented'

#	it 'should provide services', (done) ->
#	it 'should require services', (done) ->
#	it 'should adjust connections once graph changes', (done) ->