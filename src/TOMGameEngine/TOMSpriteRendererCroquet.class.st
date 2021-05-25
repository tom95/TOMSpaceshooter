"
A TOMSpriteRendererCroquet is an implementation of a TOMSpriteRenderer using CroquetGL.
"
Class {
	#name : #TOMSpriteRendererCroquet,
	#superclass : #TOMSpriteRenderer,
	#instVars : [
		'currentColor',
		'currentTexture',
		'textures',
		'spriteVerticesTopLeftOrigin',
		'spriteVerticesCenterOrigin',
		'spriteVertices',
		'font',
		'library'
	],
	#classVars : [
		'Font'
	],
	#pools : [
		'GLConstants'
	],
	#category : #TOMGameEngine
}

{ #category : #'render-text' }
TOMSpriteRendererCroquet class >> calculateTextHeight: text forSize: aNumber [
	^(self getFont: aNumber) height
]

{ #category : #'render-text' }
TOMSpriteRendererCroquet class >> calculateTextWidth: text forSize: fontSize [
	^((self getFont: fontSize) widthOfString: text) / TOMGame scale
]

{ #category : #'render-text' }
TOMSpriteRendererCroquet class >> getFont: fontSize [
	^StrikeFont familyName: #Atlanta pointSize: (fontSize * TOMGame scale) truncated
]

{ #category : #render }
TOMSpriteRendererCroquet >> additiveBlending: aBoolean [
	aBoolean
		ifTrue: [ GL blendFunc: GL_SRC_ALPHA with: GL_ONE ]
		ifFalse: [ GL blendFunc: GL_SRC_ALPHA with: GL_ONE_MINUS_SRC_ALPHA ]
]

{ #category : #private }
TOMSpriteRendererCroquet >> beginBatch: viewTransform centeredGeometry: centeredGeometry [
	spriteVertices := centeredGeometry
		ifTrue: [ spriteVerticesCenterOrigin ]
		ifFalse: [ spriteVerticesTopLeftOrigin ].
	
	GL
		enable: GL_TEXTURE_2D;
		pushMatrix;
		multMatrixf: viewTransform transposed
]

{ #category : #presentation }
TOMSpriteRendererCroquet >> delete [
	Cursor currentCursor: Cursor normal.
	library ifNotNil: [ library context destroy ]
]

{ #category : #private }
TOMSpriteRendererCroquet >> endBatch [
	currentTexture := nil.
	currentColor := nil.
	
	GL
		popMatrix;
		disable: GL_TEXTURE_2D;
		color3f: 1.0 with: 1.0 with: 1.0
]

{ #category : #presentation }
TOMSpriteRendererCroquet >> frame: aBlock backgroundColor: aColor [

	library withErrorChecking makeCurrentDuring: [
		super frame: aBlock backgroundColor: aColor]
]

{ #category : #private }
TOMSpriteRendererCroquet >> getOGLTexture: texture [
	texture ifNil: [ ^nil ].
	
	^ textures at: texture ifAbsent: [
		| oglTexture |
		oglTexture := GLTexture2D create.
		oglTexture boundDuring: [
			oglTexture
				image: texture form;
				wrapS: GL CLAMP;
				wrapT: GL CLAMP;
				minificationFilter: GL LINEAR;
				magnificationFilter: GL LINEAR].
		textures at: texture put: oglTexture]
]

{ #category : #private }
TOMSpriteRendererCroquet >> getSpriteTexCoords: texcoords [
	^(FloatArray new: 8)
		at: 1 put: (texcoords topLeft x);
		at: 2 put: (texcoords topLeft y);
		at: 3 put: (texcoords bottomRight x);
		at: 4 put: (texcoords topLeft y);
		at: 5 put: (texcoords topLeft x);
		at: 6 put: (texcoords bottomRight y);
		at: 7 put: (texcoords bottomRight x);
		at: 8 put: (texcoords bottomRight y);
		yourself
]

{ #category : #private }
TOMSpriteRendererCroquet >> getTextLines: text font: font width: width [
	| currentSubstring currentWidth lines |
	
	lines := OrderedCollection new.
	currentSubstring := ''.
	currentWidth := 0.
	
	(text subStrings: ' ') do: [ :word |
		currentWidth := currentWidth + (font widthOfString: word).
		
		currentWidth > width
			ifTrue: [
				currentWidth := font widthOfString: word.
				lines add: currentSubstring.
				currentSubstring := word , ' ' ]
			ifFalse: [ currentSubstring := currentSubstring , word , ' ' ]].
	
	currentSubstring notEmpty ifTrue: [ lines add: currentSubstring ].
	
	^lines
]

{ #category : #'initialize-release' }
TOMSpriteRendererCroquet >> initialize [
	super initialize.
	
	textures := IdentityDictionary new.
	
	spriteVerticesTopLeftOrigin := #(0 0  1 0  0 1  1 1) as: FloatArray.
	spriteVerticesCenterOrigin := #(-0.5 -0.5  0.5 -0.5  -0.5 0.5  0.5 0.5) as: FloatArray
]

{ #category : #presentation }
TOMSpriteRendererCroquet >> openInView: viewSize [
	| window |
	window := GLFWWindow extent: (viewSize * TOMGame scale) truncated title: 'Totally Obsolete Mission'.
	window ifNil: [^ self error: 'GLFW Error'].
	library := GLExternalLibrary context: window context.
	
	Cursor currentCursor: Cursor blank.
	
	library withErrorChecking makeCurrentDuring: [
		GL
			disable: GL_DEPTH_TEST;
			disable: GL_LIGHTING;
			enable: GL_BLEND;
			blendFunc: GL_SRC_ALPHA with: GL_ONE_MINUS_SRC_ALPHA.
		
		" setup projection to display full screen "
		GL
			matrixMode: GL_PROJECTION;
			loadIdentity;
			translated: -1 with: 1 with: 0;
			scaled: (2.0 / viewSize x) with: (-2.0 / viewSize y) with: 1.0;
			matrixMode: GL_MODELVIEW]
]

{ #category : #private }
TOMSpriteRendererCroquet >> postDrawFrame [
	
	self renderCursor.
	
	GL
		disableClientState: GL_TEXTURE_COORD_ARRAY;
		disableClientState: GL_VERTEX_ARRAY.
	
	GL context endFrame.
	GL context swapBuffers
]

{ #category : #private }
TOMSpriteRendererCroquet >> preDrawFrame: aColor [
	GL
		clearColor: aColor red with: aColor green with: aColor blue with: aColor alpha;
		clear: GL_COLOR_BUFFER_BIT;
	
		enableClientState: GL_VERTEX_ARRAY;
		enableClientState: GL_TEXTURE_COORD_ARRAY
]

{ #category : #render }
TOMSpriteRendererCroquet >> preloadTextures: aTextureManager [
	GL enable: GL_TEXTURE_2D.
	aTextureManager texturesDo: [ :texture | self getOGLTexture: texture ].
	GL disable: GL_TEXTURE_2D.
]

{ #category : #render }
TOMSpriteRendererCroquet >> renderRectangle: aTexture transform: a4x4Matrix color: aColor scale: aPoint textureRegion: aRectangle [
	| oglTexture |
	oglTexture := self getOGLTexture: aTexture.
	
	(currentTexture ~~ oglTexture and: [oglTexture notNil]) ifTrue: [
		currentTexture := oglTexture.
		oglTexture bind ].
	
	currentColor ~= aColor ifTrue: [
		currentColor := aColor.
		GL
			color4f: aColor red
			with: aColor green
			with: aColor blue
			with: aColor alpha ].
	
	GL
		pushMatrix;
		multMatrixf: a4x4Matrix.
	
	aTexture
		ifNil: [ GL disable: GL_TEXTURE_2D ]
		ifNotNil: [
			GL
				texCoordPointer: 2
				with: GL_FLOAT
				with: 0
				with: (self getSpriteTexCoords: aRectangle) ].
	
	GL
		vertexPointer: 2 with: GL_FLOAT with: 0 with: spriteVertices;
	
		scaled: aPoint x with: aPoint y with: 0;
		drawArrays: GL_TRIANGLE_STRIP with: 0 with: spriteVertices size // 2.
	
	aTexture ifNil: [ GL enable: GL_TEXTURE_2D ].
		
	GL popMatrix
]

{ #category : #render }
TOMSpriteRendererCroquet >> renderText: aText at: aPosition size: aFontSize color: aColor maxWidth: aMaxWidth [
	| font |
	font := self class getFont: aFontSize.

	GL
		color4f: aColor red
		with: aColor green
		with: aColor blue
		with: aColor alpha.
	
	aMaxWidth <= 0
		ifTrue: [
			"ogl drawString: aText at: aPosition @ 0 font: font color: Color white" ]
		ifFalse: [
			| currentPosition |
			currentPosition := aPosition.
			(self getTextLines: aText font: font width: aMaxWidth) do: [ :line |
				"ogl drawString: line at: currentPosition @ 0 font: font color: Color white."
				currentPosition := currentPosition x @ (currentPosition y + font height) ]].
	
	GL
		color4f: 1.0 with: 1.0 with: 1.0 with: 1.0
]
