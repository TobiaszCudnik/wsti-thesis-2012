Server = require('./server').Server
Client = require('./client').Client
flow = require 'flow'
sys = require 'sys'

console.log 'Web sockete prototype starting...'

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

for name, clients of schema
		nodes[ name ] = new Server "800#{name}"

		connections[name] = {}
		for node in clients
			connections[name][node] = new Client "800#{node}"

console.log sys.inspect nodes
console.log sys.inspect connections

debugger
connections[1][2].send 'foo'
connections[1][1].send 'foo'

setTimeout(
	-> console.log 'exit'
	5000
)

console.log 'Finished WebSocket proto.coffee'