"
A TOMEvent is an abstract superclass for more specific events.
"
Class {
	#name : #TOMEvent,
	#superclass : #Object,
	#instVars : [
		'timestamp'
	],
	#category : #TOMGameEngine
}

{ #category : #accessing }
TOMEvent >> timestamp [
	^timestamp
]

{ #category : #accessing }
TOMEvent >> timestamp: aTime [
	timestamp := aTime
]
