"
A TOMSoundFactory is the abstract base class for creating sound listeners and sources.
"
Class {
	#name : #TOMSoundFactory,
	#superclass : #Object,
	#instVars : [
		'assetsBasePath'
	],
	#category : #TOMGameEngine
}

{ #category : #updating }
TOMSoundFactory >> activateScene: aScene [
	aScene ambientSound ifNotNilDo: [ :sound |
		aScene soundProxy ifEmpty: [
			aScene soundProxy: ((self createSourceFor: sound)
				gain: aScene ambientSoundGain;
				ambient: true;
				loop: true;
				yourself) ].
		aScene soundProxy enable ]
]

{ #category : #updating }
TOMSoundFactory >> activateSprite: aSprite [
	aSprite sound ifNotNil: [
		aSprite soundProxy ifEmpty: [
			aSprite soundProxy: ((self createSourceFor: aSprite sound)
				loop: aSprite soundLoop;
				gain: aSprite soundGain;
				pitch: aSprite soundPitch;
				yourself) ].
		aSprite soundProxy enable ]
]

{ #category : #accessing }
TOMSoundFactory >> assetsBasePath [
	^assetsBasePath
]

{ #category : #accessing }
TOMSoundFactory >> assetsBasePath: aString [
	assetsBasePath := aString
]

{ #category : #updating }
TOMSoundFactory >> createListener [
	^self subclassResponsibility
]

{ #category : #updating }
TOMSoundFactory >> createSource [
	^self subclassResponsibility
]

{ #category : #updating }
TOMSoundFactory >> createSourceFor: aSound [
	^self createSource
		sound: aSound;
		yourself
]

{ #category : #updating }
TOMSoundFactory >> deactivateScene: aScene [
	aScene soundProxy disable
]

{ #category : #updating }
TOMSoundFactory >> deactivateSprite: aSprite [
	aSprite soundProxy
		disable;
		finalize.
	
	aSprite soundProxy: TOMSoundSourceEmpty new
]

{ #category : #updating }
TOMSoundFactory >> update: dt [
	" may be implemented by subclasses "
]
