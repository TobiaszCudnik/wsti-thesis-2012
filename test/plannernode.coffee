config = require '../config'
PlannerNode = require '../src/plannernode'

describe 'plannernode', ->
	describe 'statnode data', ->
	describe 'graph structures', ->
		planner_node = null
		graph = [
			{ host: 'localhost', port: 2000, connections: [ 1, 2 ] }
			{ host: 'localhost', port: 2001, connections: [ 2 ] }
			{ host: 'localhost', port: 2002 }
		]
		beforeEach (next) ->
			config.planner_node = port: 1234, host: 'localhost'
			planner_scope = {
				graph: graph	
			}
			c = config.planner_node
			addr = host: c.host, port: c.port
			planner_node = new PlannerNode graph, addr, null, next
						
		it 'should return connections for a node', (next) ->
			debugger
			callback = (connections) ->
				debugger
			planner_node.getConnections callback, null, host: graph[0].host, port: graph[0].port