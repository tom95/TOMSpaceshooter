"
A TOMScene groups a number of TOMSprites that shall be shown on the screen while the scene is active.

A TOMScene consists of 3 layers:
	- game layer:
		The list of objects that receive the 'physicsStep:' message. Must be subclasses of TOMSprite
	- particles:
		All living particles are drawn on top of the gameObjects layer. New particles may be created via the scene's particleManager.
	- overlay layer:
		List of objects that receive the update: message. The layer is drawn ontop of the game layer. Must be subclasses of TOMUIElement.
		
The 'cursor' message can be overwritten in a subclass to set the image that shall be used as cursor while this scene is active. If it returns 'nil' the cursor is hidden.
The scene class provides three lifecycle callbacks:
	- 'start:':
		This callback is sent when the scene is made active for the first time or rebuilt. Any arguments provided to the scene switch request are given along to 'start:'.
	- 'resume:':
		This callback is sent whenever the scene is made active, including the first time. Arguments are the same as in 'start:'.
	- 'stop':
		This callback is sent whenever the scene is no longer the active one.
"
Class {
	#name : #TOMScene,
	#superclass : #Object,
	#instVars : [
		'overlayLayer',
		'spatialHash',
		'camera',
		'particleManager',
		'spriteRenderer',
		'delayedBlocks',
		'inputHandler',
		'gameLayer',
		'assetFactory',
		'soundFactory',
		'soundProxy'
	],
	#pools : [
		'EventSensorConstants'
	],
	#category : #TOMGameEngine
}

