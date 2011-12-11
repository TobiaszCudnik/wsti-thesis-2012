config = require '../config'

module.exports = class Logger
	@log: ->
		return no if not config.debug
		config.log? and config.log.push msg