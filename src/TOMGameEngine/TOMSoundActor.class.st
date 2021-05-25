"
A TOMSoundActor is the base class for any actors related to sound in 2D space. It offers utitilty functions and an interface to position and configure it.
"
Class {
	#name : #TOMSoundActor,
	#superclass : #Object,
	#category : #TOMGameEngine
}

{ #category : #accessing }
TOMSoundActor >> angle: anAngle velocity: aNumber [
	| direction |
	
	direction := (TOMUtils vectorForAngle: anAngle length: 1).
	
	self
		direction: direction;
		velocity: direction * aNumber
]

{ #category : #accessing }
TOMSoundActor >> direction [
	^self subclassResponsibility
]

{ #category : #accessing }
TOMSoundActor >> direction: aPoint [
	^self subclassResponsibility
]

{ #category : #accessing }
TOMSoundActor >> mirrorSprite: aSprite dt: dt [
	self
		position: aSprite center;
		angle: aSprite angle velocity: aSprite velocity * dt
]

{ #category : #accessing }
TOMSoundActor >> position [
	^self subclassResponsibility
]

{ #category : #accessing }
TOMSoundActor >> position: aPoint [
	^self subclassResponsibility
]

{ #category : #accessing }
TOMSoundActor >> velocity [
	^self subclassResponsibility 
]

{ #category : #accessing }
TOMSoundActor >> velocity: aPoint [
	^self subclassResponsibility 
]
