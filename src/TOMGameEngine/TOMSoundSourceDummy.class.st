"
A TOMSoundActorDummy is an empty sound actor with only one difference: it advertises itself as non empty by not executing the ifEmpty block.
"
Class {
	#name : #TOMSoundSourceDummy,
	#superclass : #TOMSoundSourceEmpty,
	#category : #TOMGameEngine
}

{ #category : #accessing }
TOMSoundSourceDummy >> ifEmpty: aBlock [
	^self
]
