"
A TOMSoundEmitter is an empty TOMSprite that may be configured to emit a sound.
"
Class {
	#name : #TOMSoundEmitter,
	#superclass : #TOMSprite,
	#instVars : [
		'duration',
		'sound',
		'removalQueued',
		'loop',
		'gain'
	],
	#category : #TOMGameEngine
}

{ #category : #'instance creation' }
TOMSoundEmitter class >> newWith: anAssetFactory sound: aSound duration: aNumber [
	 ^self basicNew
			assetFactory: anAssetFactory;
			initialize;
			duration: aNumber;
			sound: aSound;
			yourself
]

{ #category : #accessing }
TOMSoundEmitter >> duration [
	^duration
]

{ #category : #accessing }
TOMSoundEmitter >> duration: aNumber [
	" set to 0 to never have it expire "
	duration := aNumber.
	
	duration <= 0 ifTrue: [ removalQueued := true ]
]

{ #category : #'initialize-release' }
TOMSoundEmitter >> initialize [
	super initialize.
	
	duration := 0.
	loop := false.
	gain := 1.0.
	sound := nil.
	removalQueued := false
]

{ #category : #physics }
TOMSoundEmitter >> physicsStep: dt [
	super physicsStep: dt.
	
	removalQueued ifTrue: [ ^self ].
	
	removalQueued := true.	
	self scene executeDelayed: [ self delete ] in: self duration seconds
]

{ #category : #accessing }
TOMSoundEmitter >> sound [
	^sound
]

{ #category : #accessing }
TOMSoundEmitter >> sound: aSound [
	sound := aSound
]

{ #category : #accessing }
TOMSoundEmitter >> soundGain [
	^gain
]

{ #category : #accessing }
TOMSoundEmitter >> soundGain: aNumber [
	gain := aNumber
]

{ #category : #accessing }
TOMSoundEmitter >> soundLoop [ 
	^loop
]

{ #category : #accessing }
TOMSoundEmitter >> soundLoop: aBoolean [
	loop := aBoolean
]
