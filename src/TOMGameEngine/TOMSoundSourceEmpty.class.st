"
A TOMSoundActorEmpty is a Null-Object for sound actors
"
Class {
	#name : #TOMSoundSourceEmpty,
	#superclass : #TOMSoundSource,
	#category : #TOMGameEngine
}

{ #category : #accessing }
TOMSoundSourceEmpty >> ambient [
	^false
]

{ #category : #accessing }
TOMSoundSourceEmpty >> ambient: aBoolean [
	^self
]

{ #category : #accessing }
TOMSoundSourceEmpty >> direction [
	^0 asPoint
]

{ #category : #accessing }
TOMSoundSourceEmpty >> direction: aDirection [
	^self
]

{ #category : #control }
TOMSoundSourceEmpty >> disable [
	^self
]

{ #category : #control }
TOMSoundSourceEmpty >> enable [
	^self
]

{ #category : #accessing }
TOMSoundSourceEmpty >> gain [
	^1.0
]

{ #category : #accessing }
TOMSoundSourceEmpty >> gain: aNumber [
	^self
]

{ #category : #accessing }
TOMSoundSourceEmpty >> ifEmpty: aBlock [
	aBlock value
]

{ #category : #accessing }
TOMSoundSourceEmpty >> loop [
	^false
]

{ #category : #accessing }
TOMSoundSourceEmpty >> loop: aBoolean [
	^self
]

{ #category : #accessing }
TOMSoundSourceEmpty >> pitch [
	^1
]

{ #category : #accessing }
TOMSoundSourceEmpty >> pitch: aNumber [
	^self
]

{ #category : #accessing }
TOMSoundSourceEmpty >> position [
	^0 asPoint
]

{ #category : #accessing }
TOMSoundSourceEmpty >> position: aPoint [
	^self
]

{ #category : #accessing }
TOMSoundSourceEmpty >> sound: aSound [
	^self
]

{ #category : #accessing }
TOMSoundSourceEmpty >> velocity [
	^0 asPoint
]

{ #category : #accessing }
TOMSoundSourceEmpty >> velocity: aNumber [
	^self
]
