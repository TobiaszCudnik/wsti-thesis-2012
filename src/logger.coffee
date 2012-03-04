config = require '../config'

module.exports = class Logger
	@log: (msg) ->
		return no if not config.debug
		config.log? and config.log.push msg
		yes