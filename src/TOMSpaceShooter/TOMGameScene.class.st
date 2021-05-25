"
A TOMGameScene is the central component of the core game. It creates and holds all the player sprites and the map, as well as the in-game HUD. It reacts to player's getting damage by shaking the camera or updating it when players die.

If any game object needs to reward the player for an action it sends reportScore: to the scene, which also keeps track of all scored values to later pass them on to the TOMGameOverScene.

It also contains a set of predefined maps for testing purposes.
"
Class {
	#name : #TOMGameScene,
	#superclass : #TOMScene,
	#instVars : [
		'map',
		'player',
		'background',
		'pointCounter',
		'players'
	],
	#category : #TOMSpaceShooter
}

{ #category : #scores }
TOMGameScene class >> scoreValues [
	^{
		#spaceshipKilled -> 1000
	} as: Dictionary
]

{ #category : #accessing }
TOMGameScene >> addPersistentGameObject: aSprite [
	" add an object to the game world that does not expire by itself and should therefore be collected within a maptile "
	(self map tileAtGlobalPoint: aSprite position createIfAbsent: true)
		moveObjectToTileLocalSpace: aSprite;
		takeObject: aSprite
]

{ #category : #sound }
TOMGameScene >> ambientSound [
	^nil "#soundtrackCinematicSoundscapes"
]

{ #category : #sound }
TOMGameScene >> ambientSoundGain [
	^0.7
]

{ #category : #accessing }
TOMGameScene >> backgroundColor [
	^TOMSpaceshooterGame backgroundColor
]

{ #category : #'initialize-release' }
TOMGameScene >> createPlayer: commandProviderAndTypeAndColor playerNumber: playerNumber [
	| aPlayer |
	
	aPlayer := (commandProviderAndTypeAndColor second
		newWith: self assetFactory
		paint: commandProviderAndTypeAndColor third)
		commandProvider: commandProviderAndTypeAndColor first;
		yourself.
	
	self
		createPlayerHUDFor: aPlayer number: playerNumber;
		addToGame: aPlayer.
	
	aPlayer
		when: #healthChanged
		send: #handlePlayerHealthChanged:delta:attacker:
		to: self;
		
		when: #destroyed
		send: #handlePlayerKilled:
		to: self
		with: aPlayer.
		
	^aPlayer
]

{ #category : #'initialize-release' }
TOMGameScene >> createPlayerHUDFor: aPlayer number: playerNumber [
	| lifeIcon x playerPadding resourceCounter coinIcon healthBar |
	
	playerPadding := self hudPadding asPoint + (0 @ (self hudHealthbarSpacing * (playerNumber - 1))).
	
	" little icon in the lower right to give hint to meaning of health bar "
	lifeIcon := (TOMUIElement newWith: self assetFactory)
		file: #'UI/',aPlayer class spaceshipType asString ,'Life_', aPlayer paint asString;
		fitInto: self viewRectangle fillMode: #bottomLeft padded: playerPadding;
		yourself.
	
	x := self hudPadding + lifeIcon extent x.
	
	healthBar := (TOMHealthBar newWith: self assetFactory)
		colorCode: aPlayer paint asString;
		fitInto: self viewRectangle fillMode: #bottomLeft padded: x @ 0 + playerPadding;
		yourself.
	
	x := x + self hudPadding + healthBar extent x.
	
	resourceCounter := TOMCounter newWith: self assetFactory.
	coinIcon := (TOMUIElement newWith: self assetFactory)
			file: #'Power-ups/coinGold';
			extent: resourceCounter extent y asPoint;
			fitInto: self viewRectangle fillMode: #bottomLeft padded: x @ 0 + playerPadding;
			yourself.
			
	x := x + (self hudPadding / 2) + coinIcon extent x.
	
	resourceCounter
		fitInto: self viewRectangle fillMode: #bottomLeft padded: x @ 0 + playerPadding.
	
	aPlayer
		when: #valueOfResourcesChanged
		send: #number:
		to: resourceCounter.
	
	self
		addToOverlay: coinIcon;
		addToOverlay: resourceCounter;
		addToOverlay: healthBar;
		addToOverlay: lifeIcon.
		
	aPlayer
		when: #healthChanged
		send: #handleHealthChanged:delta:attacker:
		to: healthBar
]

{ #category : #'initialize-release' }
TOMGameScene >> delete [
	super delete.
	
	map delete
]

{ #category : #presentation }
TOMGameScene >> frame [
	map update.
	super frame
]

{ #category : #callbacks }
TOMGameScene >> handlePlayerHealthChanged: health delta: delta attacker: attacker [
	delta < 0 ifTrue: [
		self camera shake: delta negated ]
]

{ #category : #callbacks }
TOMGameScene >> handlePlayerKilled: aPlayer [
	" make the transition of the camera to the surviving players smooth "
	self camera smoothPosition: true.
	self executeDelayed: [ :scene | scene camera smoothPosition: false ] in: 2 seconds.
	
	self players remove: aPlayer ifAbsent: [].
	
	self players ifEmpty: [
		" to make sure our map stays where it should, we spawn an empty object at the old player's
		  position to compensate for his loss "
		self map objectOfInterest:
			((TOMSprite newWith: self assetFactory) position: aPlayer position).
		
		self executeDelayed: [:scene |
			scene
				requestSceneSwitch: TOMGameOverScene
				rebuild: true
				argument: pointCounter number] in: 1.5 seconds ]
]

{ #category : #'initialize-release' }
TOMGameScene >> hudHealthbarSpacing [
	^48
]

{ #category : #'initialize-release' }
TOMGameScene >> hudPadding [
	^24
]

{ #category : #accessing }
TOMGameScene >> map [
	^map
]

{ #category : #maps }
TOMGameScene >> mapAiBattle [
	self map
		predefineTileAt: 0 @ 0 type: TOMMapTileAIBattle;
		predefineTileAt: 1 @ 0 type: TOMMapTileAIBattle.
	
	self
		mapHelperMovePlayersAway;
		mapHelperFocus: TOMMapTile extent x @ (TOMMapTile extent y / 2) zoom: 2
]

{ #category : #maps }
TOMGameScene >> mapAllTiles [
	| index |
	index := 0.
	
	TOMMapTile allSubclassesDo: [ :class |
		self map predefineTileAt: index @ 0 type: class.
		index := index + 1 ]
]

{ #category : #maps }
TOMGameScene >> mapArena: enemyShipClass [
	| playerPositionY |
	
	" place players in a column, poiting to the right "
	playerPositionY := (TOMMapTile extent y / 2) - (players size * 100 / 2).
	
	players do: [ :player |
		player
			position: 100 @ playerPositionY;
			angle: Float halfPi negated.
		playerPositionY := playerPositionY - 100 ].
	
	" place enemy ship opposing to the players "
	self addToGame: ((enemyShipClass newWith: self assetFactory fraction: #enemy1)
		fitInto: (0 asPoint extent: TOMMapTile extent) fillMode: #right padded: 200 @ 0;
		angle: Float halfPi;
		commandProvider: TOMSpaceshipAICommandProvider new;
		yourself).
	
	self addToGame: ((TOMSpaceshipRoach newWith: self assetFactory fraction: #enemy1)
		fitInto: TOMMapTile rectangle fillMode: #right padded: 400 @ 0;
		yourself).
	
	" surrond ourselves with some meteor fields "
	-1 to: 1 do: [ :x |
		-1 to: 1 do: [ :y |
			self map predefineTileAt: x @ y type: ((x = 0 and: [y = 0])
				ifTrue: [ TOMMapTileEmpty ]
				ifFalse: [ TOMMapTileMeteorField ]) ]]
]

{ #category : #maps }
TOMGameScene >> mapDefault [
	map predefineTileAt: 0 asPoint type: TOMMapTileEmpty.
	
	players doWithIndex: [ :player :index |
		player position: (200 * index) @ 200 ]
]

{ #category : #maps }
TOMGameScene >> mapEnemyStation [
	self map
		predefineTileAt: 1 @ 0 type: TOMMapTileEnemyStation;
		predefineTileAt: 0 @ 0 type: TOMMapTileEnemyFleet.
	
	self
		mapHelperMovePlayersAway;
		mapHelperFocus: TOMMapTile extent x @ (TOMMapTile extent y / 2) zoom: 1.7
]

{ #category : #maps }
TOMGameScene >> mapHelperFocus: aPoint zoom: aNumber [
	self map objectOfInterest:
		((TOMSprite newWith: self assetFactory) position: TOMMapTile extent).
	
	self camera
		follow: nil;
		position: aPoint;
		zoom: aNumber
]

{ #category : #maps }
TOMGameScene >> mapHelperMovePlayersAway [
	" helper for test maps that makes sure the players don't get in the way "
	
	map predefineTileAt: 100 asPoint type: TOMMapTileEmpty.
	
	self players do: [ :player | player position: TOMMapTile extent * 100.5 ].
]

{ #category : #accessing }
TOMGameScene >> player [
	^player
]

{ #category : #accessing }
TOMGameScene >> players [
	^players
]

{ #category : #callbacks }
TOMGameScene >> reportScore: scoreType [
	pointCounter increment: (self class scoreValues at: scoreType)
]

{ #category : #'initialize-release' }
TOMGameScene >> setupHUD [
	| minimap |
	
	pointCounter := (TOMCounter newWith: self assetFactory)
		fitInto: self viewRectangle fillMode: #topLeft padded: self hudPadding asPoint + (self hudPadding @ 0);
		yourself.
	
	minimap := (TOMMiniMap newWith: self assetFactory)
		fitInto: self viewRectangle fillMode: #bottomRight padded: self hudPadding asPoint;
		yourself.
	
	self
		addToOverlay: minimap;
		addToOverlay: ((TOMUIElement newWith: self assetFactory)
			file: #'Power-ups/star_gold';
			extent: pointCounter extent y asPoint;
			fitInto: self viewRectangle fillMode: #topLeft padded: self hudPadding asPoint;
			yourself);	
		addToOverlay: pointCounter
]

{ #category : #'initialize-release' }
TOMGameScene >> setupInventoryDisplay: player [
	| item y |
	y := self hudPadding * 5.
	
	player slots do: [ :slot |
		item := (TOMSlotDisplay newWith: self assetFactory)
			slot: slot;
			position: self hudPadding @ y;
			yourself.
		y := y + item extent y + self hudPadding.
		self addToOverlay: item ]
]

{ #category : #'initialize-release' }
TOMGameScene >> start: commandProviderAndTypeAndColorArray [
	super start: commandProviderAndTypeAndColorArray.
	
	players := (commandProviderAndTypeAndColorArray collectWithIndex: [ :commandProviderAndTypeAndColor :playerNumber |
		self createPlayer: commandProviderAndTypeAndColor playerNumber: playerNumber ]) asOrderedCollection.
	
	" we need a single player object in some places, so just take the first "
	player := players first.
	
	self
		setupInventoryDisplay: player;
		setupHUD.
	
	self camera
		baseZoomLevel: 0.4;
		follow: players.
	
	map := TOMMap new
		scene: self;
		objectsOfInterest: players;
		yourself.
		
	self
		addToGame: (TOMBackgroundImage newWith: self assetFactory);
		mapDefault
]
