"
A TOMBurningMeteor is a large blue meteor occassionally flying through space that deal massive damage upon impact and cannot be destroyed.
"
Class {
	#name : #TOMBurningMeteor,
	#superclass : #TOMSprite,
	#category : #TOMSpaceShooter
}

{ #category : #collision }
TOMBurningMeteor >> collided: otherObject [
	otherObject collidedWithBurningMeteor: self
]

{ #category : #collision }
TOMBurningMeteor >> damage [
	^1337
]

{ #category : #'initialize-release' }
TOMBurningMeteor >> initialize [
	super initialize.
	
	self
		extent: 64 @ 64;
		angle: 360 atRandom degreesToRadians;
		centerOfRotation: self extent / 2
]

{ #category : #collision }
TOMBurningMeteor >> isCollider [ 
	^true
]

{ #category : #'initialize-release' }
TOMBurningMeteor >> miniMapColor [
	^Color white
]

{ #category : #physics }
TOMBurningMeteor >> physicsStep: dt [
	| manager |
	super physicsStep: dt.
	
	self scene ifNil: [ ^self ].
	
	self moveAlongAxis: dt * self velocity.
	
	manager := self scene particleManager.
	2 timesRepeat: [
		(manager createParticle: (self assetFactory getTexture: 'extra/particle_round'))
			position: self position;
			scale: 4 asPoint;
			color: (Color r: 0.2 g: 0.4 b: 0.7);
			duration: 2;
			velocity: ((TOMUtils vectorForAngle: self angle length: 10) + (TOMUtils randomVector: 3.0));
			lengthMultiplier: 0.0;
			varyWithSpeed: true ]
]

{ #category : #physics }
TOMBurningMeteor >> velocity [
	^620
]
