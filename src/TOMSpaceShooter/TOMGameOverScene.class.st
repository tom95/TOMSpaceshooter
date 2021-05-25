"
A TOMGameOverScene queries the configured highscore class for its values and displays them in a table-like layout, also informing the highscore of the new player's score and showing the player on what place he or she landed.
"
Class {
	#name : #TOMGameOverScene,
	#superclass : #TOMScene,
	#category : #TOMSpaceShooter
}

{ #category : #'initialize-release' }
TOMGameOverScene >> backgroundColor [
	^TOMSpaceshooterGame backgroundColor
]

{ #category : #'initialize-release' }
TOMGameOverScene >> cursor [
	^'UI/cursor'
]

{ #category : #'initialize-release' }
TOMGameOverScene >> displayHighscores: newScore [
	| container highscore playerScoreIndex |
	
	highscore := TOMSpaceshooterGame highscoreClass new.
	playerScoreIndex := newScore
		ifNotNil: [ highscore reportScore: newScore ]
		ifNil: [ -1 ].
		
	container := (TOMUIContainer newWith: self assetFactory)
		file: nil;
		yourself.
	
	highscore scores doWithIndex: [ :score :index |
		container appendChild: ((TOMLabel newWith: self assetFactory)
			fontSize: 64;
			maxWidth: 300;
			textPadding: 12 @ 0;
			zIndex: 3;
			file: (index = playerScoreIndex ifTrue: [#'UI/buttonBlue'] ifFalse: [nil]);
			color: (index = playerScoreIndex ifTrue: [Color black] ifFalse: [Color white]);
			text: index asString , '. ', score asString;
			yourself) on: #bottom].
	
	playerScoreIndex > 0 ifTrue: [
		container appendChild: ((TOMLabel newWith: self assetFactory)
				fontSize: 64;
				maxWidth: 300;
				textPadding: 12 @ 0;
				zIndex: 3;
				color: Color white;
				text: 'You''re in place ' , playerScoreIndex asString , '!';
				yourself) on: #bottom].
			
	self addToOverlay: (container fitInto: self viewRectangle fillMode: #center; yourself)
]

{ #category : #callbacks }
TOMGameOverScene >> handleKeyboardCommand: aCommand [
	aCommand = #quickStartGame ifTrue: [self requestSceneSwitch: TOMIntroScene rebuild: false argument: 1]
]

{ #category : #'initialize-release' }
TOMGameOverScene >> resume: anObject [
	super resume: anObject.
	
	self inputHandler when: #commandEvent send: #handleKeyboardCommand: to: self
]

{ #category : #'initialize-release' }
TOMGameOverScene >> start: newScore [
	super start: newScore.
	
	self addToOverlay: ((TOMLabel newWith: self assetFactory)
		file: #'gameOverScreen';
		fitInto: self viewRectangle fillMode: #fill;
		onClickDo: [self requestSceneSwitch: TOMIntroScene rebuild: false argument: nil];
		yourself).
		
	self addToOverlay: ((TOMLabel newWith: self assetFactory)
		blink: true;
		text: 'Press any key to continue!';
		fontSize: 64;
		fitInto: self viewRectangle fillMode: #bottom;
		color: Color white;
		yourself).
		
	self displayHighscores: newScore
]

{ #category : #'initialize-release' }
TOMGameOverScene >> stop [
	super stop.
	
	self inputHandler removeActionsWithReceiver: self
]
