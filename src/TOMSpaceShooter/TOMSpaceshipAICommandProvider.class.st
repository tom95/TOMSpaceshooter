"
A TOMSpaceshipAICommandProvider is the base class for AI command provider. It contains various utility functions that are useful for AIs of all kinds.

Instance Variables
	gameWorld:		<TOMGameWorld>
	spaceship:		<TOMSpaceship>

gameWorld
	- A reference to the gameWorld

spaceship
	- The spaceship that is controlled by the command provider
"
Class {
	#name : #TOMSpaceshipAICommandProvider,
	#superclass : #TOMSpaceshipCommandProvider,
	#traits : 'TOMAIActor',
	#classTraits : 'TOMAIActor classTrait',
	#instVars : [
		'activeStrategies',
		'aggressiveness',
		'target',
		'stateMachine',
		'stubbornness',
		'cowardice',
		'precision',
		'territory',
		'longRangeWeaponSlot',
		'shortRangeWeaponSlot'
	],
	#category : #TOMSpaceShooter
}

{ #category : #accessing }
TOMSpaceshipAICommandProvider >> activeCommands: dt [
	| commands |
	commands := super activeCommands: dt.
	
	stateMachine tick: dt.
	
	self activeStrategies do: [ :strategy |
		commands addAll: (strategy determineCommands: dt) ].
	
	^commands
]

{ #category : #accessing }
TOMSpaceshipAICommandProvider >> activeStrategies [
	^activeStrategies
]

{ #category : #trigger }
TOMSpaceshipAICommandProvider >> actor [
	^self spaceship
]

{ #category : #accessing }
TOMSpaceshipAICommandProvider >> aggressiveness [
	^aggressiveness
]

{ #category : #accessing }
TOMSpaceshipAICommandProvider >> aggressiveness: aPercentage [
	aggressiveness := aPercentage
]

{ #category : #alliances }
TOMSpaceshipAICommandProvider >> allyInformRadius [
	^8000
]

{ #category : #trigger }
TOMSpaceshipAICommandProvider >> checkLostTarget [
	^self target isNil or:
	[self target fraction isNil or:
	[(self spaceship position squaredDistanceTo: self target position) > self maxSquaredFollowDistance]]
]

{ #category : #trigger }
TOMSpaceshipAICommandProvider >> checkLowHealth [
	^self spaceship lifePercent < self cowardice
]

{ #category : #trigger }
TOMSpaceshipAICommandProvider >> checkNearbyEnemies [
	| targets |
	self aggressiveness > 0 ifTrue: [
		
		targets := (self spaceship scene spatialHash
			objectsAt: self spaceship position
			radius: self aggressiveness * self maxTargetDetectionRadius
			select: [ :object | TOMUtils isEnemy: object for: self spaceship ]) asOrderedCollection.
		
		self targetIfEnemy: (TOMUtils closestObject: targets to: self spaceship position).
		^self target notNil ].
	
	^false
]

{ #category : #accessing }
TOMSpaceshipAICommandProvider >> cowardice [
	^cowardice
]

{ #category : #accessing }
TOMSpaceshipAICommandProvider >> cowardice: aPercentage [
	cowardice := aPercentage
]

{ #category : #geometry }
TOMSpaceshipAICommandProvider >> debugPlotToTarget: aSpriteRenderer [
	| delta plotSteps color |
	
	plotSteps := 20.
	color := ({
		#idle -> Color green.
		#combat -> Color red.
		#evasion -> Color yellow.
	} as: Dictionary) at: stateMachine state.
	
	aSpriteRenderer withTransform: self spaceship scene camera transform centeredGeometry: true render: [
		aSpriteRenderer
			renderRectangle: nil
			transform: (TOMUtils translationMatrixForPoint: self spaceship center) transposed
			color: color
			scale: 32 asPoint
			textureRegion: TOMRectangle unitSquare.
		
		self target ifNotNilDo: [ :target |
			delta := target center - self spaceship center.
			
			1 to: plotSteps do: [ :index |
				aSpriteRenderer
					renderRectangle: nil
					transform: (TOMUtils translationMatrixForPoint: self spaceship center + (delta / plotSteps * index)) transposed
					color: Color green
					scale: 4 asPoint
					textureRegion: TOMRectangle unitSquare]]]
]

{ #category : #strategies }
TOMSpaceshipAICommandProvider >> getWayPointsInTerritory [
	| wayPoints |
	self territory ifNil: [^self].
	
	wayPoints := OrderedCollection new.
	
	100 timesRepeat: [
		wayPoints add: (TOMUtils randomFloatFrom: self territory left to: self territory right) @
			(TOMUtils randomFloatFrom: self territory top to: self territory bottom) ].
	
	^wayPoints
]

{ #category : #alliances }
TOMSpaceshipAICommandProvider >> informAllies [
	(self actor isNil or: [self actor alive not]) ifTrue: [^self].
	
	(self actor scene spatialHash
		objectsAt: self actor position
		radius: self allyInformRadius
		select: [ :sprite | sprite fraction = self actor fraction ]) do: [ :sprite |
			sprite requestTarget: self target ]
]

{ #category : #initialization }
TOMSpaceshipAICommandProvider >> initialize [ 
	super initialize.
	
	aggressiveness := 0.7.
	cowardice := 0.2.
	precision := 0.1.
	stubbornness := 0.4.
	
	longRangeWeaponSlot := 0.
	shortRangeWeaponSlot := 0.
	
	activeStrategies := OrderedCollection new.
	
	stateMachine := TOMStateMachine new
		initialState: #idle;
		
		from: #idle to: #combat if: [ self checkNearbyEnemies ];
		from: #idle to: #combat if: [ self target notNil ];
		from: #combat to: #evasion if: [ self checkLowHealth ];
		from: #combat to: #combat when: #newTarget;
		from: #combat to: #idle if: [ self checkLostTarget ];
		from: #evasion to: #idle after: 10 seconds;
		
		uponLeave: #combat do: [ :newState | newState ~= #combat ifTrue: [ self target: nil ]];
		
		uponEnter: #combat do: [ self useCombatStrategies; informAllies ];
		uponEnter: #idle do: [ self useIdleStrategies ];
		uponEnter: #evasion do: [ self useEvasionStrategies ];
		
		yourself
]

{ #category : #accessing }
TOMSpaceshipAICommandProvider >> longRangeWeaponSlot [
	^longRangeWeaponSlot
]

{ #category : #accessing }
TOMSpaceshipAICommandProvider >> longRangeWeaponSlot: anIndex [
	longRangeWeaponSlot := anIndex
]

{ #category : #trigger }
TOMSpaceshipAICommandProvider >> maxSquaredFollowDistance [
	^8000 squared * (self aggressiveness max: 0.3)
]

{ #category : #trigger }
TOMSpaceshipAICommandProvider >> maxTargetDetectionRadius [
	^2000
]

{ #category : #accessing }
TOMSpaceshipAICommandProvider >> precision [
	^precision
]

{ #category : #accessing }
TOMSpaceshipAICommandProvider >> precision: aPercentage [
	precision := aPercentage
]

{ #category : #trigger }
TOMSpaceshipAICommandProvider >> requestTarget: aTarget [
	stateMachine state ~= #combat ifTrue: [ self target: aTarget ]
]

{ #category : #accessing }
TOMSpaceshipAICommandProvider >> shortRangeWeaponSlot [
	^shortRangeWeaponSlot
]

{ #category : #accessing }
TOMSpaceshipAICommandProvider >> shortRangeWeaponSlot: anIndex [
	shortRangeWeaponSlot := anIndex
]

{ #category : #accessing }
TOMSpaceshipAICommandProvider >> spaceship: aSpaceship [
	super spaceship: (aSpaceship
		when: #attacked send: #targetIfEnemy: to: self;
		yourself).
	
	self useIdleStrategies
]

{ #category : #accessing }
TOMSpaceshipAICommandProvider >> stubbornness [
	^stubbornness
]

{ #category : #accessing }
TOMSpaceshipAICommandProvider >> stubbornness: aNumber [
	stubbornness := aNumber
]

{ #category : #accessing }
TOMSpaceshipAICommandProvider >> target [
	^target
]

{ #category : #accessing }
TOMSpaceshipAICommandProvider >> target: aTarget [
	target := aTarget.
	
	target ifNotNil: [
		target when: #destroyed send: #target: to: self with: nil ]
]

{ #category : #trigger }
TOMSpaceshipAICommandProvider >> targetIfEnemy: aSprite [
	stateMachine state = #evasion ifTrue: [^self].
	
	(TOMUtils isEnemy: aSprite for: self spaceship ignoreAlliances: true) ifTrue: [
		self target
			ifNil: [ self target: aSprite ]
			ifNotNil: [
				" if we are already in combat mode, update our strategie's targets if wanted "
				(stateMachine state = #combat and:
					[self target ~~ aSprite and:
					[self targetMoreAttractive: aSprite]]) ifTrue: [
						self target: aSprite.
						stateMachine trigger: #newTarget ]]]
]

{ #category : #trigger }
TOMSpaceshipAICommandProvider >> targetMoreAttractive: aSprite [
	| distanceToNew distanceToOld |
	distanceToNew := self spaceship position squaredDistanceTo: aSprite position.
	distanceToOld := self spaceship position squaredDistanceTo: self target position.
	
	" check if our stubbornness permits changing to a new, closer target "
	^1 - (distanceToNew / distanceToOld min: 1) > self stubbornness
]

{ #category : #accessing }
TOMSpaceshipAICommandProvider >> territory [
	^territory
]

{ #category : #accessing }
TOMSpaceshipAICommandProvider >> territory: aRectangle [
	territory := aRectangle
]

{ #category : #strategies }
TOMSpaceshipAICommandProvider >> useCombatStrategies [
	activeStrategies := {TOMAIStrategyTrack. TOMAIStrategyShoot} collect: [ :strategyClass |
		(strategyClass newForCommandProvider: self) target: self target ]
]

{ #category : #strategies }
TOMSpaceshipAICommandProvider >> useEvasionStrategies [
	activeStrategies :={{TOMAIStrategySTurnEvasion. TOMAIStrategyRandomEvasion} atRandom. TOMAIStrategyClearPath}
		collect: [ :strategyClass | strategyClass newForCommandProvider: self ]
]

{ #category : #strategies }
TOMSpaceshipAICommandProvider >> useIdleStrategies [
	activeStrategies := {
		self territory
			ifNotNil: [ (TOMAIStrategyWayPoints newForCommandProvider: self) wayPoints: self getWayPointsInTerritory ]
			ifNil: [ TOMAIStrategyIdle newForCommandProvider: self ]}
]
