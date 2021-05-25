"
A TOMSimpleMine is a concrete projectile.

Mines are the only projectiles that decelerate towards 0. (This is why we have a seemingly arbitrary >0 check in TOMProjectile physicsStep). 

When they collide with another object or die through decay they explode magnificently.
"
Class {
	#name : #TOMSimpleMine,
	#superclass : #TOMProjectile,
	#category : #TOMSpaceShooter
}

{ #category : #'game-attributes' }
TOMSimpleMine class >> animatedSpriteCellSize [ 
	^128 @ 128
]

{ #category : #'game-attributes' }
TOMSimpleMine class >> baseAcceleration [ 
	^1 negated
]

{ #category : #'game-attributes' }
TOMSimpleMine class >> baseCooldown [
	^3
]

{ #category : #'game-attributes' }
TOMSimpleMine class >> baseDamage [ 
	^150
]

{ #category : #'game-attributes' }
TOMSimpleMine class >> baseDecayTime [ 
	^3
]

{ #category : #'game-attributes' }
TOMSimpleMine class >> baseVelocity [ 
	^0
]

{ #category : #'game-attributes' }
TOMSimpleMine class >> explosionRadius [
	^200
]

{ #category : #'game-attributes' }
TOMSimpleMine class >> scale [
	^0.5
]

{ #category : #'game-attributes' }
TOMSimpleMine class >> scatter [
	^(10 atRandom -5) degreesToRadians 
]

{ #category : #'game-attributes' }
TOMSimpleMine class >> sprite [
	^'spaceBomb'
]

{ #category : #inventory }
TOMSimpleMine class >> title [
	^'Simple Mine'
]

{ #category : #'initialize-release' }
TOMSimpleMine >> die [
	self scene ifNil: [ ^self delete; yourself ].
	
	self applyExplosion.
	
	self scene ifNotNil: [
		self scene addToGame:
			((TOMExplosion newWith: assetFactory) matchDimensions: self withFactor: 6) ].
	
	TOMUtils spawnHalo: self center color: (Color h: 20 atRandom s: 1 v: 1) velocity: 30 in: self scene.
	
	self delete
]

{ #category : #'initialize-release' }
TOMSimpleMine >> die: typeOfExplosion [
	self die
]

{ #category : #accessing }
TOMSimpleMine >> timePerFrame [ 
	^0.4
]
