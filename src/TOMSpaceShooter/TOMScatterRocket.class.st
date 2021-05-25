"
A TOMScatterRocket is a concrete projectile.

Tiny ""firework"" rockets, which swerve uncontrollably. 
Minimum of 10 will be spawned by TOMShell, depending on the upgrade level of the weapon.

"
Class {
	#name : #TOMScatterRocket,
	#superclass : #TOMRocket,
	#category : #TOMSpaceShooter
}

{ #category : #'game-attributes' }
TOMScatterRocket class >> baseAcceleration [ 
	^15
]

{ #category : #'game-attributes' }
TOMScatterRocket class >> baseCooldown [
	^1
]

{ #category : #'game-attributes' }
TOMScatterRocket class >> baseDamage [ 
	^70
]

{ #category : #'game-attributes' }
TOMScatterRocket class >> baseDecayTime [ 
	^3
]

{ #category : #'game-attributes' }
TOMScatterRocket class >> baseVelocity [ 
	^100
]

{ #category : #'game-attributes' }
TOMScatterRocket class >> explosionRadius [
	^30
]

{ #category : #'game-attributes' }
TOMScatterRocket class >> preBurnTime [ 
	^0.3
]

{ #category : #'game-attributes' }
TOMScatterRocket class >> scale [
	^0.7
]

{ #category : #'game-attributes' }
TOMScatterRocket class >> scatter [
	^(10 atRandom -5) degreesToRadians 
]

{ #category : #'game-attributes' }
TOMScatterRocket class >> sprite [
	^'Lasers/laserRed04'
]

{ #category : #'game-attributes' }
TOMScatterRocket class >> swerveChance [
	^50
]

{ #category : #'game-attributes' }
TOMScatterRocket class >> swerveCheckInterval [
	^0.2
]

{ #category : #'game-attributes' }
TOMScatterRocket class >> swerveSpeed [
	^0.5
]

{ #category : #inventory }
TOMScatterRocket class >> title [
	^'Scatter Rocket'
]

{ #category : #physics }
TOMScatterRocket >> applyTrail [ 
	
	TOMUtils
		spawnTrailAt: self bottomMidPoint
		angle: self angle 
		color:  (Color r: 0.4 g: 0.4 b: 0.7 alpha: 0.5) 
		scale: self class scale - 0.3 
		in: self scene
	
]

{ #category : #'initialize-release' }
TOMScatterRocket >> die [
	self scene ifNil: [ ^self delete; yourself ].
	
	self applyExplosion.
	
	self scene ifNotNil: [
		self scene addToGame:
			((TOMExplosion newWith: assetFactory) matchDimensions: self withFactor: 6) ].
	
	TOMUtils 
		spawn: 20 
		sparksAt: self position 
		angle: self angle 
		color: (Color r: 0.7 g: 0.4 b: 0.4 alpha: 0.7)
		in: self scene.
	
	self delete
]

{ #category : #'initialize-release' }
TOMScatterRocket >> die: typeOfExplosion [
	" override the specialized die function in order to always get the big explosion trigger "
	self die
]

{ #category : #physics }
TOMScatterRocket >> physicsStep: dt [
	
	super physicsStep: dt.
	
	self ifAliveDo: [
		TOMUtils
			spawnTrailAt: self bottomMidPoint
			angle: self angle
			color: (Color r: 0.4 g: 0.4 b: 0.9)
			scale: 0.3 asPoint
			in: self scene ]
]

{ #category : #sound }
TOMScatterRocket >> soundGain [
	^0.2
]

{ #category : #sound }
TOMScatterRocket >> soundPitch [
	^5.0
]

{ #category : #physics }
TOMScatterRocket >> swerveTargetAngle [
	^self angle + (TOMUtils randomFloatFrom: -24 to: 24)
]
