"
A TOMSimpleLaser is a concrete projectile.

It's a non-accelerating projectile. 

Has an experimental sound feature. 

"
Class {
	#name : #TOMSimpleLaser,
	#superclass : #TOMProjectile,
	#category : #TOMSpaceShooter
}

{ #category : #'game-attributes' }
TOMSimpleLaser class >> baseCooldown [
	^0.4
]

{ #category : #'game-attributes' }
TOMSimpleLaser class >> baseDamage [
	^25
]

{ #category : #'game-attributes' }
TOMSimpleLaser class >> baseVelocity [ 
	^800
]

{ #category : #'game-attributes' }
TOMSimpleLaser class >> scale [
	^0.8
]

{ #category : #'game-attributes' }
TOMSimpleLaser class >> scatter [
	^(2 atRandom -1) degreesToRadians 
]

{ #category : #'game-attributes' }
TOMSimpleLaser class >> sprite [
	^'Lasers/laserGreen10'
]

{ #category : #inventory }
TOMSimpleLaser class >> title [
	^'Simple Laser'
]

{ #category : #sound }
TOMSimpleLaser >> sound [
	^#laserGeneric
]

{ #category : #sound }
TOMSimpleLaser >> soundGain [
	^0.3
]
