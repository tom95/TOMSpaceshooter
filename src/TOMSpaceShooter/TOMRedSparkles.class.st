"
A TOMRedSparkles is the default despawn animation.



"
Class {
	#name : #TOMRedSparkles,
	#superclass : #TOMAnimatedSprite,
	#category : #TOMSpaceShooter
}

{ #category : #'initialize-release' }
TOMRedSparkles >> initialize [
	super initialize.
	
	self
		file: 'red_sparkles' size: 128 @ 128;
		zIndex: 100
]
