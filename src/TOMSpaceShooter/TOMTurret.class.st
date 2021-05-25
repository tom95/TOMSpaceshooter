"
A TOMTurret is a stationary enemy.

It shoots rockets at the player.
"
Class {
	#name : #TOMTurret,
	#superclass : #TOMSprite,
	#traits : 'TOMAIActor',
	#classTraits : 'TOMAIActor classTrait',
	#instVars : [
		'gun',
		'weaponCooldown',
		'lifePoints',
		'target',
		'cannons'
	],
	#category : #TOMSpaceShooter
}

{ #category : #physics }
TOMTurret >> activationDistance [ 
	^2000
]

{ #category : #physics }
TOMTurret >> actor [
	^self
]

{ #category : #alliances }
TOMTurret >> allyInformRadius [
	^8000
]

{ #category : #collision }
TOMTurret >> applyDamage: damage dealtBy: attacker [
	lifePoints := lifePoints - damage.
	
	(attacker notNil and: [attacker fraction ~= self fraction]) ifTrue: [
		self target: attacker; informAllies ].
		
	lifePoints < 0 ifTrue: [ self die ]
]

{ #category : #physics }
TOMTurret >> applyRecoilAnimation: dt [
	" move the gun part back where it belongs if it went back due to recoil "
	cannons do: [ :cannon |
		cannon position y negated < self cannonPositionY ifTrue: [
			cannon position: cannon position x @ 
					(cannon position y negated interpolateTo: self cannonPositionY at: dt * 3) negated ].
		
		(cannon position y negated closeTo: self cannonPositionY) ifTrue: [
			cannon position: cannon position x @ self cannonPositionY negated ]]
]

{ #category : #'initialize-release' }
TOMTurret >> cannonPositionY [
	^24
]

{ #category : #collision }
TOMTurret >> collided: otherObject [
	otherObject collidedWithTurret: self
]

{ #category : #collision }
TOMTurret >> collidedWithProjectile: aProjectile [
	" we don't allow turret stations to hit each other "
	aProjectile owner fraction ~= self fraction ifTrue: [
		self applyDamage: aProjectile damage dealtBy: aProjectile owner ]
]

{ #category : #collision }
TOMTurret >> collidedWithSpaceship: aSpaceship [
	aSpaceship pushDamage > 0 ifTrue: [
		self applyDamage: aSpaceship pushDamage dealtBy: aSpaceship ]
]

{ #category : #'initialize-release' }
TOMTurret >> die [
	self triggerEvent: #destroyed.
	
	self scene ifNotNil: [
		10 timesRepeat: [
			| explosion |
			explosion := (TOMExplosion newWith: assetFactory) matchDimensions: self.
			explosion position: explosion position + (TOMUtils randomVector: 20).
			self scene addToGame: explosion ].
		
		TOMUtils spawnHalo: self center color: (Color r: 1.0 g: 0.4 b: 0.2) velocity: 15 in: self scene ].
	
	self delete
]

{ #category : #physics }
TOMTurret >> findClosestTarget [
	^self scene spatialHash
		closestObjectTo: self position
		within: self activationDistance
		select: [ :object | TOMUtils isEnemy: object for: self ]
]

{ #category : #alliances }
TOMTurret >> informAllies [
	(self actor isNil or: [self actor alive not]) ifTrue: [^self].
	
	(self actor scene spatialHash
		objectsAt: self actor position
		radius: self allyInformRadius
		select: [ :sprite | sprite fraction = self actor fraction ]) do: [ :sprite |
			sprite requestTarget: self target ]
]

{ #category : #'initialize-release' }
TOMTurret >> initialize [
	super initialize.
	self
		file: #'extra/platform';
		fraction: #enemy1.
	
	weaponCooldown := 2.
	lifePoints := self maxLifePoints.
	
	gun := (TOMSprite newWith: assetFactory)
		file: #'Parts/turretBase_big';
		zIndex: 1;
		yourself.
	self addChild: gun fillMode: #center.
	
	cannons := {{#'Parts/gun09'. #topLeft}. {#'Parts/gun10'. #topRight}} collect: [ :spriteAndPosition |
		gun addChild: ((TOMSprite newWith: assetFactory)
			file: spriteAndPosition first;
			zIndex: 2;
			yourself) fillMode: spriteAndPosition second padded: -12 @ self cannonPositionY negated ]
]

{ #category : #collision }
TOMTurret >> isCollider [ 
	^true
]

{ #category : #'initialize-release' }
TOMTurret >> maxLifePoints [
	^1000
]

{ #category : #'initialize-release' }
TOMTurret >> miniMapColor [
	^fraction = #neutral
		ifTrue: [ nil ]
		ifFalse: [ Color veryDarkGray ]
]

{ #category : #physics }
TOMTurret >> physicsStep: dt [
	| activeTarget |
	super physicsStep: dt.
	self applyRecoilAnimation: dt.
	
	activeTarget := nil.
	
	self target ifNotNil: [
		((self target position squaredDistanceTo: self position) > self activationDistance squared or:
		[self target fraction isNil or:
		[self target alive not]])
			ifTrue: [ self target: nil ]
			ifFalse: [ activeTarget := self target ]].
	
	activeTarget ifNil: [ activeTarget := self findClosestTarget ].
	
	activeTarget ifNotNil: [
		self shootAt: activeTarget center time: dt target: activeTarget ]
]

{ #category : #alliances }
TOMTurret >> requestTarget: aTarget [
	" attack the new target if we don't have an active one "
	self target ifNil: [ self target: aTarget ]
]

{ #category : #physics }
TOMTurret >> shootAt: aPosition time: dt target: aTarget [
	gun angle: (TOMUtils angleFrom: self center to: aPosition).
	weaponCooldown := weaponCooldown + dt.
	
	weaponCooldown > self weaponCooldownTime ifTrue: [
		weaponCooldown := 0.
		cannons do: [ :cannon |
			self scene addToGame: ((TOMHomingRocket newWith: assetFactory)
				launchHere: cannon topMidPoint
				inDirection: gun angle
				withVelocity: 0
				owner: self;
				target: aTarget;
				yourself).
				
				cannon position: cannon position x @ 0 ]]
]

{ #category : #accessing }
TOMTurret >> target [
	^target
]

{ #category : #accessing }
TOMTurret >> target: aSprite [
	target := aSprite.
	
	aSprite ifNotNil: [
		aSprite when: #destroyed send: #target: to: self with: nil ]
]

{ #category : #physics }
TOMTurret >> weaponCooldownTime [
	^2
]
