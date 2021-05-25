"
A TOMSprite is a central superclass for everything that is to be displayed on the screen. It either displays a texture or a colored rectangle.

position denotes the place the sprite's top left corner is placed while angle is 0.

An angle of 0 means the sprite's front is facing upwards.

'corners' may be used to get the exact location of the corners of the sprite, first point is top left, rotating counterclockwise around the sprite.
In accordance to the composite pattern, sprites may contain other sprites, their transformation is relative to their parent (corners always returns absolute values).
"
Class {
	#name : #TOMSprite,
	#superclass : #Object,
	#instVars : [
		'position',
		'extent',
		'texture',
		'angle',
		'scale',
		'centerOfRotation',
		'bounds',
		'children',
		'localTransform',
		'worldTransform',
		'parent',
		'zIndex',
		'opacity',
		'scene',
		'fraction',
		'assetFactory',
		'soundProxy',
		'velocity',
		'rectangle',
		'center',
		'geometryCacheValid',
		'largestBounds'
	],
	#category : #TOMGameEngine
}

{ #category : #'instance creation' }
TOMSprite class >> newWith: anAssetFactory [

	 ^self basicNew
			assetFactory: anAssetFactory;
			initialize;
			yourself
]

{ #category : #hierarchy }
TOMSprite >> addChild: aSprite [
	self children add: (aSprite
		parent: self;
		scene: self scene;
		yourself).
		
	^aSprite
]

{ #category : #hierarchy }
TOMSprite >> addChild: aSprite fillMode: aFillMode [
	self addChild: aSprite fillMode: aFillMode padded: 0 @ 0.
]

{ #category : #hierarchy }
TOMSprite >> addChild: aSprite fillMode: aFillMode padded: aPoint [
	aSprite fitInto: (0 asPoint extent: self extent) fillMode: aFillMode padded: aPoint.
	^self addChild: aSprite
]

{ #category : #accessing }
TOMSprite >> alive [
	^self scene notNil
]

{ #category : #accessing }
TOMSprite >> angle [
	^angle
]

{ #category : #accessing }
TOMSprite >> angle: anAngle [ 
	anAngle = self angle ifTrue: [ ^self ].
	angle := TOMUtils normalizeAngle: anAngle.
	
	self invalidateLocalTransform
]

{ #category : #accessing }
TOMSprite >> assetFactory [
	^assetFactory
]

{ #category : #accessing }
TOMSprite >> assetFactory: anAssetFactory [
	assetFactory := anAssetFactory
]

{ #category : #geometry }
TOMSprite >> bottomMidPoint [
	^self rectangle bottomCenter 
]

{ #category : #geometry }
TOMSprite >> bounds [
	" untransformed (rotated/scaled) rectangle from topleft to bottomright of sprite "
	^self position extent: self extent
]

{ #category : #geometry }
TOMSprite >> center [
	geometryCacheValid ifFalse: [ self updateGeometryCache ].
	
	^center
]

{ #category : #accessing }
TOMSprite >> centerOfRotation [
	^centerOfRotation 
]

{ #category : #accessing }
TOMSprite >> centerOfRotation: aPoint [
	centerOfRotation := aPoint
]

{ #category : #hierarchy }
TOMSprite >> children [
	^children
]

{ #category : #hierarchy }
TOMSprite >> childrenDo: aBlock [
	self children copy do: aBlock
]

{ #category : #collision }
TOMSprite >> collided: otherObject [
	" may be implemented by a subclass. Should send a collidedWith* message "
]

{ #category : #collision }
TOMSprite >> collisionGroup [ 
	" by returning the same symbol for a number of objects, these objects are understood
	  to be in the same collision group and thereby don't collide with each other. Greatly
	  improves performance for objects of large number and same kind that don't collide with
	  each other anyway.
	  Returning self is basically saying 'this collides with everything' since we do identity
	  comparisions. "
	^self
]

{ #category : #'initialize-release' }
TOMSprite >> delete [
	self parent
		ifNotNil: [ self parent removeChild: self ]
		ifNil: [
			self scene ifNotNil: [ self scene removeFromGame: self ]]
]

{ #category : #accessing }
TOMSprite >> extent [ 
	^extent
]

{ #category : #accessing }
TOMSprite >> extent: aPoint [
	extent := aPoint
]

{ #category : #'initialize-release' }
TOMSprite >> file: aPath [
	aPath
		ifNil: [ texture := nil ]
		ifNotNil: [
			texture := self assetFactory getTexture: aPath.
			
			self
				extent: texture extent;
				centerOfRotation: self extent / 2.0 ]
]

{ #category : #geometry }
TOMSprite >> fitInto: aRectangle fillMode: aFillMode [
	self fitInto: aRectangle fillMode: aFillMode padded: 0 asPoint
]

{ #category : #geometry }
TOMSprite >> fitInto: aRectangle fillMode: aFillMode padded: aPoint [
	" places sprite according to fillMode within rectangle with optional padding. Options are
	  - unscaled: #top, #left, #right, #bottom, #topLeft, #topRight, #bottomLeft, #bottomRight #center
	  - scale without aspect ratio: #fill
	  - scale with aspect ratio: #fit "
	
	| destination |
	destination := aRectangle insetBy: aPoint.
	
	aFillMode caseOf: {
		[#fill] -> [
			self
				scale: (TOMUtils scaleForSize: self extent into: destination extent);
				positionInCenterOf: destination ].
	
		[#fit] -> [
			self
				scale: (destination width / self extent x) @ (destination height / self extent y);
				position: destination topLeft ].
		
		[#topLeft] -> [
			self position: destination topLeft ].
	
		[#topRight] -> [
			self position: (destination topRight x - self extent x) @ destination topRight y ].
	
		[#bottomLeft] -> [
			self position: destination bottomLeft x @ (destination bottomLeft y - self extent y) ].
	
		[#bottomRight] -> [
			self position: destination bottomRight - self extent ].
	
		[#top] -> [
			self position: (destination center x - (self extent x / 2)) @ destination top ].
	
		[#bottom] -> [
			self position: (destination center x - (self extent x / 2)) @ (destination bottom - self extent y) ].
	
		[#left] -> [
			self position: destination left @ (destination center y - (self extent y / 2)) ].
	
		[#right] -> [
			self position: (destination right - self extent x) @ (destination center y - (self extent y / 2)) ].
		
		[#center] -> [
			self positionInCenterOf: destination.
			self position: self position + aPoint ]
	}
]

{ #category : #accessing }
TOMSprite >> fraction [ 
	" A way to group objects within the game logic (especially useful for AI). A value of nil may be used to mark this object as being neutral or inanimate (the default) "
	^fraction
]

{ #category : #accessing }
TOMSprite >> fraction: aFraction [
	fraction := aFraction
]

{ #category : #render }
TOMSprite >> hasPostRender [
	" returns whether this object's postRender: should be used "
	^false
]

{ #category : #accessing }
TOMSprite >> height [
	^self extent y
]

{ #category : #accessing }
TOMSprite >> height: aNumber [
	self extent: self extent x @ aNumber
]

{ #category : #accessing }
TOMSprite >> ifAliveDo: aBlock [
	self alive ifTrue: [ aBlock valueWithEnoughArguments: {self} ]
]

{ #category : #accessing }
TOMSprite >> ifNotAliveDo: aBlock [
	self alive ifFalse: [ aBlock valueWithEnoughArguments: {self} ]
]

{ #category : #'initialize-release' }
TOMSprite >> initialize [
	angle := 0.0.
	position := 0 asPoint.
	scale := 1.0.
	velocity := 0.
	zIndex := 0.
	opacity := 1.
	children := OrderedCollection new.
	extent := 0 asPoint.
	centerOfRotation := 0 asPoint.
	geometryCacheValid := false.
	rectangle := TOMRectangle empty.
	largestBounds := TOMRectangle empty.
	soundProxy := TOMSoundSourceEmpty new
]

{ #category : #geometry }
TOMSprite >> invalidateLocalTransform [ 
	localTransform := nil.
	
	self invalidateWorldTransform
]

{ #category : #geometry }
TOMSprite >> invalidateWorldTransform [
	worldTransform := nil.
	geometryCacheValid := false.
	self children do: [ :child | child invalidateWorldTransform ]
]

{ #category : #collision }
TOMSprite >> isCollider [ 
	^false
]

{ #category : #geometry }
TOMSprite >> largestBounds [
	geometryCacheValid ifFalse: [ self updateGeometryCache ].
	
	^largestBounds
]

{ #category : #geometry }
TOMSprite >> localTransform [
	self updateLocalTransform.
	^localTransform
]

{ #category : #geometry }
TOMSprite >> matchDimensions: aSprite [
	" scale and translate self in a way that it overlays sprite "
	
	self matchDimensions: aSprite withFactor: 1.
]

{ #category : #geometry }
TOMSprite >> matchDimensions: aSprite withFactor: aFactor [
	" scale and translate self in a way that it overlays sprite "
	| mySize otherSize |
	mySize := self extent * self scale.
	otherSize := aSprite extent * aSprite scale * aFactor.
	
	self scale: (otherSize x max: otherSize y) / (mySize x max: mySize y).
	self positionInCenterOfSprite: aSprite.
]

{ #category : #geometry }
TOMSprite >> moveAlongAxis: aDistance [
	" moves the sprite along the axis it is currently facing towards "
	
	| x y |
	
	x := self position x + (self angle sin * aDistance) negated.
	y := self position y + (self angle cos * aDistance) negated.
	
	self position: x @ y
]

{ #category : #accessing }
TOMSprite >> opacity [
	^opacity
]

{ #category : #accessing }
TOMSprite >> opacity: anOpacityLevel [
	" opacity value in [0;1]. 0 being fully transparent and 1 being fully opaque "
	opacity := anOpacityLevel
]

{ #category : #hierarchy }
TOMSprite >> parent [
	^parent
]

{ #category : #hierarchy }
TOMSprite >> parent: aParent [
	parent := aParent
]

{ #category : #physics }
TOMSprite >> physicsStep: dt [
	" central point for receiving updates for subclasses "
	| scaledVelocity |
	
	scaledVelocity := self velocity * dt.
	
	self soundProxy
		position: self position;
		angle: self angle velocity: scaledVelocity;
		gain: self soundGain;
		pitch: self soundPitch;
		loop: self soundLoop.
	
	self moveAlongAxis: scaledVelocity
]

{ #category : #accessing }
TOMSprite >> position [
	^position
]

{ #category : #accessing }
TOMSprite >> position: aPosition [
	aPosition = self position ifTrue: [ ^self ].
	position := aPosition.
	
	self invalidateLocalTransform
]

{ #category : #geometry }
TOMSprite >> positionInCenterOf: aRectangle [
	self position: aRectangle topLeft + (aRectangle extent / 2) - (self extent * self scale / 2)
]

{ #category : #geometry }
TOMSprite >> positionInCenterOfSprite: aSprite [
	self positionInCenterOf: (aSprite position extent: (aSprite extent * aSprite scale))
]

{ #category : #physics }
TOMSprite >> postPhysicsStep: dt [
	" called after every normal physicsStep has been sent out and collisions passed "
]

{ #category : #render }
TOMSprite >> postRender: spriteRenderer [
	" may be implemented by subclasses. Will be executed within the drawing loop, but
	  after drawing all other sprites in the same layer. (--> independent of zIndex and
	  base transforms) For an example of its usage, have a look at TOMLabel. "
]

{ #category : #geometry }
TOMSprite >> rectangle [
	geometryCacheValid ifFalse: [ self updateGeometryCache ].
	
	^rectangle
]

{ #category : #hierarchy }
TOMSprite >> removeAllChildren [
	self childrenDo: [ :child | self removeChild: child ]
]

{ #category : #hierarchy }
TOMSprite >> removeChild: aSprite [
	self children remove: aSprite ifAbsent: [].
	
	^aSprite
		parent: nil;
		scene: nil;
		yourself
]

{ #category : #accessing }
TOMSprite >> scale [
	^scale
]

{ #category : #accessing }
TOMSprite >> scale: aScale [
	aScale = self scale ifTrue: [ ^self ].
	scale := aScale.
	self invalidateLocalTransform
]

{ #category : #accessing }
TOMSprite >> scene [
	^scene
]

{ #category : #accessing }
TOMSprite >> scene: aScene [
	scene := aScene.
	
	self children do: [ :child | child scene: aScene ]
]

{ #category : #sound }
TOMSprite >> sound [
	^nil
]

{ #category : #sound }
TOMSprite >> soundGain [
	^1.0
]

{ #category : #sound }
TOMSprite >> soundLoop [
	^false
]

{ #category : #sound }
TOMSprite >> soundPitch [
	^1.0
]

{ #category : #accessing }
TOMSprite >> soundProxy [
	^soundProxy
]

{ #category : #accessing }
TOMSprite >> soundProxy: aProxy [
	soundProxy := aProxy
		position: self position;
		angle: self angle velocity: self velocity;
		yourself
]

{ #category : #accessing }
TOMSprite >> texcoords [
	^self texture
		ifNotNil: [ self texture region ]
		ifNil: [ nil ]
]

{ #category : #accessing }
TOMSprite >> texture [
	^texture
]

{ #category : #geometry }
TOMSprite >> topMidPoint [
	^self rectangle topCenter 
]

{ #category : #geometry }
TOMSprite >> updateGeometryCache [ 
	| points size |
	geometryCacheValid ifTrue: [^self].
	
	geometryCacheValid := true.
	
	size := self extent * self scale.
	
	points := {0 asPoint. size x @ 0. size. 0 @ size y} collect: [ :p |
		| vector |
		vector := self worldTransform productFromVector3: p @ 0.
		vector x @ vector y ].
	
	rectangle := TOMRectangle fromPoints: points.
	largestBounds := rectangle asAxisAligned.
	center := rectangle center
]

{ #category : #geometry }
TOMSprite >> updateLocalTransform [
	" recalculates the transformation matrix "
	localTransform ifNotNil: [ ^self ].
	
	localTransform := TOMUtils
		matrixForTranslate: self position
		scale: self scale asPoint
		rotation: self angle
		around: self centerOfRotation
]

{ #category : #geometry }
TOMSprite >> updateWorldTransform [
	" update the matrix that puts the object into global space "
	worldTransform ifNotNil: [ ^self ].
	
	self parent
		ifNil: [ worldTransform := self localTransform ]
		ifNotNil: [ worldTransform := self localTransform * self parent worldTransform ]
]

{ #category : #accessing }
TOMSprite >> velocity [
	^velocity
]

{ #category : #accessing }
TOMSprite >> velocity: aNumber [
	velocity := aNumber
]

{ #category : #accessing }
TOMSprite >> width [
	^self extent x
]

{ #category : #accessing }
TOMSprite >> width: aNumber [
	self extent: aNumber @ self extent y
]

{ #category : #geometry }
TOMSprite >> worldTransform [ 
	self updateWorldTransform.
	^worldTransform 
]

{ #category : #accessing }
TOMSprite >> zIndex [
	" allows moving sprites above others. Highest number will be drawn topmost. "
	^zIndex
]

{ #category : #accessing }
TOMSprite >> zIndex: index [
	" allows moving sprites above others. Highest number will be drawn topmost. "
	zIndex := index
]
