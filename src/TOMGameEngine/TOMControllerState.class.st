"
A TOMControllerState is a mirror of the C struct containing the current state of a controller.

Primarily used/accessed via TOMUserInputHandler>>apiControllerState:
"
Class {
	#name : #TOMControllerState,
	#superclass : #ExternalStructure,
	#category : #TOMGameEngine
}

{ #category : #'class initialization' }
TOMControllerState class >> fields [
	^#(
		(aButton 'long')
		(bButton 'long')
		(xButton 'long')
		(yButton 'long')
		
		(leftShoulderButton 'long')
		(rightShoulderButton 'long')
		
		(leftStickButton 'long')
		(rightStickButton 'long')
		
		(startButton 'long')
		(backButton 'long')
		(guideButton 'long')
		
		(leftTriggerAxis 'long')
		(rightTriggerAxis 'long')
		
		(leftxAxis 'long')
		(leftyAxis 'long')
		(rightxAxis 'long')
		(rightyAxis 'long'))
]

{ #category : #'class initialization' }
TOMControllerState class >> initialize [
	super initialize.
	self defineFields
]

{ #category : #accessing }
TOMControllerState >> aButton [
	"This method was automatically generated"
	^handle signedLongAt: 1
]

{ #category : #accessing }
TOMControllerState >> aButton: anObject [
	"This method was automatically generated"
	handle signedLongAt: 1 put: anObject
]

{ #category : #accessing }
TOMControllerState >> bButton [
	"This method was automatically generated"
	^handle signedLongAt: 5
]

{ #category : #accessing }
TOMControllerState >> bButton: anObject [
	"This method was automatically generated"
	handle signedLongAt: 5 put: anObject
]

{ #category : #accessing }
TOMControllerState >> backButton [
	"This method was automatically generated"
	^handle signedLongAt: 37
]

{ #category : #accessing }
TOMControllerState >> backButton: anObject [
	"This method was automatically generated"
	handle signedLongAt: 37 put: anObject
]

{ #category : #accessing }
TOMControllerState >> guideButton [
	"This method was automatically generated"
	^handle signedLongAt: 41
]

{ #category : #accessing }
TOMControllerState >> guideButton: anObject [
	"This method was automatically generated"
	handle signedLongAt: 41 put: anObject
]

{ #category : #accessing }
TOMControllerState >> leftShoulderButton [
	"This method was automatically generated"
	^handle signedLongAt: 17
]

{ #category : #accessing }
TOMControllerState >> leftShoulderButton: anObject [
	"This method was automatically generated"
	handle signedLongAt: 17 put: anObject
]

{ #category : #accessing }
TOMControllerState >> leftStickButton [
	"This method was automatically generated"
	^handle signedLongAt: 25
]

{ #category : #accessing }
TOMControllerState >> leftStickButton: anObject [
	"This method was automatically generated"
	handle signedLongAt: 25 put: anObject
]

{ #category : #accessing }
TOMControllerState >> leftTriggerAxis [
	"This method was automatically generated"
	^handle signedLongAt: 45
]

{ #category : #accessing }
TOMControllerState >> leftTriggerAxis: anObject [
	"This method was automatically generated"
	handle signedLongAt: 45 put: anObject
]

{ #category : #accessing }
TOMControllerState >> leftxAxis [
	"This method was automatically generated"
	^handle signedLongAt: 53
]

{ #category : #accessing }
TOMControllerState >> leftxAxis: anObject [
	"This method was automatically generated"
	handle signedLongAt: 53 put: anObject
]

{ #category : #accessing }
TOMControllerState >> leftyAxis [
	"This method was automatically generated"
	^handle signedLongAt: 57
]

{ #category : #accessing }
TOMControllerState >> leftyAxis: anObject [
	"This method was automatically generated"
	handle signedLongAt: 57 put: anObject
]

{ #category : #accessing }
TOMControllerState >> rightShoulderButton [
	"This method was automatically generated"
	^handle signedLongAt: 21
]

{ #category : #accessing }
TOMControllerState >> rightShoulderButton: anObject [
	"This method was automatically generated"
	handle signedLongAt: 21 put: anObject
]

{ #category : #accessing }
TOMControllerState >> rightStickButton [
	"This method was automatically generated"
	^handle signedLongAt: 29
]

{ #category : #accessing }
TOMControllerState >> rightStickButton: anObject [
	"This method was automatically generated"
	handle signedLongAt: 29 put: anObject
]

{ #category : #accessing }
TOMControllerState >> rightTriggerAxis [
	"This method was automatically generated"
	^handle signedLongAt: 49
]

{ #category : #accessing }
TOMControllerState >> rightTriggerAxis: anObject [
	"This method was automatically generated"
	handle signedLongAt: 49 put: anObject
]

{ #category : #accessing }
TOMControllerState >> rightxAxis [
	"This method was automatically generated"
	^handle signedLongAt: 61
]

{ #category : #accessing }
TOMControllerState >> rightxAxis: anObject [
	"This method was automatically generated"
	handle signedLongAt: 61 put: anObject
]

{ #category : #accessing }
TOMControllerState >> rightyAxis [
	"This method was automatically generated"
	^handle signedLongAt: 65
]

{ #category : #accessing }
TOMControllerState >> rightyAxis: anObject [
	"This method was automatically generated"
	handle signedLongAt: 65 put: anObject
]

{ #category : #accessing }
TOMControllerState >> startButton [
	"This method was automatically generated"
	^handle signedLongAt: 33
]

{ #category : #accessing }
TOMControllerState >> startButton: anObject [
	"This method was automatically generated"
	handle signedLongAt: 33 put: anObject
]

{ #category : #accessing }
TOMControllerState >> xButton [
	"This method was automatically generated"
	^handle signedLongAt: 9
]

{ #category : #accessing }
TOMControllerState >> xButton: anObject [
	"This method was automatically generated"
	handle signedLongAt: 9 put: anObject
]

{ #category : #accessing }
TOMControllerState >> yButton [
	"This method was automatically generated"
	^handle signedLongAt: 13
]

{ #category : #accessing }
TOMControllerState >> yButton: anObject [
	"This method was automatically generated"
	handle signedLongAt: 13 put: anObject
]
