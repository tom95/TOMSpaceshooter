"
TOMSpaceship is the abstract template for the main actors in the game - the spaceships.
Can be controlled by players or AI.

Each ship has properties like lifePoints, speed, acceleration, etc...
Every ship has its own inventory and will drop gold coins upon despawning. 

"
Class {
	#name : #TOMSpaceship,
	#superclass : #TOMSprite,
	#instVars : [
		'commandProvider',
		'velocityBoost',
		'lifePoints',
		'speedIndicators',
		'currentDamageMarker',
		'slots',
		'paint',
		'targetVelocity',
		'activeShield',
		'activeInventorySlot',
		'valueOfResources',
		'pushDamage'
	],
	#category : #TOMSpaceShooter
}

{ #category : #attributes }
TOMSpaceship class >> baseTurnSpeed [
	^250
]

{ #category : #attributes }
TOMSpaceship class >> brakeFactor [
	^0.98
]

{ #category : #colors }
TOMSpaceship class >> colorForFraction: aFraction [
	^(Dictionary new
		add: #enemy1 -> #black;
		add: #enemy2 -> #orange;
		add: #enemy3 -> #blue;
		add: #neutral -> #green;
		yourself) at: aFraction
]

{ #category : #attributes }
TOMSpaceship class >> maxLifePoints [
	^1000
]

{ #category : #attributes }
TOMSpaceship class >> maxVelocity [
	^600
]

{ #category : #'instance creation' }
TOMSpaceship class >> newWith: anAssetFactory fraction: aFraction [

	 ^self basicNew
			assetFactory: anAssetFactory;
			paint: (self colorForFraction: aFraction);
			fraction: aFraction;
			initialize;
			yourself
]

{ #category : #'instance creation' }
TOMSpaceship class >> newWith: anAssetFactory paint: aColorSymbol [

	 ^self basicNew
			assetFactory: anAssetFactory;
			paint: aColorSymbol;
			fraction: #player;
			initialize;
			yourself
]

{ #category : #attributes }
TOMSpaceship class >> spaceshipType [
	"returns type of spaceship"
	^self subclassResponsibility
]

{ #category : #colors }
TOMSpaceship class >> sprite: paint [
	" returns path to the spaceship sprite for the given paint "
	^'Spaceships/', self spaceshipType asString, '_', paint asString
]

{ #category : #attributes }
TOMSpaceship class >> swerveFactorAtMaxVelocity [
	^0.6
]

{ #category : #movement }
TOMSpaceship >> acceleration [
	^0.8
]

{ #category : #inventory }
TOMSpaceship >> activeInventorySlot [
	^activeInventorySlot
]

{ #category : #movement }
TOMSpaceship >> applyAcceleration: dt with: commands [
	(commands includes: #accelerate)
		ifTrue: [ targetVelocity := self class maxVelocity ]
		ifFalse: [ targetVelocity := 0.0 ].
	
	self velocity: ((self velocity
		interpolateTo: targetVelocity
		at: dt * self acceleration) clampHigh: self class maxVelocity) + velocityBoost
]

{ #category : #movement }
TOMSpaceship >> applyBraking: dt with: commands [

	(commands includes: #brake) ifTrue: [
		self velocity: self velocity * self class brakeFactor ]
]

{ #category : #collision }
TOMSpaceship >> applyDamage: damage dealtBy: otherObject [
	" apply the given damage points to the spaceship. Optionally pass in the object that dealt the damage  or nil "
	| actualDamage |
	damage <= 0 ifTrue: [ ^self ].
	
	actualDamage := damage.
	activeShield ifNotNil: [ actualDamage := activeShield reduceDamage: actualDamage ].
	
	lifePoints := lifePoints - actualDamage.
	
	self applyDamageMarkers.
	
	self triggerEvent: #healthChanged withArguments: (Array
		with: (lifePoints asFloat / self class maxLifePoints)
		with: damage negated
		with: otherObject).
	(otherObject notNil and: [otherObject fraction notNil]) ifTrue: [
		self triggerEvent: #attacked with: otherObject ].
	
	lifePoints <= 0 ifTrue: [
		(self alive and:
		[otherObject fraction notNil and:
		[otherObject fraction = #player]])
			ifTrue: [ self scene reportScore: #spaceshipKilled ].
		
		self die ]
]

{ #category : #collision }
TOMSpaceship >> applyDamageMarkers [
	" removes current marker and adds a new one in quarter steps corresponding to damage level "
	| damagePercentage marker |
	
	currentDamageMarker ifNotNil: [ self removeChild: currentDamageMarker ].

	damagePercentage := lifePoints / self class maxLifePoints.

	damagePercentage >= 0.75 ifTrue: [ ^self ].
	damagePercentage < 0.75 ifTrue: [ marker := '1' ].
	damagePercentage < 0.5 ifTrue: [ marker := '2' ].
	damagePercentage < 0.25 ifTrue: [ marker := '3' ].
	
	currentDamageMarker := (TOMSprite newWith: assetFactory)
		file: #'Damage/', self class spaceshipType asString, '_damage', marker;
		zIndex: self zIndex + 1;
		yourself.
	
	self addChild: currentDamageMarker
]

{ #category : #movement }
TOMSpaceship >> applySlotChange: dt with: commands [
	
	(commands includes: #'Inventory Slot 1') ifTrue:[
		activeInventorySlot := 1 ].
	
	(commands includes: #'Inventory Slot 2') ifTrue:[
		activeInventorySlot := 2 ].
	
	(commands includes: #'Inventory Slot 3') ifTrue:[
		activeInventorySlot := 3 ].
	
	(commands includes: #'Inventory Slot 4') ifTrue:[
		activeInventorySlot := 4 ]
]

{ #category : #movement }
TOMSpaceship >> applySwerve: dt with: commands [
	
	(commands includes: #left) ifTrue: [
		self angle: self angle + (self turnSpeed: dt atSpeed: velocity) ].

	(commands includes: #right) ifTrue: [
		self angle: self angle - (self turnSpeed: dt atSpeed: velocity) ].
]

{ #category : #store }
TOMSpaceship >> checkEnterStore: dt with: commands [
	(commands includes: #enterStore) ifTrue: [
		(self scene spatialHash
		objectsAt: self position
		radius: self storeEnterProximityRadius
		select: [ :sprite | sprite isTradePartner ]) ifNotEmpty: [
			self scene requestSceneSwitch: TOMStoreScene rebuild: true argument: self ]]
]

{ #category : #collision }
TOMSpaceship >> collided: otherObject [
	otherObject collidedWithSpaceship: self
]

{ #category : #collision }
TOMSpaceship >> collidedWithBurningMeteor: aBurningMeteor [
	self applyDamage: aBurningMeteor damage dealtBy: aBurningMeteor
]

{ #category : #collision }
TOMSpaceship >> collidedWithMeteor: aMeteor [
	self applyDamage: aMeteor damage dealtBy: aMeteor
]

{ #category : #collision }
TOMSpaceship >> collidedWithProjectile: aProjectile [
	(TOMSpaceshooterGame friendlyFire not and: [aProjectile owner fraction = self fraction]) ifTrue: [^self].
		
	aProjectile owner ~~ self ifTrue: [
		self applyDamage: aProjectile damage dealtBy: aProjectile owner ]
]

{ #category : #collision }
TOMSpaceship >> collidedWithSpaceship: aSpaceship [
	aSpaceship pushDamage > 0 ifTrue: [
		self applyDamage: aSpaceship pushDamage dealtBy: aSpaceship ]
]

{ #category : #accessing }
TOMSpaceship >> commandProvider [
	^commandProvider
]

{ #category : #accessing }
TOMSpaceship >> commandProvider: provider [
	commandProvider := provider
		spaceship: self;
		yourself
]

{ #category : #'initialize-release' }
TOMSpaceship >> die [
	self triggerEvent: #destroyed.
	self ifNotAliveDo: [ ^self delete; yourself ].
	
	self maxCoinDropUponDeath atRandom timesRepeat: [
		self scene addToGame: ((TOMCoin newWith: self assetFactory)
			position: self center + (TOMUtils randomVectorFrom: -60 to: 60);
			yourself) ].
	
	self
		makeExplosion;
		delete
]

{ #category : #inventory }
TOMSpaceship >> fillSlot: slot with: item [
	(slots at: slot) ifNotNilDo: [ :oldItem | oldItem deactivate: self ].
	
	slots at: slot put: item
]

{ #category : #movement }
TOMSpaceship >> hasPostRender [
	^TOMSpaceshooterGame aiDebug
]

{ #category : #'initialize-release' }
TOMSpaceship >> initialize [
	super initialize.
	
	velocityBoost := 0.
	pushDamage := 0.
	lifePoints := self class maxLifePoints.
	slots := Array new: 4.
	activeInventorySlot := 1.
	valueOfResources := 0.
	
	self
		file: (self class sprite: self paint);
		zIndex: 50;
		setupDefaultSlots;
		setupSpeedIndicators
]

{ #category : #collision }
TOMSpaceship >> isCollider [ 
	^true
]

{ #category : #accessing }
TOMSpaceship >> lifePercent [
	^lifePoints / self class maxLifePoints
]

{ #category : #accessing }
TOMSpaceship >> lifePoints [
	^lifePoints
]

{ #category : #physics }
TOMSpaceship >> makeExhaustParticles [
	" create particles for exhaust. we have three rows, a mid one and two side ones that move in sine waves "
	| manager baseVelocity perpendicularVelocity textureGlow isMid textureLine |
	(fraction ~= #player or: [targetVelocity <= 0]) ifTrue: [ ^self ].
	
	manager := self scene particleManager.
	textureLine := self assetFactory getTexture: 'extra/particle_line'.
	textureGlow := self assetFactory getTexture: 'extra/particle_glow'.
	
	baseVelocity := TOMUtils vectorForAngle: self angle length: (self velocity / self class maxVelocity * 15) negated.
	perpendicularVelocity := baseVelocity leftRotated * (0.4 * (Time millisecondClockValue / 100.0) sin).
	
	isMid := true.
	
	{baseVelocity + (TOMUtils randomVector: 1.0).
		baseVelocity + perpendicularVelocity + (TOMUtils randomVector: 0.3).
		baseVelocity - perpendicularVelocity + (TOMUtils randomVector: 0.3)} do: [ :velocity |
		
		(manager createParticle: textureLine)
			position: self bottomMidPoint;
			angle: self angle;
			color: (Color r: 1 g: 1 b: 1 alpha: 0.7);
			velocity: velocity.
		
		(manager createParticle: textureGlow)
			position: self bottomMidPoint;
			angle: self angle;
			color: (isMid
				ifTrue: [ Color r: 0.87 g: 0.35 b: 0.04 alpha: 0.7 ]
				ifFalse: [ Color r: 1.0 g: 0.73 b: 0.12 alpha: 0.7 ]);
			velocity: velocity.
		
		isMid := false ]
]

{ #category : #physics }
TOMSpaceship >> makeExplosion [
	4 timesRepeat: [
		| explosion |
		explosion := (TOMExplosion newWith: assetFactory)
			matchDimensions: self withFactor: 5.
		explosion position: explosion position + (TOMUtils randomVectorFrom: -50 to: 50).
		explosion scale: (TOMUtils randomFloatFrom: explosion scale * 0.2 to: explosion scale).
		self scene
			executeDelayed: [ :scene | scene addToGame: explosion ]
			in: (TOMUtils randomFloatFrom: 0.1 to: 0.6) seconds ].
	
	TOMUtils spawnHalo: self center color: (Color h: 20 atRandom s: 1 v: 1) velocity: 30 in: self scene
]

{ #category : #inventory }
TOMSpaceship >> maxCoinDropUponDeath [
	^6
]

{ #category : #physics }
TOMSpaceship >> miniMapColor [
	fraction caseOf: {
		[#enemy1] -> [^Color red].
		[#enemy2] -> [^Color r: 0.7 g: 0 b: 0].
		[#enemy3] -> [^Color r: 0 g: 0 b: 0.7 ].
		[#neutral] -> [^Color r: 0 g: 0.8 b: 0.1] }
	otherwise: [^Color veryDarkGray]
]

{ #category : #accessing }
TOMSpaceship >> paint [
	^paint
]

{ #category : #accessing }
TOMSpaceship >> paint: aColorSymbol [
	paint := aColorSymbol
]

{ #category : #physics }
TOMSpaceship >> physicsStep: dt [
	| commands |
	self commandProvider ifNil: [ ^ self ].
	
	commands := self commandProvider activeCommands: dt.
	
	slots do: [ :slot | slot ifNotNil: [ slot update: dt for: self ]].
	
	self
		applySlotChange: dt with: commands;
		applyAcceleration: dt with: commands;
		applySwerve: dt with: commands;
		applyBraking: dt with: commands;
		shootWeapon: dt with: commands;
		checkEnterStore: dt with: commands.
	
	super physicsStep: dt.
	
	self
		makeExhaustParticles;
		updateSpeedIndicators: dt
]

{ #category : #movement }
TOMSpaceship >> postRender: aSpriteRenderer [
	" this only serves AI debug purposes. It is toggled via #hasPostRender "
	
	(commandProvider respondsTo: #debugPlotToTarget:) ifTrue: [
		commandProvider debugPlotToTarget: aSpriteRenderer ]
]

{ #category : #accessing }
TOMSpaceship >> pushDamage [
	^pushDamage
]

{ #category : #accessing }
TOMSpaceship >> pushDamage: aNumber [
	pushDamage := aNumber
]

{ #category : #inventory }
TOMSpaceship >> repair [
	| delta |
	delta := self class maxLifePoints - lifePoints.
	lifePoints := self class maxLifePoints.
	
	self triggerEvent: #healthChanged withArguments: (Array
		with: 1.0
		with: delta
		with: nil).
		
	self applyDamageMarkers 
]

{ #category : #physics }
TOMSpaceship >> requestTarget: aTarget [
	self commandProvider requestTarget: aTarget
]

{ #category : #inventory }
TOMSpaceship >> setActivateShield: aShield [
	activeShield := aShield
]

{ #category : #physics }
TOMSpaceship >> setVelocityBoost: boost [
	velocityBoost := boost
]

{ #category : #'initialize-release' }
TOMSpaceship >> setupDefaultSlots [
	self
		fillSlot: 1 with: (TOMWeapon new projectileClass: TOMSimpleLaser);
		fillSlot: 2 with: (TOMWeapon new projectileClass: TOMScatterLaser);
		fillSlot: 3 with: (TOMWeapon new projectileClass: TOMFlak);
		fillSlot: 4 with: (TOMWeapon new projectileClass: TOMSimpleMine)
]

{ #category : #'initialize-release' }
TOMSpaceship >> setupSpeedIndicators [
	speedIndicators := #(topLeft topRight) collect: [ :position |
		| indicator |
		indicator := (TOMSprite newWith: assetFactory)
			file: #'Effects/speed';
		 	yourself.
		self addChild: indicator fillMode: position padded: 0 @ (self extent y - 16).
		indicator ]
]

{ #category : #accessing }
TOMSpaceship >> shieldActive [
	^activeShield notNil
]

{ #category : #movement }
TOMSpaceship >> shootWeapon: dt with: commands [

	(commands includes: #shoot) ifTrue: [
		(slots at: activeInventorySlot) ifNotNilDo: [ :weapon | weapon activate: self ] ]
]

{ #category : #inventory }
TOMSpaceship >> slots [
	^ slots
]

{ #category : #store }
TOMSpaceship >> storeEnterProximityRadius [
	^50.0
]

{ #category : #physics }
TOMSpaceship >> turnSpeed: dt atSpeed: velocity [	
	^(self class baseTurnSpeed * dt * (1
		interpolateTo: self class swerveFactorAtMaxVelocity
		at: velocity / self class maxVelocity)) degreesToRadians
]

{ #category : #physics }
TOMSpaceship >> updateSpeedIndicators: dt [
	speedIndicators do: [ :indicator |
		indicator opacity: self velocity / self class maxVelocity ]
]

{ #category : #collision }
TOMSpaceship >> valueOfResources [
	^valueOfResources
]

{ #category : #collision }
TOMSpaceship >> valueOfResources: aValue [
	valueOfResources := aValue.
	
	self triggerEvent: #valueOfResourcesChanged with: aValue
]
