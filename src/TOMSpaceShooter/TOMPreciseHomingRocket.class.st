"
A TOMPreciseHomingRocket is a concrete projectile.

It's a very precise smaller homingRocket.

"
Class {
	#name : #TOMPreciseHomingRocket,
	#superclass : #TOMHomingRocket,
	#category : #TOMSpaceShooter
}

{ #category : #'game-attributes' }
TOMPreciseHomingRocket class >> baseAcceleration [ 
	^10
]

{ #category : #'game-attributes' }
TOMPreciseHomingRocket class >> baseVelocity [
	^100
]

{ #category : #'game-attributes' }
TOMPreciseHomingRocket class >> explosionRadius [ 
	^50
]

{ #category : #'game-attributes' }
TOMPreciseHomingRocket class >> preBurnTime [ 
	^0.2
]

{ #category : #'game-attributes' }
TOMPreciseHomingRocket class >> scale [ 
	^0.8
]

{ #category : #'game-attributes' }
TOMPreciseHomingRocket class >> swerveCheckInterval [ 
	^0.05
]

{ #category : #'game-attributes' }
TOMPreciseHomingRocket class >> swerveSpeed [ 
	^5
]

{ #category : #inventory }
TOMPreciseHomingRocket class >> title [
	^'Precise Homing Rocket'
]

{ #category : #physics }
TOMPreciseHomingRocket >> applyTrail [ 
	
	preBurnRemaining < 0 ifTrue: [
		TOMUtils
			spawnTrailAt: self bottomMidPoint 
			angle: self angle 
			color: (Color red alpha: 0.5) 
			scale: self class scale - 0.3
			in: self scene ]
	
]

{ #category : #physics }
TOMPreciseHomingRocket >> swerveCheckInterval [
	^0.05
]

{ #category : #physics }
TOMPreciseHomingRocket >> swerveSpeed [ 
	^5
]
