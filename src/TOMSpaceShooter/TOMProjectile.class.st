"
TOMProjectile is the abstract template for all projectiles. 

Projectiles are activated by TOMWeapon. Their properties are affected by the weapon's level.
All projectiles can damage damageable objects of other owners.

"
Class {
	#name : #TOMProjectile,
	#superclass : #TOMAnimatedSprite,
	#instVars : [
		'lifeTime',
		'owner',
		'timeUntilNextSwerveCheck',
		'swerveTargetAngle',
		'swerveTarget',
		'upgradeInfo',
		'preBurnRemaining'
	],
	#category : #TOMSpaceShooter
}

{ #category : #'game-attributes' }
TOMProjectile class >> animatedSpriteCellSize [
	" if the given projectile is animated, you may specify the size of each cell here. Otherwise
	  return 0 @ 0 "
	^0 @ 0
]

{ #category : #'game-attributes' }
TOMProjectile class >> baseAcceleration [
	^0
]

{ #category : #'game-attributes' }
TOMProjectile class >> baseCooldown [
	^0.5
]

{ #category : #'game-attributes' }
TOMProjectile class >> baseDamage [
	^5
]

{ #category : #'game-attributes' }
TOMProjectile class >> baseDecayTime [
	^3
]

{ #category : #'game-attributes' }
TOMProjectile class >> baseVelocity [
	^800
]

{ #category : #inventory }
TOMProjectile class >> description [
	^'Description missing'
]

{ #category : #inventory }
TOMProjectile class >> displayIconFile [
	^'Parts/gun02'
]

{ #category : #'game-attributes' }
TOMProjectile class >> explosionRadius [ 
	^0
]

{ #category : #'game-attributes' }
TOMProjectile class >> hasUpgradableCooldown [
	^true
]

{ #category : #'game-attributes' }
TOMProjectile class >> launchSpeedFromOwner [ 
	^true
]

{ #category : #'game-attributes' }
TOMProjectile class >> preBurnTime [ 
	^0
]

{ #category : #'game-attributes' }
TOMProjectile class >> scale [
	^1
]

{ #category : #'game-attributes' }
TOMProjectile class >> scatter [
	^0
]

{ #category : #'game-attributes' }
TOMProjectile class >> sprite [
	^'extra/platform'
]

{ #category : #'game-attributes' }
TOMProjectile class >> swerveChance [ 
	^0
]

{ #category : #'game-attributes' }
TOMProjectile class >> swerveCheckInterval [ 
	^0
]

{ #category : #'game-attributes' }
TOMProjectile class >> swerveSpeed [ 
	^0
]

{ #category : #inventory }
TOMProjectile class >> title [
	^'Weapon'
]

{ #category : #physics }
TOMProjectile >> applyAcceleration: dt [
	preBurnRemaining < 0
		ifTrue:[ self velocity: self velocity + self class baseAcceleration ]
		ifFalse: [ preBurnRemaining := preBurnRemaining - dt ]
]

{ #category : #physics }
TOMProjectile >> applyExplosion [ 
	self class explosionRadius = 0 ifTrue:[ ^self ].
	(self scene spatialHash
		objectsAt: self position
		exactRadius: self class explosionRadius)
		do: [ :sprite | sprite isCollider ifTrue: [ sprite collidedWithProjectile: self ] ]
]

{ #category : #physics }
TOMProjectile >> applyLifeTimeDecay: dt [
	lifeTime := lifeTime + dt.
	lifeTime > self class baseDecayTime ifTrue: [ self die. ^false ].
	
	^true
]

{ #category : #physics }
TOMProjectile >> applySwerve: dt [
	
	(swerveTarget closeTo: self angle) ifTrue: [
		swerveTarget := TOMUtils normalizeAngle: self swerveTargetAngle.
		timeUntilNextSwerveCheck := self class swerveCheckInterval ].
	
	timeUntilNextSwerveCheck := timeUntilNextSwerveCheck - dt.
	timeUntilNextSwerveCheck <= 0 ifTrue: [
		self angle: (TOMUtils
			interpolateAngleFrom: self angle
			to: self swerveTargetAngle
			at: self class swerveSpeed * dt) ]
]

{ #category : #physics }
TOMProjectile >> applyTrail [
	^self
]

{ #category : #collision }
TOMProjectile >> collided: otherObject [
	otherObject collidedWithProjectile: self
]

{ #category : #collision }
TOMProjectile >> collidedWithAnchor: anAnchor [
	self die: TOMExplosion
]

{ #category : #collision }
TOMProjectile >> collidedWithMeteor: aMeteor [
	self die: TOMExplosion
]

{ #category : #collision }
TOMProjectile >> collidedWithSpaceship: aSpaceship [
	(self shouldExplodeUponCollidingWith: aSpaceship) ifTrue: [
		aSpaceship shieldActive
			ifTrue: [ self die: TOMBlueSparkles ]
			ifFalse: [ self die: TOMExplosion ]]
]

{ #category : #collision }
TOMProjectile >> collidedWithTurret: aTurret [
	(self shouldExplodeUponCollidingWith: aTurret) ifTrue: [ self die: TOMExplosion ]
]

{ #category : #collision }
TOMProjectile >> collisionGroup [ 
	^#projectile
]

{ #category : #accessing }
TOMProjectile >> damage [
	upgradeInfo
		ifNotNilDo: [ :upgradeInfo | 	^self class baseDamage * upgradeInfo damage ]
		ifNil: [ ^self class baseDamage ]
]

{ #category : #'initialize-release' }
TOMProjectile >> die [
	" die with the default explosion type "
	self die: TOMRedSparkles
]

{ #category : #'initialize-release' }
TOMProjectile >> die: typeOfExplosionClass [
	self scene ifNotNil: [
		self scene addToGame: ((typeOfExplosionClass newWith: assetFactory) 
			matchDimensions: self).
			self applyExplosion ].
	self delete
]

{ #category : #'initialize-release' }
TOMProjectile >> initialize [
	super initialize.
	
	self
		file: self class sprite size: self class animatedSpriteCellSize;
		loop: true;
		scale: self class scale;
		velocity: self class baseVelocity;
		centerOfRotation: self extent * self class scale / 2;
		zIndex: 30.
	
	lifeTime := 0.
	preBurnRemaining := self class preBurnTime.
	timeUntilNextSwerveCheck := self class swerveCheckInterval
]

{ #category : #collision }
TOMProjectile >> isCollider [
	^true
]

{ #category : #'initialize-release' }
TOMProjectile >> launchHere: launchPosition inDirection: launchAngle withVelocity: launchVelocity owner: anOwner [	
	owner := anOwner.
	
	self class launchSpeedFromOwner
		ifTrue: [ self velocity: self class baseVelocity + launchVelocity ]
		ifFalse: [ self velocity: self class baseVelocity ].
	
	upgradeInfo ifNotNil: [ self velocity: self velocity + upgradeInfo speed ].
	
	self
		angle: launchAngle + self class scatter;
		position: launchPosition - (self extent * self class scale / 2).
]

{ #category : #physics }
TOMProjectile >> maxVelocity [
	^1200
]

{ #category : #accessing }
TOMProjectile >> owner [
	^owner
]

{ #category : #physics }
TOMProjectile >> physicsStep: dt [
	(self applyLifeTimeDecay: dt) ifFalse: [ ^self ].
	
	(self velocity < self maxVelocity and: [self velocity > 0]) ifTrue: [ self applyAcceleration: dt ].
	
	self applySwerve: dt.
	super physicsStep: dt.
	self	applyTrail
]

{ #category : #collision }
TOMProjectile >> shouldExplodeUponCollidingWith: aSprite [
	^((TOMSpaceshooterGame friendlyFire and: [self owner ~~ aSprite]) or:
	  [TOMSpaceshooterGame friendlyFire not and: [aSprite fraction ~= self owner fraction]])
]

{ #category : #accessing }
TOMProjectile >> swerveTargetAngle [
	^self angle
]

{ #category : #accessing }
TOMProjectile >> upgradeInfo [
	^upgradeInfo
]

{ #category : #accessing }
TOMProjectile >> upgradeInfo: anUpgradeInfo [
	upgradeInfo := anUpgradeInfo.
]
