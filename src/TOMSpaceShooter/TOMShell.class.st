"
A TOMShell is a concrete projectile.

The ""container weapon"" that spawns 10+ ScatterRockets after one second of life and then despawns.
By itself it does nearly no damage and payload will not be spawned upon collision - only upon ""natural"" death after one second of lifetime.
"
Class {
	#name : #TOMShell,
	#superclass : #TOMProjectile,
	#category : #TOMSpaceShooter
}

{ #category : #'game-attributes' }
TOMShell class >> baseCooldown [
	^1
]

{ #category : #'game-attributes' }
TOMShell class >> baseDamage [ 
	^10
]

{ #category : #'game-attributes' }
TOMShell class >> baseDecayTime [ 
	^0.5
]

{ #category : #'game-attributes' }
TOMShell class >> baseVelocity [ 
	^100
]

{ #category : #'game-attributes' }
TOMShell class >> hasUpgradableCooldown [ 
	^false
]

{ #category : #'game-attributes' }
TOMShell class >> scale [
	^0.75
]

{ #category : #'game-attributes' }
TOMShell class >> sprite [
	^'Lasers/rocketRed01'
]

{ #category : #inventory }
TOMShell class >> title [
	^'Shell'
]

{ #category : #'initialize-release' }
TOMShell >> die [
	TOMUtils
		spawn: 8
		sparksAt: self position
		angle: self angle
		color: (Color r: 0.7 g: 0.4 b: 0.4 alpha: 0.7)
		in: self scene.
	
	self 
		spawnPayload: self payloadSize;
		delete
]

{ #category : #physics }
TOMShell >> payloadSize [
	upgradeInfo
		ifNotNil: [ ^self class baseDamage * upgradeInfo damage ]
		ifNil: [^self class baseDamage  ]
]

{ #category : #physics }
TOMShell >> spawnPayload: aFactor [
	| payload |
	
	payload := (aFactor / 2) truncated.
	self scene ifNil: [ ^self ].
			
	payload timesRepeat: [
		self scene addToGame:
			((TOMScatterRocket newWith: self assetFactory)
				upgradeInfo: self upgradeInfo;
				launchHere: self center
				inDirection: self angle
				withVelocity: self velocity
				owner: self owner;
				yourself)]
]
