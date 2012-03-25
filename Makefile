NODE = node-harmony --harmony
NODE_DEBUG = node-harmony debug --harmony
MOCHA = node_modules/.bin/mocha
BUILDER = node_modules/contracts.coffee/bin/coffee

TESTS = build/vanilla/test/bootstrap.js \
		build/node_modules/semaphores/test/semaphores.js \
		build/node_modules/eventemitter2async/test/async/test.js \
		build/node_modules/jsprops/test/properties.js \
		build/node_modules/jsprops/test/signals.js \
		build/vanilla/test/server.js \
		build/vanilla/test/client.js \
		build/vanilla/test/node.js \
		build/vanilla/test/plannernode.js \
		build/vanilla/test/graphnode.js \
		build/vanilla/test/prototypes/dnode-signals.js \
		build/vanilla/test/prototypes/rpc-image-exchange.js

RUN = ~/node_modules/.bin/runjs

POST_PARAMS = -r should \
		-R spec

LIVE = buzz

break:
	$(NODE) --debug-brk \
		$(MOCHA) \
		$(TESTS) \
		$(POST_PARAMS) \
		--timeout 600000

break-live:
	$(LIVE) $(NODE) --debug-brk \
		$(MOCHA) \
		$(TESTS) \
		$(POST_PARAMS) \
		--timeout 600000

debug:
	$(NODE_DEBUG) \
		$(MOCHA) \
		$(TESTS) \
		$(POST_PARAMS)

test:
	$(NODE) \
		$(MOCHA) \
		$(TESTS) \
		$(POST_PARAMS)

test-live:
	$(RUN) \
		$(MOCHA) \
		$(TESTS) \
		$(POST_PARAMS)

build-deps:
	make -C node_modules/jsprops

build:
	$(BUILDER) \
		-o $ROOT/build/vanilla \
		-c $ROOT/build/vanilla-sources

build-live:
	$(BUILDER) \
		-o $ROOT/build/vanilla \
		-cw $ROOT/build/vanilla-sources

# TODO build-contracts build-contracts-live

.PHONY: test break build