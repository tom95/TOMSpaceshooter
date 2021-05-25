"
A TOMSpaceshipChooser is the UI element that enables the player to choose their spaceships during the IntroScene.
"
Class {
	#name : #TOMSpaceshipChooser,
	#superclass : #TOMUIElement,
	#instVars : [
		'label',
		'spaceship',
		'statHealth',
		'statSpeed',
		'spaceshipOptions',
		'currentSpaceshipIndex',
		'paint',
		'commandProvider',
		'playerId'
	],
	#category : #TOMSpaceShooter
}

{ #category : #accessing }
TOMSpaceshipChooser >> commandProvider [
	^commandProvider
]

{ #category : #'adding-players' }
TOMSpaceshipChooser >> cycleSpaceship [
	| spaceshipClass |
	currentSpaceshipIndex := currentSpaceshipIndex \\ spaceshipOptions size + 1.
	spaceshipClass := self spaceshipType.
	
	statSpeed percentage: spaceshipClass maxVelocity / self maxReferenceVelocity.
	statHealth percentage: spaceshipClass maxLifePoints / self maxReferenceLifePoints.
	
	spaceship
		file: (spaceshipClass sprite: self paint);
		fitInto: (0 @ 0 extent: extent) fillMode: #top
		padded: 0 @ 48
]

{ #category : #'initialize-release' }
TOMSpaceshipChooser >> initialize [
	super initialize.
	
	currentSpaceshipIndex := 0.
	extent := 340 @ 300.
	
	label := (TOMLabel newWith: self assetFactory)	
		position: 0 @ 0;
		color: Color white;
		yourself.
	
	spaceship := (TOMUIElement newWith: self assetFactory).
	
	self addChild: ((TOMLabel newWith: self assetFactory)
	 color: Color white;
		position: 0 @ 132;
		text: 'Health:';
		yourself).
	
	statHealth := (TOMColoredProgressBar newWith: self assetFactory)
		position: 0 @ 164;
		zIndex: 2;
		yourself.
	
	self addChild: ((TOMLabel newWith: self assetFactory)
	 color: Color white;
		position: 0 @ 192;
		text: 'Speed:';
		yourself).
	
	statSpeed := (TOMColoredProgressBar newWith: self assetFactory)
		position: 0 @ 224;
		yourself.
		
	self addChild: ((TOMButton newWith: self assetFactory)
		text: 'Remove';
		uniformSize: false;
		fitInto: (0 @ 0 extent: extent) fillMode: #bottom padded: 0 @ 0;
		onClickDo: [ self triggerEvent: #playerRemoved with: playerId ];
		yourself).
	
	self
		addChild: label;
		addChild: statHealth;
		addChild: statSpeed;
		addChild: spaceship
]

{ #category : #'adding-players' }
TOMSpaceshipChooser >> inputType: anInputType playerNumber: aPlayerNumber commandProvider: aCommandProvider [
	commandProvider := aCommandProvider.
	playerId := anInputType asString, aPlayerNumber.
	self label: anInputType asString capitalized, ' ', aPlayerNumber
]

{ #category : #accessing }
TOMSpaceshipChooser >> label [
	^label text
]

{ #category : #accessing }
TOMSpaceshipChooser >> label: aString [
	label text: aString
]

{ #category : #'initialize-release' }
TOMSpaceshipChooser >> maxReferenceLifePoints [
	^spaceshipOptions inject: 0 into: [ :max :spaceship | spaceship maxLifePoints > max
			ifTrue: [ spaceship maxLifePoints ]
			ifFalse: [ max ]]
]

{ #category : #'initialize-release' }
TOMSpaceshipChooser >> maxReferenceVelocity [
	^spaceshipOptions inject: 0 into: [ :max :spaceship | spaceship maxVelocity > max
			ifTrue: [ spaceship maxVelocity ]
			ifFalse: [ max ]]
]

{ #category : #accessing }
TOMSpaceshipChooser >> paint [
	^paint
]

{ #category : #accessing }
TOMSpaceshipChooser >> paint: aPaint [
	paint := aPaint.
	
	statHealth colorCode: aPaint.
	statSpeed colorCode: aPaint
]

{ #category : #'adding-players' }
TOMSpaceshipChooser >> spaceshipOptions: listOfClasses [
	spaceshipOptions := listOfClasses
]

{ #category : #'adding-players' }
TOMSpaceshipChooser >> spaceshipType [
	^spaceshipOptions at: currentSpaceshipIndex
]

{ #category : #updating }
TOMSpaceshipChooser >> update: dt [
	super update: dt.
	
	statSpeed update: dt.
	statHealth update: dt
]
