"
A TOMKeyboardEvent contains information about key presses and releases sent by a keyboard.

Instance Variables
	key:		<Symbol>
	eventType:		<Symbol>

eventType
	- one of #down, #up

key
	- one of #a, #b, #c, #up, #down, #enter etc.
"
Class {
	#name : #TOMKeyboardEvent,
	#superclass : #TOMEvent,
	#instVars : [
		'key',
		'eventType'
	],
	#category : #TOMGameEngine
}

{ #category : #accessing }
TOMKeyboardEvent >> eventType [
	^eventType
]

{ #category : #accessing }
TOMKeyboardEvent >> eventType: aType [
	eventType := aType
]

{ #category : #accessing }
TOMKeyboardEvent >> key [
	^key
]

{ #category : #accessing }
TOMKeyboardEvent >> key: aKey [
	key := aKey
]
