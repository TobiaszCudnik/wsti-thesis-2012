config = require '../config'
Node = require '../src/node'
Client = require '../src/client'
PlannerNode = require '../src/plannernode'
Service = require '../src/service'
flow = require 'flow'
_ = require 'underscore'
require '../src/utils'
require 'should'
sinon = require 'sinon'
jsprops = require 'jsprops'

# debug
config.debug = no
i = require('util').inspect
l = (ms...) -> console.log i m for m in ms

describe 'Node', ->

	describe 'object', ->

		it 'should construct with a callback', (next) ->
			addr = host: 'localhost', port: 1234
			node = new Node addr, null, ->
				# requires async to get node value
				node.address().host.should.equal addr.host
				node.address().port.should.equal addr.port
				node.close next

		it 'should close with a callback', (next) ->
			addr = host: 'localhost', port: 1234
			node = new Node addr, null, ->
				node.close ->
					process.nextTick next

		it 'should create dnode server', (next) ->
			addr = host: 'localhost', port: 1234
			node = new Node addr, null, ->
				client = new Client addr, null, ->
					client.close node.close.bind node, next

#		it 'should create REST server', (next) ->
#			addr = host: 'localhost', port: 1234
#			node = new Node addr, null, (on_start_finish) ->
#				request = require 'request'
#				request "http://localhost:1234/", (err, res, body) ->
#					# TODO check
#					err.should.be.false()
#					next()

		it 'should expose signals', (next) ->
			addr = host: 'localhost', port: 1234
			node = new Node addr, null, ->
				node.scope().length > 0
				node.close next

		it 'should have an async event emitter', (next) ->
			addr = host: 'localhost', port: 1234
			# mock Node class
			stub = sinon.stub Node.prototype
			# unmock the constructor
			Node.prototype.start.returns once: ->
			# unmock event emitter
			emiter_proto = Object.getPrototypeOf Node.prototype
			for name, fn of emiter_proto
				continue if not emiter_proto.hasOwnProperty name
				Node.prototype[ name ].restore?()
			@node = new Node addr, null, ->
			@node.on 'foo', (next, ret) ->
				# TODO test out the ret value
				setTimeout next, 0
			@node.emit 'foo', ->
				# unstub Node class
				for name, fn of Node.prototype
					Node.prototype[ name ].restore?()
				next()

	describe 'integration', ->
		spy = client = node =  scope = null

		beforeEach (next) ->
			scope = {}
			scope.addr = addr = host: 'localhost', port: 1234
			node = new Node addr, null, ->
				client = new Client addr, null, next

		it 'should allow client to connect', (next) ->
			client.remote.should.be.ok
			client.close node.close.bind node, next

		it 'should provide signals', (test_done) ->
			fired = no
			# bind to signal
			client.remote.getProvidedServices_.on (next, ret) ->
				fired = yes
				next ret
			# emit signal
			client.remote.getProvidedServices ->
				debugger
				fired.should.be.ok
				client.close ->
					node.close test_done
		
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
			throw new Error 'not implemented'
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
#			throw new Error 'not implemented'
#		it 'should know services required by connected nodes', ->
#			throw new Error 'not implemented'
								
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
			throw new Error 'not implemented'
		it 'should be connected to other nodes', ->
			node1 = new Node host: 'localhost', port: 1234, {}
			node2 = new Node host: 'localhost', port: 1235, {}
		it 'should get connection list from the planner node', ->
			throw new Error 'not implemented'
		it 'should have weight of each connection', ->
			throw new Error 'not implemented'
		it 'should adjust weight of connections', ->
			throw new Error 'not implemented'
		# TODO graph?
		it 'should forward a transfer according to strategies', ->
			throw new Error 'not implemented'

	describe 'stats', ->
		it 'should report all transfers to the stat node', ->
		it 'should report own transactions to the stat node', ->
#		
####