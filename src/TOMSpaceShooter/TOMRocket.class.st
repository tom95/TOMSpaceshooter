"
A TOMRocket is a concrete projectile.

Rockets are accelerating projectiles with a small explosionRadius. 
The utilise a ""preBurnTime"", which delays their acceleration. Once they accelerate they will spawn a trail.

"
Class {
	#name : #TOMRocket,
	#superclass : #TOMProjectile,
	#instVars : [
		'hasHadExhaustParticle'
	],
	#category : #TOMSpaceShooter
}

{ #category : #'game-attributes' }
TOMRocket class >> baseAcceleration [
	^40
]

{ #category : #'game-attributes' }
TOMRocket class >> baseCooldown [
	^1
]

{ #category : #'game-attributes' }
TOMRocket class >> baseDamage [ 
	^80
]

{ #category : #'game-attributes' }
TOMRocket class >> baseDecayTime [ 
	^2
]

{ #category : #'game-attributes' }
TOMRocket class >> baseVelocity [
	^50
]

{ #category : #'game-attributes' }
TOMRocket class >> explosionRadius [
	^100
]

{ #category : #'game-attributes' }
TOMRocket class >> preBurnTime [ 
	^0.4
]

{ #category : #'game-attributes' }
TOMRocket class >> scale [
	^0.8
]

{ #category : #'game-attributes' }
TOMRocket class >> scatter [
	^(10 atRandom -5) degreesToRadians 
]

{ #category : #'game-attributes' }
TOMRocket class >> sprite [
	^'Lasers/laserBlue06'
]

{ #category : #inventory }
TOMRocket class >> title [
	^'Rocket'
]

{ #category : #physics }
TOMRocket >> applyTrail [ 
	
	preBurnRemaining < 0 ifTrue: 
		[TOMUtils spawnTrailAt: self bottomMidPoint 
		angle: self angle 
		color: (Color r:1.0 g:0.7 b:0.0 alpha: 0.7) 
		scale: self class scale - 0.3
		in: self scene ]
]

{ #category : #'initialize-release' }
TOMRocket >> die [
	self scene ifNil: [ ^self delete; yourself ].
	
	self applyExplosion.
	
	self scene ifNotNil: [
		self scene addToGame:
			((TOMExplosion newWith: assetFactory) matchDimensions: self withFactor: 6).
		TOMUtils spawnSmallHalo: self center color: (Color h: 20 atRandom s: 1 v: 1) velocity: 15 in: self scene. ].
	
	self delete
]

{ #category : #'initialize-release' }
TOMRocket >> die: typeOfExplosion [
	" override the specialized die function in order to always get the big explosion trigger "
	self die
]

{ #category : #sound }
TOMRocket >> sound [
	^#thrusters
]

{ #category : #sound }
TOMRocket >> soundLoop [
	^true
]
