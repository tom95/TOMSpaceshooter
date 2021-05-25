"
A TOMMeteor is the base class for big and small meteors. They have a constant movement and deal damage when colliding with spaceships.
"
Class {
	#name : #TOMMeteor,
	#superclass : #TOMSprite,
	#instVars : [
		'deltaMovement',
		'impactSpeed'
	],
	#category : #TOMSpaceShooter
}

{ #category : #collision }
TOMMeteor >> collided: otherObject [
	otherObject collidedWithMeteor: self
]

{ #category : #collision }
TOMMeteor >> collidedWithBurningMeteor: aMeteor [
	self die
]

{ #category : #collision }
TOMMeteor >> collidedWithProjectile: aProjectile [
	self die
]

{ #category : #collision }
TOMMeteor >> collidedWithSpaceship: aSpaceship [
	self die
]

{ #category : #collision }
TOMMeteor >> collisionGroup [ 
	^#meteor
]

{ #category : #accessing }
TOMMeteor >> damage [
	^self subclassResponsibility
]

{ #category : #'initialize-release' }
TOMMeteor >> die [
	self scene ifNotNil: [
		self scene addToGame: ((TOMExplosion newWith: assetFactory)
			matchDimensions: self) ].
	self delete
]

{ #category : #accessing }
TOMMeteor >> impactSpeed [
	^impactSpeed
]

{ #category : #accessing }
TOMMeteor >> impactSpeed: aNumber [
	impactSpeed := aNumber
]

{ #category : #'initialize-release' }
TOMMeteor >> initialize [
	super initialize.
	
	self
		file: self sprites atRandom;
		angle: TOMUtils randomAngle;
		velocity: self maxVelocity.
	
	impactSpeed := 0
]

{ #category : #collision }
TOMMeteor >> isCollider [ 
	^ true
]

{ #category : #accessing }
TOMMeteor >> isDestructibleObstacle [
	^true
]

{ #category : #physics }
TOMMeteor >> maxVelocity [
	^5
]

{ #category : #physics }
TOMMeteor >> physicsStep: dt [
	self impactSpeed > self maxVelocity ifTrue: [
		self
			velocity: self impactSpeed;
			impactSpeed: self impactSpeed - (self slowDown * dt) ].
	
	super physicsStep: dt
]

{ #category : #physics }
TOMMeteor >> place: worldDimensions [
	self position: worldDimensions x atRandom @ worldDimensions y atRandom
]

{ #category : #physics }
TOMMeteor >> slowDown [
	^200
]

{ #category : #accessing }
TOMMeteor >> sprites [
	^self subclassResponsibility
]
