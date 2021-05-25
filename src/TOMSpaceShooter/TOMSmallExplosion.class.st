"
A TOMSmallExplosion is an animated explosion.

"
Class {
	#name : #TOMSmallExplosion,
	#superclass : #TOMAnimatedSprite,
	#category : #TOMSpaceShooter
}

{ #category : #'initialize-release' }
TOMSmallExplosion >> initialize [
	super initialize.
	
	self
		file: #'smallExplosion' size: 128 @ 128;
		zIndex: 100
]
