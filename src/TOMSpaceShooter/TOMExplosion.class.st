"
A TOMExplosion is an animated sprite displaying the default explosion type.
"
Class {
	#name : #TOMExplosion,
	#superclass : #TOMAnimatedSprite,
	#category : #TOMSpaceShooter
}

{ #category : #'initialize-release' }
TOMExplosion >> initialize [
	super initialize.
	
	self
		file: 'explosion' size: 128 @ 128;
		zIndex: 100
]

{ #category : #sound }
TOMExplosion >> sound [
	^#blast
]

{ #category : #sound }
TOMExplosion >> soundGain [
	^self scale min: 1.2
]

{ #category : #sound }
TOMExplosion >> soundPitch [
	^1.0 / self scale clampLow: 0.5 high: 2.0
]

{ #category : #'initialize-release' }
TOMExplosion >> timePerFrame [
	^0.005425
]
