"
A TOMSoundSource is the base class for any sound sources in 2D space.
"
Class {
	#name : #TOMSoundSource,
	#superclass : #TOMSoundActor,
	#category : #TOMGameEngine
}

{ #category : #accessing }
TOMSoundSource >> ambient [
	^self subclassResponsibility
]

{ #category : #accessing }
TOMSoundSource >> ambient: aBoolean [
	^self subclassResponsibility
]

{ #category : #control }
TOMSoundSource >> disable [
	^self subclassResponsibility
]

{ #category : #control }
TOMSoundSource >> enable [
	^self subclassResponsibility
]

{ #category : #accessing }
TOMSoundSource >> gain [
	^self subclassResponsibility
]

{ #category : #accessing }
TOMSoundSource >> gain: aNumber [
	^self subclassResponsibility
]

{ #category : #accessing }
TOMSoundSource >> ifEmpty: aBlock [
	^self
]

{ #category : #accessing }
TOMSoundSource >> loop [
	^self subclassResponsibility
]

{ #category : #accessing }
TOMSoundSource >> loop: aBoolean [
	^self subclassResponsibility
]

{ #category : #accessing }
TOMSoundSource >> pitch [
	^self subclassResponsibility
]

{ #category : #accessing }
TOMSoundSource >> pitch: aNumber [
	^self subclassResponsibility
]

{ #category : #accessing }
TOMSoundSource >> sound: aSound [
	^self subclassResponsibility
]
