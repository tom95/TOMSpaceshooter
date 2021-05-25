"
A TOMGame is an abstract base class for games based on the TOMGameEngine. It defines the entry point for the game and is responsible for managing high level aspects of the game, like scenes.

By overriding 'executeCommand:' a subclass may define commands that are handled on game window level, by default #escape is bound to quitting the game.
Subclasses may also override 'prefetchAssets', where they may send a list of textures needed for the game to the assetFactory.
The game loop may be started via the 'startScene:' method, which takes the class of the scene to be shown.

On class side, it provides the 'log:' method, which allows displaying up to 10 log messages on the game canvas.
"
Class {
	#name : #TOMGame,
	#superclass : #Object,
	#instVars : [
		'physicsManager',
		'activeScene',
		'isRunning',
		'spriteRenderer',
		'gamePaused',
		'inputHandler',
		'scenes',
		'assetFactory',
		'soundFactory'
	],
	#classVars : [
		'Benchmark',
		'Log'
	],
	#category : #TOMGameEngine
}

{ #category : #'feature-configuration' }
TOMGame class >> assetsBasePath [
	" to be override by your game class. the path is relative to the squeak Contents/Resources/ folder.
	  This folder is expected to have a 'sounds' and a 'sprites' subfolder for the respective asset types. "
	^''
]

{ #category : #log }
TOMGame class >> benchmark [
	^Benchmark ifNil: [ Benchmark := TOMGameBenchmark new ]
]

{ #category : #'feature-configuration' }
TOMGame class >> cacheTexturesInImage [
	^false
]

{ #category : #'feature-configuration' }
TOMGame class >> cacheTexturesInMemory [
	^true
]

{ #category : #log }
TOMGame class >> clearLog [
	Log ifNotNil:[ Log removeAll ]
]

{ #category : #'feature-configuration' }
TOMGame class >> collisionsEnabled [
	^true
]

{ #category : #'feature-configuration' }
TOMGame class >> debug [
	^true
]

{ #category : #log }
TOMGame class >> log: msg [
	" utility function that keeps a list of the 10 most recent logs "
	Log ifNil: [ Log := OrderedCollection new ].
	
	Log addFirst: msg printString.
	Log size > 10 ifTrue: [ Log removeLast ]
]

{ #category : #log }
TOMGame class >> logString [
	Log ifNil: [^''].
	
	^Log inject: '' into: [ :concat :message | concat , ' - ' , message ]
]

{ #category : #'feature-configuration' }
TOMGame class >> particlesEnabled [
	^true
]

{ #category : #private }
TOMGame class >> reloadBenchmark [
	Benchmark := nil
]

{ #category : #'feature-configuration' }
TOMGame class >> rendererClass [
	^TOMSpriteRendererCroquet
]

{ #category : #viewport }
TOMGame class >> scale [
		^Display extent y / self viewportHeight min: 1.0
]

{ #category : #'feature-configuration' }
TOMGame class >> soundSystemClass [
	" check for availability of the FMOD or OpenAL sound system, otherwise fall back to the default (dummy) system "
	^Smalltalk at: #TOMSoundFactoryFMOD
		ifAbsent: [ Smalltalk at: #TOMSoundFactoryOpenAL
			ifAbsent: [TOMSoundFactoryDummy]]
]

{ #category : #viewport }
TOMGame class >> viewSize [
	^ (Display extent / self scale) truncated
]

{ #category : #viewport }
TOMGame class >> viewportHeight [
	^1300.0
]

{ #category : #accessing }
TOMGame >> activeScene [
	^activeScene
]

{ #category : #accessing }
TOMGame >> activeScene: aScene [
	activeScene := aScene.
	
	self spriteRenderer cursor:
		(aScene cursor ifNotNil: [ (self assetFactory getTexture: aScene cursor)])
]

{ #category : #accessing }
TOMGame >> assetFactory [
	^assetFactory
]

{ #category : #private }
TOMGame >> buildScene: aSceneClass [
	^(aSceneClass
		newWith: self assetFactory
		spriteRenderer: self spriteRenderer
		inputHandler: self inputHandler
		soundFactory: self soundFactory)
		
		when: #enterScene
		send: #switchToSceneClass:rebuild:argument:
		to: self;
		
		yourself
]

{ #category : #'initialize-release' }
TOMGame >> delete [
	isRunning := false.
	
	scenes do: [ :scene | scene delete ]
]

{ #category : #'initialize-release' }
TOMGame >> executeCommand: aCommand [
	" whenever the input handler receives a command, this function will be called
	  with the command. you may choose to do nothing here and use the inputHandler
	  elsewhere to handle keyboard input. Handles predefined #quit command by
	  default "
	aCommand == #quit ifTrue: [ self delete ]
]

{ #category : #accessing }
TOMGame >> gamePaused [
	^gamePaused
]

{ #category : #accessing }
TOMGame >> gamePaused: aBoolean [
	" pauses the active scene, more specifically: stops sending updates to
	  all objects in its gameObjecs layer "
	gamePaused := aBoolean.
	physicsManager lastTimeFrame: Time millisecondClockValue
]

{ #category : #private }
TOMGame >> handleClick: event [
	event eventType = #up ifTrue: [ self activeScene handleClick: event position ]
]

{ #category : #'initialize-release' }
TOMGame >> initialize [ 
	super initialize.
	
	scenes := OrderedCollection new.
	gamePaused := false.
	isRunning := true.
	activeScene := nil.
	
	physicsManager := TOMPhysicsManager new.
	
	soundFactory := self class soundSystemClass new assetsBasePath: self class assetsBasePath, '/sounds'.
	spriteRenderer := self class rendererClass new.
	inputHandler := spriteRenderer inputHandler.
	
	assetFactory := (TOMAssetFactory newWithAssetsBasePath: self class assetsBasePath, '/sprites')
		cacheInImage: self class cacheTexturesInImage;
		cacheInMemory: self class cacheTexturesInMemory;
		yourself.
	
	self prefetchAssets.
	
	self inputHandler
		bindCommandMapping: #quit -> #escape;
		when: #commandEvent send: #executeCommand: to: self;
		when: #mouseEvent send: #handleClick: to: self
]

{ #category : #accessing }
TOMGame >> inputHandler [
	^inputHandler
]

{ #category : #'initialize-release' }
TOMGame >> prefetchAssets [ 
	" preload all assets that would otherwise cause blocking I/O while playing.
	  Override this in your subclass "
]

{ #category : #accessing }
TOMGame >> soundFactory [
	^soundFactory
]

{ #category : #accessing }
TOMGame >> spriteRenderer [
	^spriteRenderer
]

{ #category : #private }
TOMGame >> start [
	| exitBlock |
	exitBlock := [ :error |
		self soundFactory finalize.
		self spriteRenderer delete.
		error ifNotNil: [ error signal ]].
	
	[spriteRenderer openInView: self class viewSize.
		[isRunning] whileTrue: [ activeScene ifNotNilDo: [ :scene |
			physicsManager physicsStep: self activeScene paused: gamePaused.
			scene frame.
			self soundFactory update: physicsManager currentDeltaTime ]]]
		on: Error do: exitBlock on: Halt do: exitBlock.
		
	exitBlock value: nil
]

{ #category : #'initialize-release' }
TOMGame >> startScene: aSceneClass [
	self startScene: aSceneClass with: nil
]

{ #category : #'initialize-release' }
TOMGame >> startScene: aSceneClass with: anArgument [
	self switchToSceneClass: aSceneClass rebuild: false argument: anArgument.
	
	self start
]

{ #category : #private }
TOMGame >> switchToSceneClass: aSceneClass rebuild: rebuild argument: anObject [
	| scene |
	self activeScene ifNotNil: [ self activeScene stop ].
	scene := scenes detect: [ :otherScene | otherScene class == aSceneClass ] ifNone: [nil].
	
	(scene isNil or: [rebuild]) ifTrue: [
		scene ifNotNil: [ scenes remove: scene. scene release; delete ].
		
		scene := self buildScene: aSceneClass.
		scenes add: scene.
		scene start: anObject ].
	
	scene resume: anObject.
	self activeScene: scene
]
