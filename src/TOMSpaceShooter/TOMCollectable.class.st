"
A TOMCollectable is the base class for collectable items in the game, anything that disappears upon contact and applies a certain effect or value to its collector. Possible applications are coins or powerups.
"
Class {
	#name : #TOMCollectable,
	#superclass : #TOMSprite,
	#category : #TOMSpaceShooter
}

{ #category : #collision }
TOMCollectable >> applyEffectsOn: aSpaceship [
	^self subclassResponsibility 
]

{ #category : #collision }
TOMCollectable >> collided: anOtherObject [
	anOtherObject collidedWithCollectable: self
]

{ #category : #collision }
TOMCollectable >> collidedWithSpaceship: aSpaceship [
	self applyEffectsOn: aSpaceship.
	self die
]

{ #category : #'initialize-release' }
TOMCollectable >> die [
	self delete
]

{ #category : #collision }
TOMCollectable >> isCollider [ 
	^true
]
