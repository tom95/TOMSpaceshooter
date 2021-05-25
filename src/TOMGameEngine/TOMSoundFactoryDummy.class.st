"
A TOMSoundFactoryDummy is an empty implementation of a TOMSoundFactory. It may be used if sound is disabled.
"
Class {
	#name : #TOMSoundFactoryDummy,
	#superclass : #TOMSoundFactory,
	#category : #TOMGameEngine
}

{ #category : #updating }
TOMSoundFactoryDummy >> createListener [
	^TOMSoundListenerDummy new
]

{ #category : #updating }
TOMSoundFactoryDummy >> createSource [
	^TOMSoundSourceDummy new
]
