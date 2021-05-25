"
A TOMMouseEvent contains information about clicks sent by a mouse.

Instance Variables
	button:		<Symbol>
	eventType:		<Symbol>
	position:		<Point>

button
	- one of #left, #right

eventType
	- one of #down, #up

position
	- position of the mouse pointer

"
Class {
	#name : #TOMMouseEvent,
	#superclass : #TOMEvent,
	#instVars : [
		'button',
		'position',
		'eventType'
	],
	#category : #TOMGameEngine
}

{ #category : #accessing }
TOMMouseEvent >> button [
	^button
]

{ #category : #accessing }
TOMMouseEvent >> button: aButton [
	button := aButton
]

{ #category : #accessing }
TOMMouseEvent >> eventType [
	^eventType
]

{ #category : #accessing }
TOMMouseEvent >> eventType: aType [
	eventType := aType
]

{ #category : #accessing }
TOMMouseEvent >> position [
	^position
]

{ #category : #accessing }
TOMMouseEvent >> position: aPoint [
	position := aPoint
]
