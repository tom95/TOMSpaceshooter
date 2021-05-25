"
A TOMFlak is a concrete projectile.

They are tiny animated ""fireballs"" which oscillate. They have a high spread and low range.


"
Class {
	#name : #TOMFlak,
	#superclass : #TOMProjectile,
	#category : #TOMSpaceShooter
}

{ #category : #'game-attributes' }
TOMFlak class >> animatedSpriteCellSize [
	^64 @ 64
]

{ #category : #'game-attributes' }
TOMFlak class >> baseCooldown [
	^0.05
]

{ #category : #'game-attributes' }
TOMFlak class >> baseDamage [ 
	^5
]

{ #category : #'game-attributes' }
TOMFlak class >> baseDecayTime [ 
	^1
]

{ #category : #'game-attributes' }
TOMFlak class >> baseVelocity [ 
	^500
]

{ #category : #'game-attributes' }
TOMFlak class >> scale [
	^0.5
]

{ #category : #'game-attributes' }
TOMFlak class >> scatter [
	^(10 atRandom -5) degreesToRadians
]

{ #category : #'game-attributes' }
TOMFlak class >> sprite [
	^'galaxy'
]

{ #category : #'game-attributes' }
TOMFlak class >> swerveCheckInterval [
	^0.1
]

{ #category : #'game-attributes' }
TOMFlak class >> swerveSpeed [
	^ 2
]

{ #category : #inventory }
TOMFlak class >> title [
	^'Flak'
]

{ #category : #accessing }
TOMFlak >> animatedSpriteCellSize [
	^128 @ 128
]

{ #category : #'initialize-release' }
TOMFlak >> die [
	TOMUtils spawnDefaultSparksAt: self position angle: self angle in: self scene.
	self delete
]

{ #category : #accessing }
TOMFlak >> scale [
	^0.5
]

{ #category : #'initialize-release' }
TOMFlak >> scatter [
	^(10 atRandom -5) degreesToRadians
	
]

{ #category : #accessing }
TOMFlak >> sprite [
	^'galaxy'
]

{ #category : #physics }
TOMFlak >> swerveCheckInterval [
	^0.1
]

{ #category : #physics }
TOMFlak >> swerveSpeed [
	^2
]

{ #category : #physics }
TOMFlak >> swerveTargetAngle [ 
	^ self angle + (TOMUtils
		randomFloatFrom: Float halfPi negated
		to: Float halfPi)
]
