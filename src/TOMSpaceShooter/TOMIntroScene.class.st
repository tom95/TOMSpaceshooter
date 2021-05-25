"
A TOMIntroScene is the scene in which all players can join the game by activating the various ""shoot"" buttons on either controllers or keyboard. The corresponding TOMCommandProvider's are created right away and passed into TOMSpaceshipChooser's for the new player to select his or her ship.
"
Class {
	#name : #TOMIntroScene,
	#superclass : #TOMScene,
	#instVars : [
		'players',
		'background',
		'startGameButton'
	],
	#category : #TOMSpaceShooter
}

{ #category : #'ship-picking' }
TOMIntroScene class >> paintOptions [
	^#(blue green red orange turquoise pink purple) asOrderedCollection
]

{ #category : #'ship-picking' }
TOMIntroScene class >> pickPaintNotIn: aPaintArray [
	" picks from the defined paint options, avoiding options from the given array if possible "
	| options |
	options := self paintOptions copy.
	options removeAll: aPaintArray.
	options ifEmpty: [ options := self paintOptions ].
	
	^options atRandom
]

{ #category : #'ship-picking' }
TOMIntroScene class >> spaceshipOptions [
	^{TOMSpaceshipAlbatross. TOMSpaceshipEagle. TOMSpaceshipSwallow. TOMSpaceshipNightjar}
]

{ #category : #'player-spaceships' }
TOMIntroScene >> addPlayer: playerNumber inputType: inputType [
	| commandProvider chooser |
	
	inputType = #controller ifTrue: [
		commandProvider := (TOMSpaceshipControllerCommandProvider newWithIndex: playerNumber)
			inputHandler: self inputHandler;
			yourself ].
	
	inputType = #keyboard ifTrue: [
		commandProvider := TOMSpaceshipInputCommandProvider new
			playerNumber: playerNumber;
			inputHandler: self inputHandler;
			yourself ].
	
	chooser := (TOMSpaceshipChooser newWith: self assetFactory)
		spaceshipOptions: self class spaceshipOptions;
		zIndex: 2;
		paint: (self class
			pickPaintNotIn: (players asIdentitySet collect: [ :aChooser | aChooser paint ]));
		inputType: inputType playerNumber: playerNumber commandProvider: commandProvider;
		yourself.
	
	chooser when: #playerRemoved send: #handlePlayerRemoved: to: self.
	
	self addToOverlay: chooser.
		
	^chooser
]

{ #category : #representation }
TOMIntroScene >> backgroundColor [
	^TOMSpaceshooterGame backgroundColor
]

{ #category : #'initialize-release' }
TOMIntroScene >> cursor [
	^'UI/cursor'
]

{ #category : #representation }
TOMIntroScene >> fireButtonsMessage [
	| mapping |
	mapping := self inputHandler.
	
	^'Fire buttons on keyboard (change in options): ' , ({
		mapping translateCommandToKey: #shoot_1.
		mapping translateCommandToKey: #shoot_2.
		mapping translateCommandToKey: #shoot_3 } joinSeparatedBy: ', ')
]

{ #category : #callbacks }
TOMIntroScene >> handleControllerEvent: anEvent [
	" look for a released button "
	(anEvent active not and: [anEvent button = #a]) ifTrue: [
		self handlePlayerAction: anEvent controllerIndex inputType: #controller ].
	(anEvent active not and: [anEvent button = #start]) ifTrue: [
		self handleKeyboardCommand: #quickStartGame ]
]

{ #category : #callbacks }
TOMIntroScene >> handleKeyboardCommand: aCommand [
	aCommand = #shoot_1 ifTrue: [ self handlePlayerAction: 1 inputType: #keyboard ].
	aCommand = #shoot_2 ifTrue: [ self handlePlayerAction: 2 inputType: #keyboard ].
	aCommand = #shoot_3 ifTrue: [ self handlePlayerAction: 3 inputType: #keyboard ].
	aCommand = #quickStartGame ifTrue: [
		players ifEmpty: [ self handleKeyboardCommand: #shoot_1 ].
		self startGameScene ]
]

{ #category : #callbacks }
TOMIntroScene >> handlePlayerAction: playerNumber inputType: inputType [
	players ifEmpty: [
		self addToOverlay: startGameButton ].
	
	(players
		at: inputType asString , playerNumber
		ifAbsentPut: [ self addPlayer: playerNumber inputType: inputType ])
		cycleSpaceship.
	
	self repositionSpaceshipChoosers 
]

{ #category : #callbacks }
TOMIntroScene >> handlePlayerRemoved: aPlayerId [
	self removeFromOverlay: (players at: aPlayerId).
	players removeKey: aPlayerId.
	
	players ifEmpty: [ self removeFromOverlay: startGameButton ].
	
	self repositionSpaceshipChoosers
]

{ #category : #representation }
TOMIntroScene >> hudPadding [
	^48 * background scale
]

{ #category : #'player-spaceships' }
TOMIntroScene >> maxControllerNumber [
	^10
]

{ #category : #representation }
TOMIntroScene >> repositionSpaceshipChoosers [
	| width x |
	width := players inject: 0 into: [ :sum :chooser | sum + chooser extent x ].
	
	x := (self viewSize x / 2) - (width / 2).
	
	players do: [ :chooser |
		chooser position: x @ (background scale * 400).
		x := x + chooser extent x ]
]

{ #category : #'initialize-release' }
TOMIntroScene >> resume: anObject [
	super resume: anObject.
	
	self inputHandler
		when: #commandEvent send: #handleKeyboardCommand: to: self;
		when: #controllerEvent send: #handleControllerEvent: to: self
]

{ #category : #'initialize-release' }
TOMIntroScene >> start: anObject [
	super start: anObject.
	
	players := Dictionary new.
	
	background := (TOMUIElement newWith: self assetFactory)
		file: #'emptyScreen';
		fitInto: self viewRectangle fillMode: #fill;
		zIndex: -1;
		yourself.
	
	startGameButton := (TOMButton newWith: self assetFactory)
			text: 'Start Game!';
			fitInto: self viewRectangle fillMode: #bottom padded: self hudPadding * 2;
			onClickDo: [ self startGameScene ];
			yourself.
	
	self
		addToOverlay: background;
		
		addToOverlay: ((TOMLabel newWith: self assetFactory)
			blink: true;
			text: 'Press Fire on controller or keyboard to join and cycle spaceships!';
			fontSize: 64;
			fitInto: self viewRectangle fillMode: #top padded: 0 @ (320 * background scale);
			color: Color white;
			yourself);
		
		addToOverlay: ((TOMLabel newWith: self assetFactory)
			text: self fireButtonsMessage;
			fontSize: 64;
			fitInto: self viewRectangle fillMode: #bottom padded: 0 @ self hudPadding;
			color: Color white;
			yourself)
]

{ #category : #'initialize-release' }
TOMIntroScene >> startGameScene [
	self
		requestSceneSwitch: TOMGameScene
		rebuild: true
		argument: (players collect: [ :chooser |
			{ chooser commandProvider. chooser spaceshipType. chooser paint }] as: OrderedCollection)
]

{ #category : #'initialize-release' }
TOMIntroScene >> stop [
	super stop.
	
	self inputHandler removeActionsWithReceiver: self
]
