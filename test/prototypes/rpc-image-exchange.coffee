config = require '../../config'
Client = require '../../src/client'
Server = require '../../src/server'
flow = require 'flow'
net = require 'net'
events = require 'events'
_ = require 'underscore'
sugar = require 'sugar'
EventEmitter = require('events').EventEmitter
assert = require('assert').ok

# debug
config.debug = no
i = require('util').inspect
l = (ms...) ->
	console.log i m for m in ms if config.debug
	ms

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
	port_start = 8856
	port = port_start
	get_event_emitter = (root, datastore) ->
		emitter = new EventEmitter
		copy = {}
		# dnode doesn't accept objects from constructors (TODO why?)
		# bind
		for name, func of emitter
			# TODO...
			if func.constructor is Function
				copy[ name ] = func.bind emitter
		# make disposable
		copy.on 'dispose', ->
			emitter = null
			root[ datastore ] = null
		# return
		copy

	test = {}

	beforeEach ->
		port = port_start

		class ImagePromise
			constructor: (@specs) ->
				@name = @specs.size.name
				@width = @specs.size.width
				@height = @specs.size.height
				l 'new image promise'

		test.schema =
			# website server
			1: {
				'name': 'website',
				data: [
					events: get_event_emitter @, 'events'
				]
			}
			# image server
			2: {
				'name': 'images',
				data: [ 1,
					images: ['img1', 'img2', 'img3']
					getImagesPromise: (specs, next) ->
						# TODO allow local to node connections here based on the service
						promises = ( new ImagePromise(spec) for spec in specs )
						next promises
					events: get_event_emitter @, 'events'
				]
			}
			# users db server
			3: {
				'name': 'users-db'
				data: [ 1,
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
			}
			# image resize server
			4: {
				'name': 'image-resize',
				data: [ 2,
					getCachedImages: -> @images
					resizeImage: (spec, next) ->
						l 'resizeImage'
#								spec.name, spec.size.width, spec.size.height
						# TODO communicate with external service
						spec.done = yes
						spec.output = '/path/to/file'
						setTimeout(
							=>
								@events.emit 'after_resize_image', spec
								next spec
							0
						)

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
      }

		test.nodes = {}
		test.connections = {}

		l 'beforeEach finished'

	it 'should provide user images with a correct size', (next) ->
		flow.exec(

			## get servers running
			-> # start
				l 'started'
				Object.keys(test.schema).forEach (server) =>
					port = "800#{server}"
					scope = test.schema[ server ].data[-1..-1][0]
					# bind methods to a scope
					for name, fn of scope
						if fn.constructor is Function
							scope[ name ] = fn.bind scope
					test.nodes[ server ] = new Server 'localhost', port, scope, @MULTI()

				l 'all servers initialized'

			## get clients running
			->
				l 'all servers listening'
				for server, clients of test.schema
					name = clients.name
					# index by server id and name
					test.connections[ server ] = test.connections[ name ] = {}
					# create connections
					# closed loop scope to preserve connection refs
					clients.data[0...-1].forEach (client) =>
						port ="800#{server}"
						# TODO no scope for the client
						node = new Client port, {}, @MULTI()
						test.connections[ server ][ client ] = node
						client_name = test.schema[ client ].name
						# index by client name
						test.connections[ name ][ client_name ] = test.connections[ server ][ client ]
				l 'all client initialized'

			## get user images names
			->
				l 'all clients listening'
				w2u = test.connections['users-db']['website'].remote
				w2u.getUserImageNames {}, @

			## get sized images
			(images) ->
				l 'after getUserImageNames'
				w2i = test.connections['images']['website'].remote
				# TODO get size from website service (layout actually)
				specs = ( { name: img, size: { width: 100, height: 100 } } for img in images )
				w2i.getImagesPromise specs, @

			## resize images
			(promises) ->
				l 'getImagesPromise'
				assert promises.length > 0
				w2r = test.connections['image-resize']['images'].remote
				promises.forEach (promise) =>
					spec = promise.specs
					w2r.resizeImage spec, @MULTI()

			## return
			->
				next l 'END!'
			)

	afterEach (next) ->
		flow.exec(
			->
				for server, clients of test.connections
					for client, connection of clients
						connection.close @MULTI()

			->
				for id, server of test.nodes
					server.close @MULTI()

			next
		)