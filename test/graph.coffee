config = require '../config'
Client = require '../src/client'
Server = require '../src/server'
flow = require 'flow'
events = require 'events'
_ = require 'underscore'
require('should')

# debug
config.debug = no
i = require('util').inspect
l = (ms...) -> console.log i m for m in ms  

describe 'Connection Graph', ->
	describe 'Connections', ->
	describe 'Request flow', ->