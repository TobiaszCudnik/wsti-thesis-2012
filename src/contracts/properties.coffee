#### IMPORTS.
$ = require './properties_'
TPropertyData = $.TPropertyData
TPropertyMethod = $.TPropertyMethod
TSignalData = $.TSignalData
TSignalMethod = $.TSignalMethod
TCallback = $.TCallback

#### PROPERTIES.

TProperty = ? {
	property: -> TPropertyMethod
	parseData: -> Any
	initialize: -> Any
	setObjectValue: -> Any
	getObjectValue: -> Any
	preparePassedFunction: -> Any
	setName: -> Any
	getName: -> Any
	getGetter: -> Any
	getSetter: -> Any
	getInit: -> Any
}

TPropertyClass = ? (Str, TPropertyData?, Any?) ==> TProperty

#### SIGNALS.

# @augments TProperty
TSignal = ? {
	initialize: -> Any
	parseData: -> Any
	getGetter: -> Any
	getInit: -> Any
	getSetter: -> Any
	setObjectValue: -> Any
	getObjectValue: -> Any
}

# @augments TPropertyClass
TSignalClass = ? (Str, TSignalData?, Any?) ==> TSignal
# TODO TSignalClass.create, TSignalClass.property

#### EXPORTS

module.exports = {
	instrumentProperties: (scope) ->
		e = scope

		e.Property :: TPropertyClass
		e.Property = e.Property

		e.Signal :: TSignalClass
		e.Signal = e.Signal

		e.signal :: -> TSignalMethod
		e.signal = e.signal

		e.property :: -> TPropertyMethod
		e.property = e.property

	# Properties
	TPropertyMethodFunc: $.TPropertyMethodFunc
	TPropertyMethodObj: $.TPropertyMethodObj
	TPropertyMethod: $.TPropertyMethod
	TPropertyData: $.TPropertyData
	TProperty: TProperty
	TPropertyClass: TPropertyClass

	# Signals
	TSignalMethodFunc: $.TSignalMethodFunc
	# @TODO
#	TSignalMethodObj: $.TSignalMethodObj
	TSignalMethod: $.TSignalMethod
	TSignalData: $.TSignalData
	TSignal: TSignal
	TSignalClass: TSignalClass
}