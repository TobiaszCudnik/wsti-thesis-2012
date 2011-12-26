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
				class ImagePromise
					constructor: (@name, @width, @height) ->

				@schema =
					# website server
					1: 'name': 'website', data: [ 2, 3,
						events: get_event_emitter @, 'events'
					]
					# image server
					2: 'name': 'image', data: [ 4
						images: ['img1', 'img2', 'img3']
						getImagesPromise: (specs, next) ->
							# TODO allow local to node connections here based on the service
							next @images
						events: get_event_emitter @, 'events'
					]
					# users db server
					3: 'name': 'users-db', data: [ 1,
						users: [
							{name: 'user1', photo: 'img1'}
							{name: 'user2', photo: 'img2'}
							{name: 'user3', photo: 'img3'}
						]
						getUserImageNames: (specs, next) ->
							# TODO specs
							next _.map @users, (obj) ->
								return obj.photo
						events: get_event_emitter @, 'events'
					]
					# image resize server
					4: 'name': 'image-resize', data: [ 2,
						getCachedImages: -> @images
						resizeImage: (name, width, height) ->
							# TODO communicate with external service
							promise = new ImagePromise(name, width, height)
							setTimeout =>
								@events.emit 'after_resize_image', promise
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

			it 'should provide user images with a correct size', (next) ->
				flow.exec(

					-> # start
						for server, clients of @schema
							port = "800#{server}"
							@nodes[ server ] = new Server 'localhost', port, @MULTI()

					->
						for server, clients of @schema
							name = clients[0]
							scope = clients[-1]
							@connections[ server ] = @connections[ name ] = {}
							# bind methods to a scope
							for fn, name of scope
								scope[ name ] = fn.bind scope
							# create connection
							clients[1...-1].forEach (client) =>
								port ="800#{server}"
								node = new Client port, scope, @MULTI()
								@connections[ server ][ client ] = node
								client_name = @schema[ client ][0]
								@connections[ name ][ client_name ] = @connections[ server ][ client ]

					->
						w2u = @connections['website']['users-db'].remote
						w2u.getUserImageNames @

					(images) ->
						w2i = @connections['website']['images'].remote
						# TODO get size from website service (layout actually)
						specs = ( name: img, size: { width: 100, height: 100 } for img in images )
						w2i.getImagesPromise specs, @

					(specs) ->
						w2r = @connections['images']['image-resize'].remote
						specs.forEach (image) ->
							callback = @MULTI()
							w2r.events.on 'after_resize_image', (image_promise) ->
								callback() if image_promise.name is image
							w2r.resizeImage image.name, image.size.with, image.size.height
					->
						console.log 'END!'

							
			afterEach (next) ->
				flow.exec(
					->
						for client in @connections
							client.close @MULTI()
						
					->
						for server in @nodes
							server.close @MULTI()
							
					next
				)