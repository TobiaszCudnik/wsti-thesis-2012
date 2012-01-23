config = require '../config'
Node = require '../src/node'
PlannerNode = require '../src/plannernode'
Service = require '../src/service'
flow = require 'flow'
_ = require 'underscore'
require '../src/utils'

# debug
config.debug = no
i = require('util').inspect
l = (ms...) -> console.log i m for m in ms

describe 'Node', ->
		
	describe 'object', ->
		it 'should construct with a callback', (next) ->
			node = new Node { host: 'localhost', port: 1234 }, null, (args...) ->
				debugger
				# TODO asserts
				node.close next
		
		it 'should close with a callback', (next) ->
			node = new Node { host: 'localhost', port: 1234 }, null, (args...) ->
				node.close next
		
		it 'should create dnode server', (next) ->
			node = new Node { host: 'localhost', port: 1234 }, null, (args...) ->
				# TODO test with a client
				debugger
				
			no.should.be.ok
		
		it 'should create REST server', (next) ->
			# TODO test with request module
			no.should.be.ok
		
		it 'should convert methods to events', (next) ->
			# TODO test with a client and some signals
			no.should.be.ok
		
		it 'should have signals defined', (next) ->
			# TODO signals definitions
			no.should.be.ok
	
		# TODO? maybe each signals TC
	
###
	describe 'services', ->
		new_service = (name) ->
			new Service name
			  
		it 'should provide services', ->
			services_names = 2.times (i) -> "service#{i}"
			provides = ( new_service name for name in services_names )
			services = provides: provides
			node = new Node null, services
			node.getProvidedServices(no)
				.map( (v) -> v.name )
					.should.equal services_names      
									      
		it 'should know services provided by connected nodes', ->
			# TODO mock connection, write helpers
			no.should.be.ok
			s = 0
			nodes = []
			while s++ < 4
				services_names = [s, s+2].upto (i) -> "service#{i}"
				services = ( new_service name for name in services_names )
				nodes.push new Node {}, services
				if s > 1 and s < 3
#					addr = 
					nodes[-1].connectTo nodes[0]  
			      
			addr = nodes[-1].address
			nodes[0].connectToNode addr.host, addr.port 
						    
			nodes
			services_names = 8.times (i) -> "service#{i}"
						    
			node.getProvidedServices(yes).should.equal services_names
									      
#		it 'should require services', ->
#			no.should.be.ok
#		it 'should know services required by connected nodes', ->
#			no.should.be.ok
								
	describe 'connections', ->
		planner_node = null
#		beforeEach (next) ->
#			config.planner_node = port: 1234, host: 'localhost'
#			planner_scope = {
#				graph: [
#					{ host: 'localhost', port: 2000, connections: [ 1, 2 ] }
#					{ host: 'localhost', port: 2001, connections: [ 2 ] }
#					{ host: 'localhost', port: 2002 }
#				]
#			}
#			c = config.planner_node
#			planner_node = new PlannerNode host: c.host, port: c.port, graph
		
		it 'should get connection to the planner node', ->
			no.should.be.ok
		it 'should be connected to other nodes', ->
			node1 = new Node host: 'localhost', port: 1234, {}
			node2 = new Node host: 'localhost', port: 1235, {}
		it 'should get connection list from the planner node', ->
			no.should.be.ok
		it 'should have weight of each connection', ->
			no.should.be.ok
		it 'should adjust weight of connections', ->
			no.should.be.ok
		# TODO graph?
		it 'should forward a transfer to next graph node', ->
			no.should.be.ok
		# TODO graph?
		it 'should redirect a transfer if better connection available', ->
			no.should.be.ok

	describe 'stats', ->
		it 'should report all transfers to the stat node', ->
		it 'should report own transactions to the stat node', ->
		
###