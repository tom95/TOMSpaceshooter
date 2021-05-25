"
A TOMMenuBuilder is responsible for creating the various menus used inside the game.
"
Class {
	#name : #TOMMenuBuilder,
	#superclass : #Object,
	#instVars : [
		'owner',
		'inputHandler',
		'backToPauseButtons',
		'standardButtonPrototypes',
		'optionsButtonPrototypes'
	],
	#category : #TOMSpaceShooter
}

{ #category : #'menu creation' }
TOMMenuBuilder >> buildOptionsMenu [
	| menuContainer playerOptionContainers |
	
	menuContainer := (TOMUIContainer newWith: owner assetFactory).
	
	playerOptionContainers := self buildPlayerOptionContainers: optionsButtonPrototypes.
	playerOptionContainers do: [ :aUIContainer | menuContainer appendChild: aUIContainer on: #right].
	
	menuContainer appendChild: (standardButtonPrototypes at: #backToPauseMenu copy) on: #bottom.
	
	^ menuContainer
]

{ #category : #'menu creation' }
TOMMenuBuilder >> buildPauseMenu [
	| menuContainer |
	
	menuContainer := (TOMUIContainer newWith: owner assetFactory) zIndex: 0.
	menuContainer
		appendChild: (standardButtonPrototypes at: #resumeGame copy) on: #bottom;
		appendChild: (standardButtonPrototypes at: #newGame copy) on: #bottom;
		appendChild: (standardButtonPrototypes at: #options copy) on: #bottom;
		appendChild: (standardButtonPrototypes at: #highscores copy) on: #bottom;
		appendChild: (standardButtonPrototypes at: #exitGame copy) on: #bottom.
	
	^ menuContainer
]

{ #category : #'menu creation' }
TOMMenuBuilder >> buildPlayerOptionContainers: anOrderedDictionaryOfButtons [
	| playerOptionContainers labelContainers buttonContainers|
	
	playerOptionContainers := OrderedCollection new.
	labelContainers := OrderedCollection new.
	buttonContainers := OrderedCollection new.
	
	self numberOfPlayers timesRepeat: [
		playerOptionContainers add: (TOMUIContainer newWith: owner assetFactory).
		labelContainers add: (TOMUIContainer newWith: owner assetFactory).
		buttonContainers add: (TOMUIContainer newWith: owner assetFactory)].
	
	anOrderedDictionaryOfButtons keysAndValuesDo: [ :buttonCommand :buttonPrototype | 
		| playerNumber |
		" check if commmand is for a specific player, e.g. name is accelerate_3 "
		playerNumber := buttonCommand last.
		(playerNumber isDigit) ifTrue: [
			playerNumber := playerNumber asString asNumber.
			(buttonContainers at: playerNumber) appendChild: (buttonPrototype copy zIndex: 3) on: #bottom.
			(labelContainers at: playerNumber) appendChild: ((TOMLabel newWith: owner assetFactory)
				text: (buttonCommand copyFrom: 1 to: buttonCommand size - 2); " extract name except _3 suffix "
				color: Color white;
				yourself) on: #bottom ]].
	
	
	playerOptionContainers doWithIndex: [ :container :aNumber |
		container
			appendChild: (labelContainers at: aNumber) on: #right;
			appendChild: (buttonContainers at: aNumber) on: #right].
	
	^ playerOptionContainers
]

{ #category : #'initialize-release' }
TOMMenuBuilder >> createButtonNamed: aString doing: aBlock [
	^((TOMButton newWith: owner assetFactory)
		onClickDo: aBlock;
		text: aString;
		yourself)
]

{ #category : #'initialize-release' }
TOMMenuBuilder >> createButtonPrototypes [
	standardButtonPrototypes := Dictionary new.
	
	" builds the buttons. Make sure to have set `owner` first. "
	self assert: [ owner notNil ].
	
	standardButtonPrototypes
		add: #newGame -> (self createButtonNamed: 'New Game' doing: [owner newGame]);
		add: #resumeGame -> (self createButtonNamed: 'Resume Game' doing: [owner toggleMenu. owner gamePaused: false]);
		add: #exitGame -> (self createButtonNamed: 'Exit Game' doing: [owner delete]);
		add: #options -> (self createButtonNamed: 'Options' doing: [ owner switchToOptionsMenu]);
		add: #highscores -> (self createButtonNamed: 'Highscores' doing: [owner switchToHighscore]);
		add: #backToPauseMenu -> (self createButtonNamed: 'Back' doing: [owner switchToPauseMenu])
]

{ #category : #'initialize-release' }
TOMMenuBuilder >> createOptionButtonPrototypeFor: aCommand [
	| button keyForCommand |

	button := TOMInputOptionsButton newWith: self owner assetFactory.
	keyForCommand := self inputHandler translateCommandToKey: aCommand.
	
	button
		inputHandler: self inputHandler;
		refreshOnClickAction;
		subscribeToInputRebinds;
		key: keyForCommand;
		command: aCommand;
		text: keyForCommand asString;
		zIndex: 150.
		
	optionsButtonPrototypes add: aCommand -> button
]

{ #category : #'initialize-release' }
TOMMenuBuilder >> createOptionButtonPrototypes [
	optionsButtonPrototypes := OrderedDictionary new.
	
	self inputHandler commandMappings keysDo: [ :command | 
		self createOptionButtonPrototypeFor: command ]
]

{ #category : #accessing }
TOMMenuBuilder >> inputHandler [
	^inputHandler
]

{ #category : #accessing }
TOMMenuBuilder >> inputHandler: anInputHandler [
	inputHandler := anInputHandler.
]

{ #category : #accessing }
TOMMenuBuilder >> numberOfPlayers [ 
	^3
]

{ #category : #accessing }
TOMMenuBuilder >> owner [
	^owner
]

{ #category : #accessing }
TOMMenuBuilder >> owner: anObject [
	owner := anObject
]
