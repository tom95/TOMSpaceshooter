"
A TOMSoundListenerDummy is an empty implementation of a sound listener. It may be used when no sound shall be played.
"
Class {
	#name : #TOMSoundListenerDummy,
	#superclass : #TOMSoundActor,
	#category : #TOMGameEngine
}

{ #category : #accessing }
TOMSoundListenerDummy >> direction [
	^0 asPoint
]

{ #category : #accessing }
TOMSoundListenerDummy >> direction: aPoint [
	^self
]

{ #category : #accessing }
TOMSoundListenerDummy >> position [
	^0 asPoint
]

{ #category : #accessing }
TOMSoundListenerDummy >> position: aPoint [
	^self
]

{ #category : #accessing }
TOMSoundListenerDummy >> velocity [
	^0 asPoint
]

{ #category : #accessing }
TOMSoundListenerDummy >> velocity: aPoint [
	^self
]
