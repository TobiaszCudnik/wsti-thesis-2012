Server = require('./server').Server
Client = require('./client').Client
flow = require 'flow'
sys = require 'sys'

console.log 'Socket IO prototype starting...'

#nodes =
#	# first node
#	0:
#		provides:
#			# service A
#			A: [1]  # for these nodes
#		requires:
#			# service B
#			B: [] # from these nodes
#	# node
#	1:
#		provides:
#			# service A
#			A: []  # for these nodes
#		requires:
#			# service B
#			B: [] # from these nodes
#	# node
#	2:
#		provides:
#			# service A
#			A: [1]  # for these nodes
#		requires:
#			# service B
#			B: [] # from these nodes
#	# node
#	3:
#		provides:
#			# service A
#			A: [1]  # for these nodes
#		requires:
#			# service B
#			B: [] # from these nodes
#	# node
#	4:
#		provides:
#			# service A
#			A: [1]  # for these nodes
#		requires:
#			# service B
#			B: [] # from these nodes

schema =
	1: [2, 3]
	2: [1]
	3: [2]
	4: [2,3]

nodes = {}
connections = {}

flow.exec(
	->
		for server, clients of schema
			nodes[ server ] = new Server "800#{server}", @MULTI()

	# when all server ready
	->
		connections[1] = 2: new Client "8001", @
#	->
#		for server, clients of schema
#			connections[ server ] = {}
#			for client in clients
#				connections[ server ][ client ] = new Client "800#{server}", @MULTI()

	# when all clients connected
	->
		console.log 'All clients connected'

		connections[1][2].send 'foo'

		console.log 'Test data sent'
)

console.log 'Finished WebSocket proto.coffee'