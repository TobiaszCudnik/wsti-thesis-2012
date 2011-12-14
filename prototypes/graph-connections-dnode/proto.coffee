#Server = require('./server').Server
#Client = require('./client').Client
flow = require 'flow'
sys = require 'sys'
dnode = require 'dnode'

console.log 'Web socket prototype starting...'

schema =
	1: [2, 3]
	2: [1]
	3: [2]
	4: [2, 3]

nodes = {}
connections = {}

flow.exec(
	-> # start
		for server, clients of schema
			port = "800#{server}"
			nodes[ server ] = dnode foo: (a) ->
				console.log "remote foo #{a}"
				'foobarbaz'
			nodes[ server ].listen port

		for server, clients of schema
			connections[ server ] = {}
			for client in clients
				multi = @MULTI()
				((server, client) ->
					dnode.connect "800#{server}", (remote) ->
						connections[ server ][ client ] = remote
						multi()
				)(server, client)

	-> # when all clients connected
		console.log 'All clients connected'

		connections[1][2].foo 'bar'

		console.log 'Test data sent'
)

console.log 'Finished WebSocket proto.coffee'