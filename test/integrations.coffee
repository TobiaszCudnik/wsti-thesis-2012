config = require '../config'
Client = require '../src/client'
Server = require '../src/server'
flow = require 'flow'
net = require 'net'
events = require 'events'
_ = require 'underscore'
sugar = require 'sugar'
EventEmitter = require('events').EventEmitter

# debug
config.debug = no
i = require('util').inspect
l = (ms...) -> console.log i m for m in ms

describe 'Connection Graph', ->
	port = 8756
	describe 'Milestone1', ->
#		server = null
#		scope = (client, connection) ->
#			emitter = new events.EventEmitter
#			# string property
#			@foo = 'bar'
#			# echo function
#			@echo = (echo) -> echo
#			# echo callback
#			@callback = (callback, args...) -> callback.apply null, args
#			# event emitter func bindings
#			@['on'] = emitter.on.bind emitter
#			@emit = emitter.emit.bind emitter
#			# async version of emit
#			@emitAsync = (name, params...) ->
#				params = _.union name, params
#				setTimeout emitter.emit( params ), 0
#			connection.on 'ready', =>
#				if client.callback
#					callback = -> client.callback('foo')
#					setTimeout callback, 0
#			# undefined as return needed
#			undefined
		
		# ######### #
		#
		# PROTOTYPE 2
		#
		# ######### #
		# Exchanges image related data between following nodes:
		# - Website
		# - User DB
		# - Image server
		# - Image resize server
		# ######### #
		# QUESTIONS:
		# who is eventemitter? everybody?
		describe 'prototype2', ->
			get_event_emitter (root, datastore) ->
				emitter = new EventEmitter
				# dnode doesn't accept objects from constructors (TODO why?)
				copy = Object.clone emitter
				# bind
				for func, k in copy
					copy[ k ] = func.bind emitter
				# make disposable
				copy.on 'dispose', ->
					emitter = null
					root[ datastore ] = null
				# return
				copy
			
			
			beforeEach (next) ->
				@schema =
					# website server
					1: [ 2, 3,
						events: get_event_emitter @, 'events'
					]
					# image server
					2: [ 4
						images: ['img1', 'img2', 'img3']
						getImages: (specs, next) -> next @images
						events: get_event_emitter @, 'events'
					]
					# users db server
					3: [ 1,
						users: [
							{name: 'user1', photo: 'img1'}
							{name: 'user2', photo: 'img2'}
							{name: 'user3', photo: 'img3'}
						]
						getUserImageNames: (specs, next) ->
							next @users
						events: get_event_emitter @, 'events'
					]
					# image resize server
					4: [ 2,
						getCachedImages: -> @images
						resizeImage: () 
						clearCache: @images = [] 
						# event before_image_input images: []
						# event after_image_input images: []
						# event before_data_output images: []
						# event after_data_output images: []
						# event before_resize_image images: [], size: '\dx\d'
						# event after_resize_image images: [], size: '\dx\d'
						# event before_clear_cache
						# event after_clear_cache
						events: get_event_emitter @, 'events'
					]
				@nodes = {}
				@connections = {}

			it 'it should provide user images with a correct size', (next) ->
				flow.exec(
					-> # start
						for server, clients of @schema
							port = "800#{server}"
							@nodes[ server ] = new Server 'localhost', port, @MULTI()
					->
						for server, clients of @schema
							@connections[ server ] = {}
							scope = clients[-1]
							# bind methods to a scope
							for fn, name of scope
								scope[ name ] = fn.bind scope
							# create connection
							clients[0...-1].forEach (client) =>
								port ="800#{server}"
								node = new Client port, {}, @MULTI()
								@connections[ server ][ client ] = node
							
							
			afterEach (next) ->
				flow.exec(
					->
						for server in @nodes
							server.close @MULTI()
						
					->
						for client in @connections
							client.close @MULTI()
							
					next
				)