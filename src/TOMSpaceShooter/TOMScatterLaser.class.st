"
A TOMScatterLaser is a concrete projectile.

Accelerating laser. Has a small spread.

"
Class {
	#name : #TOMScatterLaser,
	#superclass : #TOMProjectile,
	#category : #TOMSpaceShooter
}

{ #category : #'game-attributes' }
TOMScatterLaser class >> baseAcceleration [ 
	^100
]

{ #category : #'game-attributes' }
TOMScatterLaser class >> baseCooldown [
	^0.5
]

{ #category : #'game-attributes' }
TOMScatterLaser class >> baseDamage [
	^30
]

{ #category : #'game-attributes' }
TOMScatterLaser class >> baseDecayTime [ 
	^2
]

{ #category : #'game-attributes' }
TOMScatterLaser class >> baseVelocity [
	^100
]

{ #category : #'game-attributes' }
TOMScatterLaser class >> preBurnTime [ 
	^0.15
]

{ #category : #'game-attributes' }
TOMScatterLaser class >> scale [ 
	^0.8
]

{ #category : #'game-attributes' }
TOMScatterLaser class >> scatter [
	^(10 atRandom -5) degreesToRadians 
]

{ #category : #'game-attributes' }
TOMScatterLaser class >> sprite [
	^'Lasers/laserRed01'
]

{ #category : #inventory }
TOMScatterLaser class >> title [
	^'Scatter Laser'
]

{ #category : #'initialize-release' }
TOMScatterLaser >> die [
	self die: TOMSmallExplosion
]
