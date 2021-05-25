"
A TOMBlueSparkles is a simple animated sprite displaying blueish sparkles, maybe comparable to eletrical discharge. Used for projectiles that collide with a shield.
"
Class {
	#name : #TOMBlueSparkles,
	#superclass : #TOMAnimatedSprite,
	#category : #TOMSpaceShooter
}

{ #category : #'initialize-release' }
TOMBlueSparkles >> initialize [
	super initialize.
	
	self file: 'blue_sparkles' size: 128@128.
	self zIndex: 100
]

{ #category : #sound }
TOMBlueSparkles >> sound [
	^#fizzleShort
]
