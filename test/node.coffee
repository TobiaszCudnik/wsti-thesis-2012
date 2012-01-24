config = require '../config'
Node = require '../src/node'
Client = require '../src/client'
PlannerNode = require '../src/plannernode'
Service = require '../src/service'
flow = require 'flow'
_ = require 'underscore'
require '../src/utils'
require 'should'

# debug
config.debug = no
i = require('util').inspect
l = (ms...) -> console.log i m for m in ms

describe 'Node', ->
				
	describe 'object', ->
		
		it 'should construct with a callback', (next) ->
			addr = host: 'localhost', port: 1234
			node = new Node addr, null, (on_start_finish) ->
				node.address.host.should.equal addr.host
				node.address.port.should.equal addr.port
				node.close next
				on_start_finish()
				
		it 'should close with a callback', (next) ->
			node = new Node { host: 'localhost', port: 1234 }, null, (args...) ->
				node.close ->
					yes.should.be.ok
					# jump out of stack trace
					process.nextTick next
				
		it 'should create dnode server', (next) ->
			addr = host: 'localhost', port: 1234
			node = new Node addr, null, (on_start_finish) ->
				# FIXME connect to full addr object
				client = new Client addr.port, null, ->
					client.close node.close.bind node, next
				
		it 'should create REST server', (next) ->
			addr = host: 'localhost', port: 1234
			node = new Node addr, null, (on_start_finish) ->
				request = require 'request'
				request "http://localhost:1234", (err, res, body) ->
					# TODO check
					expect(err).toBeFalsy()
					next()
				
		it 'should convert methods to events', (next) ->
			addr = host: 'localhost', port: 1234
			flow.exec(
				->
					@node = new Node addr, null, @
				(on_start_finish) ->
					@node.on 'test', (next, ret) ->
						next 'foo'
					# FIXME connect to full addr object
					client = new Client addr.port, null, @
				->
					client.remote.emit 'test', @
				(ret) ->
					expect(ret).to.equal 'foo'
					client.close node.close.bind node, next
			)
				
		it 'should have signals defined', (next) ->
			# TODO signals definitions
			no.should.be.ok
		
		# TODO? maybe each signals TC
		
###
#	describe 'services', ->
#		new_service = (name) ->
#			new Service name
#			  
#		it 'should provide services', ->
#			services_names = 2.times (i) -> "service#{i}"
#			provides = ( new_service name for name in services_names )
#			services = provides: provides
#			node = new Node null, services
#			node.getProvidedServices(no)
#				.map( (v) -> v.name )
#					.should.equal services_names      
#									      
#		it 'should know services provided by connected nodes', ->
#			# TODO mock connection, write helpers
#			no.should.be.ok
#			s = 0
#			nodes = []
#			while s++ < 4
#				services_names = [s, s+2].upto (i) -> "service#{i}"
#				services = ( new_service name for name in services_names )
#				nodes.push new Node {}, services
#				if s > 1 and s < 3
##					addr = 
#					nodes[-1].connectTo nodes[0]  
#			      
#			addr = nodes[-1].address
#			nodes[0].connectToNode addr.host, addr.port 
#						    
#			nodes
#			services_names = 8.times (i) -> "service#{i}"
#						    
#			node.getProvidedServices(yes).should.equal services_names
#									      
##		it 'should require services', ->
##			no.should.be.ok
##		it 'should know services required by connected nodes', ->
##			no.should.be.ok
#								
#	describe 'connections', ->
#		planner_node = null
##		beforeEach (next) ->
##			config.planner_node = port: 1234, host: 'localhost'
##			planner_scope = {
##				graph: [
##					{ host: 'localhost', port: 2000, connections: [ 1, 2 ] }
##					{ host: 'localhost', port: 2001, connections: [ 2 ] }
##					{ host: 'localhost', port: 2002 }
##				]
##			}
##			c = config.planner_node
##			planner_node = new PlannerNode host: c.host, port: c.port, graph
#		
#		it 'should get connection to the planner node', ->
#			no.should.be.ok
#		it 'should be connected to other nodes', ->
#			node1 = new Node host: 'localhost', port: 1234, {}
#			node2 = new Node host: 'localhost', port: 1235, {}
#		it 'should get connection list from the planner node', ->
#			no.should.be.ok
#		it 'should have weight of each connection', ->
#			no.should.be.ok
#		it 'should adjust weight of connections', ->
#			no.should.be.ok
#		# TODO graph?
#		it 'should forward a transfer to next graph node', ->
#			no.should.be.ok
#		# TODO graph?
#		it 'should redirect a transfer if better connection available', ->
#			no.should.be.ok
#
#	describe 'stats', ->
#		it 'should report all transfers to the stat node', ->
#		it 'should report own transactions to the stat node', ->
#		
####