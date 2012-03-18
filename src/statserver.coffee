flow = require 'flow'
{ RestServer } = require './server'

class StatServer extends RestServer
	constructor: (host, rest_port, port, next) ->
		routes = {}

		super host, rest_port, routes, port, scope, next

	addTransfer: (transfer) ->

	addTransaction: (transaction) ->


module.exports = StatServer