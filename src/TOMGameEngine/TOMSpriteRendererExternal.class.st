"
A TOMSpriteRendererExternal is an implemenation of TOMSpriteRenderer based on CroquetGL, but using an external library to have access to newer OpenGL symbols than CroquetGL provides.
"
Class {
	#name : #TOMSpriteRendererExternal,
	#superclass : #TOMSpriteRendererCroquet,
	#instVars : [
		'projectionTransform',
		'bufferedDrawCalls'
	],
	#pools : [
		'GLExtConstants',
		'OpenGLConstants'
	],
	#category : #TOMGameEngine
}

{ #category : #private }
TOMSpriteRendererExternal >> apiBeginBatch: viewProjectionTransform centeredGeometry: aBoolean [
	"void beginBatch(float *viewProjectionTransform, bool centeredGeometry);"
	<apicall: void 'beginBatch' (float* bool) module: 'libspriteRenderer.so'>
	^self externalCallFailed
]

{ #category : #private }
TOMSpriteRendererExternal >> apiEndBatch [
	"void endBatch();"
	<apicall: void 'endBatch' (void) module: 'libspriteRenderer.so'>
	^self externalCallFailed
]

{ #category : #private }
TOMSpriteRendererExternal >> apiRenderManySprites: renderInfos count: aNumber [
	"void renderManySprites(struct rectangle_render_info *infos, int count);"
	<apicall: void 'renderManySprites' (void* long) module: 'libspriteRenderer.so'>
	^self externalCallFailed
]

{ #category : #private }
TOMSpriteRendererExternal >> apiRenderSprite: modelTransform
scaleX: scaleX
scaleY: scaleY
red: r
green: g
blue: b
alpha: a
texcoords: texcoords
useTexture: useTexture [ 
	"void renderSprite(float *modelTransform, float scaleX, float scaleY, float r, float g, float b, float alpha, float *texcoords, GLboolean useTexture); "
	<apicall: void 'renderSprite' (float* float float float float float float float* bool) module: 'libspriteRenderer.so'>
	^ self externalCallFailed

]

{ #category : #private }
TOMSpriteRendererExternal >> apiSetupRenderer [
	"void setupRenderer();"
	<apicall: void 'setupRenderer' () module: 'libspriteRenderer.so'>
	^self externalCallFailed
]

{ #category : #private }
TOMSpriteRendererExternal >> beginBatch: baseTransform centeredGeometry: centeredGeometry [
	bufferedDrawCalls := OrderedCollection new.
	
	self
		apiBeginBatch: (projectionTransform composeWith: baseTransform)
		centeredGeometry: centeredGeometry
]

{ #category : #private }
TOMSpriteRendererExternal >> endBatch [
	self flushBuffer.
	
	currentTexture := nil.
	self apiEndBatch
]

{ #category : #private }
TOMSpriteRendererExternal >> flushBuffer [
	| data |
	currentTexture ifNotNil: [ currentTexture bind ].
	
	bufferedDrawCalls ifEmpty: [^self].
	
	data := ByteArray new: TOMRectangleRenderInfo byteSize * bufferedDrawCalls size.
	
	bufferedDrawCalls doWithIndex: [ :renderInfo :index |
		data
			structAt: (index - 1) * TOMRectangleRenderInfo byteSize + 1
			put: renderInfo
			length: TOMRectangleRenderInfo byteSize 
		"self
			apiRenderSprite: renderInfo modelTransform
			scaleX: renderInfo scaleX
			scaleY: renderInfo scaleY
			red: renderInfo red
			green: renderInfo green
			blue: renderInfo blue
			alpha: renderInfo alpha
			texcoords: renderInfo texcoordsOffset
			useTexture: renderInfo useTexture" ].
	self apiRenderManySprites: data count: bufferedDrawCalls size.
			
	bufferedDrawCalls := OrderedCollection new
]

{ #category : #'initialize-release' }
TOMSpriteRendererExternal >> initialize [
	super initialize.
	
	projectionTransform := Matrix4x4 new.
	textures := IdentityDictionary new
]

{ #category : #presentation }
TOMSpriteRendererExternal >> openInView: viewSize [
	super openInView: viewSize.
	
	GL
		glMatrixMode: GL_PROJECTION ;
		glGetFloatv: GL_PROJECTION_MATRIX with: projectionTransform;
		glMatrixMode: GL_MODELVIEW.
	
	projectionTransform := projectionTransform transposed.
	
	self apiSetupRenderer
]

{ #category : #private }
TOMSpriteRendererExternal >> postDrawFrame [
	self renderCursor.
	
	GL
		endFrame;
		swapBuffers
]

{ #category : #private }
TOMSpriteRendererExternal >> preDrawFrame: aColor [
	GL
		glClearColor: aColor red with: aColor green with: aColor blue with: aColor alpha;
		glClear: GL_COLOR_BUFFER_BIT
]

{ #category : #render }
TOMSpriteRendererExternal >> renderRectangle: aTexture transform: a4x4Matrix color: aColor scale: aPoint textureRegion: aRectangle [
	| oglTexture |
	oglTexture := self getOGLTexture: aTexture.
	
	currentTexture ~~ oglTexture ifTrue: [
		self flushBuffer.
		currentTexture := oglTexture ].
	
	bufferedDrawCalls add: (TOMRectangleRenderInfo new
		modelTransform: a4x4Matrix;
		scaleX: aPoint x;
		scaleY: aPoint y;
		red: aColor red;
		green: aColor green;
		blue: aColor blue;
		alpha: aColor alpha;
		texcoordsOffset: (FloatArray
			with: aRectangle topLeft x
			with: aRectangle topLeft y
			with: aRectangle bottomRight x
			with: aRectangle bottomRight y);
		useTexture: (oglTexture ifNotNil: [1] ifNil: [0]);
		yourself)
	
	"
	self
				apiRenderSprite: a4x4Matrix
				scaleX: aPoint x
				scaleY: aPoint y
				red: aColor red
				green: aColor green
				blue: aColor blue
				alpha: aColor alpha
				texcoords: (FloatArray
					with: aRectangle topLeft x
					with: aRectangle topLeft y
					with: aRectangle bottomRight x
					with: aRectangle bottomRight y)
				useTexture: oglTexture notNil"
]
