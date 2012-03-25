module.exports =
	debug: no
#	debug: yes
	contracts: no
#	contracts: no
	log: []
	planner_node: null

if module.exports.contracts
	global.contracts = yes
else
	contracts = require 'contracts.js'
	contracts.enabled false