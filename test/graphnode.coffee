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
					debugger
					planner_node = new PlannerNode graph, planner_node_address, @
				->
					debugger
					nodes = []
					for row in graph
						nodes.push new GraphNode row.address, null, @MULTI()
				-> do done
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
			throw new Error 'not implemented'


#		it 'should fetch the graph structure', ->
#			throw new Error 'not implemented'
#		it 'should connect to nodes according to the graph', ->
#			throw new Error 'not implemented'

#	it 'should provide services', (done) ->
#	it 'should require services', (done) ->
#	it 'should adjust connections once graph changes', (done) ->