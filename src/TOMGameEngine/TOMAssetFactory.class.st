"
TOMAssetFactory is responsible for loading and caching all assets, mainly textures.
It is optionally capable of caching the loaded textures in Squeak's memory, making game-startup even quicker, and baking texture data into methods.
"
Class {
	#name : #TOMAssetFactory,
	#superclass : #Object,
	#instVars : [
		'textures',
		'cacheInImage',
		'cacheInMemory',
		'assetsBasePath'
	],
	#classVars : [
		'InMemoryCache'
	],
	#category : #TOMGameEngine
}

{ #category : #cache }
TOMAssetFactory class >> cacheInMemory: file form: form [
	self getInMemoryCache at: file put: form
]

{ #category : #cache }
TOMAssetFactory class >> clearMemoryCache [
	InMemoryCache := nil
]

{ #category : #cache }
TOMAssetFactory class >> getInMemoryCache [
	^InMemoryCache ifNil: [ InMemoryCache := Dictionary new ]
]

{ #category : #cache }
TOMAssetFactory class >> memoryCacheAt: file ifPresent: aBlockIfPresent [
	self getInMemoryCache
		at: file
		ifPresent: aBlockIfPresent
		ifAbsent: [nil]
]

{ #category : #cache }
TOMAssetFactory class >> memoryCacheAt: file ifPresent: aBlockIfPresent ifAbsent: aBlockIfAbsent [
	self getInMemoryCache
		at: file
		ifPresent: aBlockIfPresent
		ifAbsent: aBlockIfAbsent
]

{ #category : #'instance creation' }
TOMAssetFactory class >> newWithAssetsBasePath: aString [
	^self new
		assetsBasePath: aString;
		yourself
]

{ #category : #accessing }
TOMAssetFactory >> assetsBasePath [
	^assetsBasePath
]

{ #category : #accessing }
TOMAssetFactory >> assetsBasePath: aString [
	assetsBasePath := aString
]

{ #category : #accessing }
TOMAssetFactory >> cacheInImage [
	^cacheInImage
]

{ #category : #accessing }
TOMAssetFactory >> cacheInImage: aBoolean [
	" dump all the files that were accessed into messages in the image "
	cacheInImage := aBoolean
]

{ #category : #accessing }
TOMAssetFactory >> cacheInMemory [
	^cacheInMemory
]

{ #category : #accessing }
TOMAssetFactory >> cacheInMemory: aBoolean [
	" keep all textures that were accessed in the memory of the image "
	cacheInMemory := aBoolean
]

{ #category : #private }
TOMAssetFactory >> getSpritePath: aFile [
	^(FileDirectory uri: self assetsBasePath, '/', aFile, '.png') fullName
]

{ #category : #loading }
TOMAssetFactory >> getTexture: aFile [
	" return texture,texcoords pair from cache or load image "
	^textures at: aFile ifAbsent: [
		| form |
		form := self loadImage: aFile.
		
		textures
			at: aFile
			put: (TOMTexture new
				form: form;
				region: TOMRectangle unitSquare;
				extent: form extent;
				yourself) ]
]

{ #category : #private }
TOMAssetFactory >> importNameFromPath: path [
	^(path copyReplaceAll: '/' with: '_' asTokens: false) , 'Contents'
]

{ #category : #private }
TOMAssetFactory >> importTexture: path form: form [
	| stream |
	form storeOn: (stream := String new writeStream
		nextPutAll: (self importNameFromPath: path); cr;
		nextPutAll: '^';
		yourself).
	
	self class compile: stream contents classified: 'private - cache'
]

{ #category : #'initialize-release' }
TOMAssetFactory >> initialize [
	textures := Dictionary new.
	
	cacheInMemory := false.
	cacheInImage := false
]

{ #category : #loading }
TOMAssetFactory >> loadAtlas: atlas [
	" load the given texture atlas file and put the texture entries into the cache. File and corresponding texture are expected to be found in sprites/{atlas}.{xml,png}.
	
	Every <SubTexture name='file.png' x='46' y='72' width='111' height='222'> is parsed and put into cache with
	the corresponding texture coordinates for the given portion of the entire image"
	| image name |
	
	image := self loadImage: atlas.
	
	(XMLDOMParser parseDocumentFrom: (FileStream fileNamed: (FileDirectory uri: self assetsBasePath, '/', atlas, '.xml') fullName)) root
		tagsNamed: #SubTexture
		do: [ :element |
			name := element at: 'name'.
			
			textures
				at: (name copyFrom: 1 to: name size - 4)
				put: (TOMTexture new
					form: image;
					extent: (element at: 'width') asNumber @ (element at: 'height') asNumber;
					region: (self parseTexCoords: element forTextureSize: image extent);
					yourself)]
]

{ #category : #private }
TOMAssetFactory >> loadFromFile: aFile [
	| form |
	form := ImageReadWriter formFromFileNamed: (self getSpritePath: aFile).
	
	self cacheInMemory ifTrue: [ self class cacheInMemory: aFile form: form ].
	self cacheInImage ifTrue: [ self importTexture: aFile form: form ].
	
	^form
]

{ #category : #private }
TOMAssetFactory >> loadImage: aFile [
	self cacheInMemory ifTrue: [
		self class memoryCacheAt: aFile ifPresent: [ :cachedForm | ^cachedForm ]].
	
	(self cacheInImage and: [(self respondsTo: (self importNameFromPath: aFile) asSymbol)])
		ifTrue: [ ^self loadImportedTexture: aFile ].
	
	^self loadFromFile: aFile
]

{ #category : #private }
TOMAssetFactory >> loadImportedTexture: aPath [
	| name form |
	name := self importNameFromPath: aPath.
	
	form := self perform: name asSymbol.
	
	self cacheInMemory ifTrue: [ self class cacheInMemory: aPath form: form ].
	
	^form
]

{ #category : #private }
TOMAssetFactory >> parseTexCoords: anElement forTextureSize: aSize [
	| x y |
	
	x := (anElement at: 'x') asNumber / aSize x.
	y := (anElement at: 'y') asNumber / aSize y.
	
	^ x @ y
		extent:
			((anElement at: 'width') asNumber / aSize x) @
			((anElement at: 'height') asNumber / aSize y)
]

{ #category : #accessing }
TOMAssetFactory >> texturesDo: aBlock [
	textures do: aBlock
]
