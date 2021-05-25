"
A TOMHomingRocket is a concrete projectile.

Smaller rockets, which lightly adjust their flight path towards a target. 
"
Class {
	#name : #TOMHomingRocket,
	#superclass : #TOMRocket,
	#instVars : [
		'target'
	],
	#category : #TOMSpaceShooter
}

{ #category : #'game-attributes' }
TOMHomingRocket class >> baseAcceleration [
	^15
]

{ #category : #'game-attributes' }
TOMHomingRocket class >> baseCooldown [
	^1
]

{ #category : #'game-attributes' }
TOMHomingRocket class >> baseDamage [
	^30
]

{ #category : #'game-attributes' }
TOMHomingRocket class >> baseDecayTime [ 
	^5
]

{ #category : #'game-attributes' }
TOMHomingRocket class >> baseVelocity [ 
	^100
]

{ #category : #'game-attributes' }
TOMHomingRocket class >> explosionRadius [
	^50
]

{ #category : #'game-attributes' }
TOMHomingRocket class >> sprite [
	^'Lasers/laserRed06'
]

{ #category : #'game-attributes' }
TOMHomingRocket class >> swerveChance [
	^100
]

{ #category : #'game-attributes' }
TOMHomingRocket class >> swerveCheckInterval [
	^0.5
]

{ #category : #'game-attributes' }
TOMHomingRocket class >> swerveSpeed [ 
	^1.5
]

{ #category : #inventory }
TOMHomingRocket class >> title [
	^'Homing Rocket'
]

{ #category : #physics }
TOMHomingRocket >> applyTrail [ 
	
	preBurnRemaining < 0 ifTrue: [
		TOMUtils
			spawnTrailAt: self bottomMidPoint 
			angle: self angle 
			color: (Color r:1 g:0.4 b:0.2 alpha:1) 
			scale: self class scale - 0.3
			in: self scene ]
	
]

{ #category : #physics }
TOMHomingRocket >> detectTarget: aScene from: aPosition angle: anAngle [
	| objectsInCone |
	
	objectsInCone := TOMUtils
		objectsInConeStartPoint: aPosition
		startWidth: 200
		angle: anAngle
		endWidth: self targetDetectionConeWidth
		distance: self targetDetectionConeDistance
		in: aScene
		select: [ :object |
			object fraction notNil and: [ object fraction ~= self owner fraction and: [object ~~ self owner ]]].
	
	^TOMUtils closestObject: objectsInCone asOrderedCollection to: aPosition
]

{ #category : #'initialize-release' }
TOMHomingRocket >> die [
	TOMUtils spawnDefaultSparksAt: self position angle: self angle in: self scene.
	
	self scene addToGame: ((TOMSoundEmitter
		newWith: self assetFactory
		sound: #fizzleShort
		duration: 1)
		position: self center;
		soundGain: 0.2;
		yourself).
	
	self delete
]

{ #category : #physics }
TOMHomingRocket >> imprecision [
	^TOMUtils randomFloatFrom: -0.1 to: 0.1
]

{ #category : #sound }
TOMHomingRocket >> soundGain [
	^0.7
]

{ #category : #sound }
TOMHomingRocket >> soundPitch [
	^3.5
]

{ #category : #physics }
TOMHomingRocket >> swerveTargetAngle [
	self target ifNil: [
		self target: (self detectTarget: self scene from: self position angle: self angle) ].
	
	(self target notNil and: [self target fraction notNil])
		ifTrue: [
			^(TOMUtils angleFrom: self position to: self target center) + self imprecision ]
		ifFalse: [ ^self angle ]
]

{ #category : #physics }
TOMHomingRocket >> target [
	^target
]

{ #category : #physics }
TOMHomingRocket >> target: aSprite [
	target := aSprite
]

{ #category : #physics }
TOMHomingRocket >> targetDetectionConeDistance [ 
	^2000
]

{ #category : #physics }
TOMHomingRocket >> targetDetectionConeWidth [
	^1000
]
