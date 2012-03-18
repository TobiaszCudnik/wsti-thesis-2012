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
i = require('util').inspect
l = (ms...) -> console.log i m for m in ms

describe 'Graph Node', ->

#	it 'should provide services', (done) ->
#	it 'should require services', (done) ->
	it 'should request a graph from the planner node', (done) ->
	it 'should connect to nodes according to the graph', (done) ->
	it 'should adjust connections once graph changes', (done) ->