Server = require './server'
Client = require './client'

module.exports =
class Node
	servers_: null
	clients_: null
	connections_: null
	requires: null
	provides: null

	construct: (requires, provides) ->
		@servers_ = []
		@clients_ = []
		@connections_ = []
		@requires = []
		@provides = []

		for r in requires
			@addRequire r

		for r in provides
			@addProvide provides

	addRequire: (req) ->
	deleteRequire: (req) ->

	addProvide: (provide) ->
	deleteProvide: (provide) ->

	# Signals

# Signals for syncing async transfers thou middle nodes
class Transfer
	started_at: null
	finished_at: null
	source_node: null
	target_node: null

class GraphDirectionStrategy
class GraphConnectionsStrategy
class Graph