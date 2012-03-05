#### Properties Contract.
# @link https://github.com/TobiaszCudnik/jsprops

#### IMPORTS

# Internal properties contracts.
{
	TCallback
	TEventEmitterAsync
	TPropertyData
	TPropertyMethodFunc
	TPropertyMethodObj
	TPropertyMethod
	TSignalCallback
	TSignalData
	TSignalGetter
	TSignalMethodFunc
	TSignalMethod
	TSignalCheck
	TSignalInstanceof
	TAsyncSignalMap
	TSignalRet
} = require './properties_'

#### PROPERTIES

TPropertyGetter = ? ( (Any?, Any?, Any?, Any?, Any?) -> Any) -> Any
# Property Factory class object.
TProperty = ? {
	property: (Any?, Any?, Any?, Any?, Any?) -> TPropertyMethod
	parseData: Any
	initialize: Any
	setObjectValue: Any
	getObjectValue: Any
	preparePassedFunction: Any
	setName: Any
	getName: Any
	getGetter: (Any?, Any?, Any?, Any?, Any?) -> TPropertyGetter
	getSetter: Any
	getInit: Any
}

# **Property Factory** class constructor.
# Use it only to extend when building new classes.
TPropertyClass = ? (Str, TPropertyData?, Any?) ==> TProperty

#### SIGNALS

TSignalGetter = (Any?) -> TSignalRet
# Signal Factory class object.
#
# @augments TProperty
TSignal = ? {
	initialize: Any
	parseData: Any
	getGetter: (Any?, Any?, Any?, Any?, Any?) -> TSignalGetter
	getInit: Any
	getSetter: Any
	setObjectValue: Any
	getObjectValue: Any
}

# **Signal Factory** class constructor.
# Use it only to extend when building new classes.
#
# @augments TPropertyClass
TSignalClass = ? (Str, TSignalData?, Any?) ==> TSignal

#### EXPORTS

module.exports = {
	# Puts contracts on an export scope.
	applyContracts: (scope) ->
		e = scope

		e.Property :: TPropertyClass
		e.Property = e.Property

		e.Signal :: TSignalClass
		e.Signal = e.Signal

		e.signal :: (Any?, Any?, Any?, Any?, Any?) -> TSignalMethod
		e.signal = e.signal

		e.property :: (Any?, Any?, Any?, Any?, Any?) -> TPropertyMethod
		e.property = e.property

	# Properties exports.
	TCallback
	TEventEmitterAsync
	TPropertyData
	TPropertyMethodFunc
	TPropertyMethodObj
	TPropertyMethod
	TProperty

	# Signals exports.
	TSignalCallback
	TSignalData
	TSignalGetter
	TSignalMethodFunc
	TSignalMethod
	TSignalCheck
	TSignalInstanceof
	TAsyncSignalMap
	TSignalRet
	TSignal
	TSignalClass
}