{ #category : #'instance creation' }
TOMScene class >> newWith: anAssetFactory spriteRenderer: aSpriteRenderer inputHandler: anInputHandler soundFactory: aSoundFactory [
	^self basicNew
		initializeWith: anAssetFactory
		spriteRenderer: aSpriteRenderer
		inputHandler: anInputHandler
		soundFactory: aSoundFactory;
		
		initialize;
		yourself
]

{ #category : #sprites }
TOMScene >> addToGame: aSprite [
	" prevent attempts to add duplicate items "
	TOMGame debug ifTrue: [ self assert: (gameLayer includes: aSprite) not ].
	
	self soundFactory activateSprite: aSprite.
	
	gameLayer add: (aSprite
		scene: self;
		yourself)
]

{ #category : #sprites }
TOMScene >> addToOverlay: anUIElement [
	" add an UIElement to the overlay layer. Needs to be a subclass of TOMUIElement "
	overlayLayer add: (anUIElement
		scene: self;
		yourself)
]

{ #category : #sound }
TOMScene >> ambientSound [
	^nil
]

{ #category : #sound }
TOMScene >> ambientSoundGain [
	^1.0
]

{ #category : #accessing }
TOMScene >> assetFactory [
	^assetFactory
]

{ #category : #accessing }
TOMScene >> backgroundColor [
	^Color black
]

{ #category : #render }
TOMScene >> buildSceneTreeList: anArrayOfSprites [
	| list |
	list := OrderedCollection new.
	
	anArrayOfSprites do: [ :sprite |
		sprite updateWorldTransform.
		(sprite texture notNil or: [sprite hasPostRender]) ifTrue: [ list add: sprite ].
		list addAll: (self buildSceneTreeList: sprite children) ].
	
	^list
]

{ #category : #accessing }
TOMScene >> camera [
	^camera
]

{ #category : #presentation }
TOMScene >> checkWasClicked: aPosition for: aList [
	aList do: [ :obj |
		(obj rectangle containsPoint: aPosition) ifTrue: [ obj clicked ].
		self checkWasClicked: aPosition for: obj children ]
]

{ #category : #render }
TOMScene >> compareByZIndexAndTexture: spriteA with: spriteB [
	" compares two sprites by zIndex and if those match by their texture hash, resulting in a
	  collection that is sorted by zIndex and then textures "
	^spriteA zIndex = spriteB zIndex
			ifTrue: [ spriteA texture hash <= spriteB texture hash ]
			ifFalse: [ spriteA zIndex <= spriteB zIndex ]
]

{ #category : #accessing }
TOMScene >> cursor [
	^nil
]

{ #category : #'initialize-release' }
TOMScene >> delete [
	self
		emptyOverlayLayer;
		emptyGameLayer
]

{ #category : #sprites }
TOMScene >> emptyGameLayer [
	self gameLayerDo: [ :sprite | sprite delete ]
]

{ #category : #sprites }
TOMScene >> emptyOverlayLayer [
	self overlayLayerDo: [ :uiElement | self removeFromOverlay: uiElement ]
]

{ #category : #stepping }
TOMScene >> executeDelayed: aBlock in: aDuration [
	delayedBlocks add: aBlock -> aDuration
]

{ #category : #presentation }
TOMScene >> frame [
	" a frame is being requested, render and update "
	self render.
	
	TOMGame benchmark
		activeObjects: gameLayer size;
		reportFrameEnd
]

{ #category : #sprites }
TOMScene >> gameLayerDo: aBlock [
	gameLayer copy do: aBlock
]

{ #category : #presentation }
TOMScene >> handleClick: aPosition [
	" check overlay layer whether there are objects in the clicked position. send the clicked message to them "
	| localPosition |
	
	localPosition := aPosition / TOMGame scale.
	
	self checkWasClicked: localPosition for: overlayLayer.
]

{ #category : #'initialize-release' }
TOMScene >> initializeWith: anAssetFactory spriteRenderer: aSpriteRenderer inputHandler: anInputHandler soundFactory: aSoundFactory [
	assetFactory := anAssetFactory.
	spriteRenderer := aSpriteRenderer.
	inputHandler := anInputHandler.
	soundFactory := aSoundFactory.
	
	spatialHash := TOMSpatialHashTable newWithCellSize: 256.
	particleManager := TOMParticleManager new.
	soundProxy := TOMSoundSourceEmpty new.
	
	delayedBlocks := OrderedCollection new.
	gameLayer := OrderedCollection new.
	overlayLayer := OrderedCollection new.
	
	camera := TOMCamera new
		viewSize: self viewSize;
		soundListener: self soundFactory createListener;
		yourself
]

{ #category : #render }
TOMScene >> inputHandler [
	^inputHandler
]

{ #category : #sprites }
TOMScene >> overlayLayerDo: aBlock [
	overlayLayer copy do: aBlock
]

{ #category : #accessing }
TOMScene >> particleManager [ 
	^particleManager 
]

{ #category : #sprites }
TOMScene >> removeFromGame: aSprite [
	aSprite scene: nil.
	self soundFactory deactivateSprite: aSprite.
	
	gameLayer remove: aSprite ifAbsent: []
]

{ #category : #sprites }
TOMScene >> removeFromOverlay: aSprite [
	aSprite scene: nil.
	overlayLayer remove: aSprite ifAbsent: []
]

{ #category : #render }
TOMScene >> render [
	spriteRenderer frame: [
		TOMGame benchmark report: #Drawing time: [
			self
				renderGameLayer;
				renderParticles;
				renderOverlay;
				renderDebug ] timeToRun ] backgroundColor: self backgroundColor
]

{ #category : #render }
TOMScene >> renderDebug [
	TOMGame debug ifFalse: [ ^self ].
	
	spriteRenderer renderText: TOMGame logString at: 0 @ 32 size: 22.
	TOMGame benchmark draw: self spriteRenderer in: self viewSize
]

{ #category : #render }
TOMScene >> renderGameLayer [
	self spriteRenderer
		withTransform: self camera transform
		render: [ self renderSprites: (self spatialHash allInArea: self camera viewport) ]
]

{ #category : #render }
TOMScene >> renderOverlay [
	self spriteRenderer
		withTransform: Matrix4x4 identity
		render: [ self renderSprites: overlayLayer ]
]

{ #category : #render }
TOMScene >> renderParticles [
	TOMGame benchmark report: #Particles time: [
		self particleManager render: self spriteRenderer camera: self camera ] timeToRun
]

{ #category : #render }
TOMScene >> renderSprites: anArrayOfSprites [
	| spriteList |
	
	spriteList := (self buildSceneTreeList: anArrayOfSprites) sort: [ :spriteA :spriteB |
		self compareByZIndexAndTexture: spriteA with: spriteB ].
	
	spriteList do: [ :sprite | self spriteRenderer renderSprite: sprite ]
]

{ #category : #presentation }
TOMScene >> requestSceneSwitch: aSceneClass rebuild: aBoolean argument: anObject [
	self triggerEvent: #enterScene withArguments: {aSceneClass. aBoolean. anObject}
]

{ #category : #presentation }
TOMScene >> resume: anObject [
	" the scene was resumed, it is now the active scene (Also emitted upon first start).
	  anObject is the argument that start: also (would have) received "
	
	self soundFactory activateScene: self
]

{ #category : #accessing }
TOMScene >> soundFactory [
	^soundFactory
]

{ #category : #accessing }
TOMScene >> soundProxy [
	^soundProxy
]

{ #category : #accessing }
TOMScene >> soundProxy: aSoundSource [
	soundProxy := aSoundSource
]

{ #category : #accessing }
TOMScene >> spatialHash [
	^spatialHash
]

{ #category : #accessing }
TOMScene >> spriteRenderer [
	^spriteRenderer
]

{ #category : #presentation }
TOMScene >> start: anObject [
	" scene was started. any arguments are provided here "
]

{ #category : #presentation }
TOMScene >> stop [
	" the scene was stopped, it is no longer the active scene "
	self soundFactory deactivateScene: self
]

{ #category : #stepping }
TOMScene >> updateDelayedActions: dt [
	| passedDuration |
	passedDuration := dt seconds.
	
	delayedBlocks copy do: [ :blockTimePair |
		blockTimePair value: blockTimePair value - passedDuration.
		blockTimePair value negative ifTrue: [
			blockTimePair key valueWithEnoughArguments: {self}.
			delayedBlocks remove: blockTimePair ]]
]

{ #category : #presentation }
TOMScene >> updateSpatialHash [
	self spatialHash rebuildIndex: gameLayer
]

{ #category : #presentation }
TOMScene >> viewRectangle [
	^0 asPoint extent: self viewSize
]

{ #category : #presentation }
TOMScene >> viewSize [
	^(Display extent / TOMGame scale) truncated
]
