config = require '../config'
Client = require '../src/client'
Server = require('../src/server').Server
RestServer = require('../src/server').RestServer
flow = require 'flow'
net = require 'net'
events = require 'events'
request = require 'request'
_ = require 'underscore'

# debug
config.debug = no
i = require('util').inspect
l = (ms...) -> console.log i m for m in ms

describe 'Node', ->
				
	describe 'services', ->
		it 'should provide services', ->
			no.should.be.ok
		it 'should know services provided by connected nodes', ->
			no.should.be.ok
		it 'should require services', ->
			no.should.be.ok
		it 'should know services required by connected nodes', ->
			no.should.be.ok
		
	describe 'connections', ->
		it 'should be connected to other nodes', ->
			no.should.be.ok
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