"
A TOMControllerEvent contains information about button events sent by a controller.

Instance Variables
	active:		<Boolean>
	button:		<Symbol>
	controllerIndex:		<Integer>
	eventType:		<Symbol>

active
	- whether the given button is being pressed or released

button
	- one of #a, #b, #x, #y, etc.

controllerIndex
	- which controller the event is coming from, value between 1 and 16

"
Class {
	#name : #TOMControllerEvent,
	#superclass : #TOMEvent,
	#instVars : [
		'button',
		'controllerIndex',
		'active'
	],
	#category : #TOMGameEngine
}

{ #category : #accessing }
TOMControllerEvent >> active [
	^active
]

{ #category : #accessing }
TOMControllerEvent >> active: aBoolean [
	active := aBoolean
]

{ #category : #accessing }
TOMControllerEvent >> button [
	^button
]

{ #category : #accessing }
TOMControllerEvent >> button: aButton [
	button := aButton
]

{ #category : #accessing }
TOMControllerEvent >> controllerIndex [
	^controllerIndex
]

{ #category : #accessing }
TOMControllerEvent >> controllerIndex: anIndex [
	controllerIndex := anIndex
]
