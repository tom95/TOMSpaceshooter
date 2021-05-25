"
A TOMSpriteRenderer is the abstract superclass for rendering backends in the TOMGameEngine.
It is responsible for opening the game window and drawing (textured) rectangles and text.
"
Class {
	#name : #TOMSpriteRenderer,
	#superclass : #Object,
	#instVars : [
		'postRenderList',
		'cursor',
		'inputHandler'
	],
	#category : #TOMGameEngine
}

{ #category : #'render-text' }
TOMSpriteRenderer class >> calculateTextHeight: text forSize: fontSize [
	^self subclassResponsibility
]

{ #category : #'render-text' }
TOMSpriteRenderer class >> calculateTextWidth: text forSize: fontSize [
	^self subclassResponsibility
]

{ #category : #render }
TOMSpriteRenderer >> additiveBlending: aBoolean [
	^self subclassResponsibility
]

{ #category : #private }
TOMSpriteRenderer >> beginBatch: viewPosition centeredGeometry: centeredGeometry [
	^self subclassResponsibility
]

{ #category : #accessing }
TOMSpriteRenderer >> cursor [
	^cursor
]

{ #category : #accessing }
TOMSpriteRenderer >> cursor: aTexture [
	cursor := aTexture
]

{ #category : #presentation }
TOMSpriteRenderer >> delete [
	^self subclassResponsibility
]

{ #category : #private }
TOMSpriteRenderer >> endBatch [
	^self subclassResponsibility
]

{ #category : #render }
TOMSpriteRenderer >> frame: aBlock backgroundColor: aColor [
	self preDrawFrame: aColor.
	
	aBlock value.
	
	self postDrawFrame.
	self inputHandler processEvents
]

{ #category : #'initialize-release' }
TOMSpriteRenderer >> initialize [
	postRenderList := OrderedCollection new.
	inputHandler := TOMUserInputHandler new
]

{ #category : #accessing }
TOMSpriteRenderer >> inputHandler [
	^inputHandler
]

{ #category : #accessing }
TOMSpriteRenderer >> inputHandler: anInputHandler [
	inputHandler := anInputHandler
]

{ #category : #presentation }
TOMSpriteRenderer >> openInView: viewSize [
	^self subclassResponsibility
]

{ #category : #private }
TOMSpriteRenderer >> postDrawFrame [
	^self subclassResponsibility
]

{ #category : #private }
TOMSpriteRenderer >> preDrawFrame: aBackgroundColor [
	^self subclassResponsibility
]

{ #category : #render }
TOMSpriteRenderer >> preloadTextures: aTextureManager [
	" subclasses may preload textures here "
]

{ #category : #render }
TOMSpriteRenderer >> renderCursor [
	self cursor ifNotNil: [
		self withTransform: Matrix4x4 identity render: [
			self
				renderRectangle: self cursor
				transform: (TOMUtils translationMatrixForPoint: self inputHandler cursorPosition) transposed
				color: Color white
				scale: self cursor extent
				textureRegion: TOMRectangle unitSquare ]]
]

{ #category : #render }
TOMSpriteRenderer >> renderRectangle: aTexture transform: a4x4Matrix color: aColor scale: aPoint textureRegion: aRectangle [
	^self subclassResponsibility
]

{ #category : #render }
TOMSpriteRenderer >> renderSprite: aSprite [
	aSprite texture ifNotNil: [
		self
			renderRectangle: aSprite texture
			transform: aSprite worldTransform
			color: (Color white alpha: aSprite opacity)
			scale: aSprite extent
			textureRegion: aSprite texcoords ].
	
	aSprite hasPostRender ifTrue: [ postRenderList add: aSprite ]
]

{ #category : #render }
TOMSpriteRenderer >> renderText: aText at: aPosition size: aFontSize [
	self renderText: aText at: aPosition size: aFontSize color: Color white
]

{ #category : #render }
TOMSpriteRenderer >> renderText: aText at: aPosition size: aFontSize color: color [
	self renderText: aText at: aPosition size: aFontSize color: color maxWidth: -1
]

{ #category : #render }
TOMSpriteRenderer >> renderText: aText at: aPosition size: aFontSize color: aColor maxWidth: aWidth [
	" renders the given msg at the given position in the given size with the given color and constrains it to maxWidth, unless maxWidth is negative in that case it is understood to not be constrained "
	^self subclassResponsibility
]

{ #category : #render }
TOMSpriteRenderer >> withTransform: transform centeredGeometry: centeredGeometry render: aBlock [
	postRenderList removeAll.
	
	self beginBatch: transform centeredGeometry: centeredGeometry.
	aBlock value.
	self endBatch.
	
	" might mutate list, so copy "
	postRenderList copy do: [ :sprite | sprite postRender: self ]
]

{ #category : #render }
TOMSpriteRenderer >> withTransform: transform render: aBlock [
	self withTransform: transform centeredGeometry: false render: aBlock
]
