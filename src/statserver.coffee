flow = require 'flow'
server = require './server'

class StatServer extends server.RestServer
	constructor: (host, rest_port, port, next) ->
		routes = {}

		super host, rest_port, routes, port, scope, next

	addTransfer: (transfer) ->

	addTransaction: (transaction) ->
		