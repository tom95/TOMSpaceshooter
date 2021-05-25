"
A TOMMapTile is a part of the map. It holds its objects and wakes/suspends when needed. The base class contains a large number of utility functions, especially for scaling difficulty as the player progresses.
"
Class {
	#name : #TOMMapTile,
	#superclass : #Object,
	#instVars : [
		'objects',
		'gridPosition',
		'awake',
		'scene',
		'difficultyScalar'
	],
	#category : #TOMSpaceShooter
}

{ #category : #'difficulty-scaling' }
TOMMapTile class >> distanceForMaxDifficulty [
	^80
]

{ #category : #geometry }
TOMMapTile class >> extent [
	^ 2048 @ 2048
]

{ #category : #'tile-placement' }
TOMMapTile class >> minPlayerTilesDistance [
	^0
]

{ #category : #'tile-placement' }
TOMMapTile class >> probabilityOfAppearance [
	^1 / 100.0
]

{ #category : #geometry }
TOMMapTile class >> rectangle [
	^ 0 @ 0 extent: self extent
]

{ #category : #helper }
TOMMapTile >> addObject: aSprite [
	objects add: aSprite
]

{ #category : #updating }
TOMMapTile >> awake [
	^awake
]

{ #category : #updating }
TOMMapTile >> delete [
	objects do: [ :object | object delete ]
]

{ #category : #helper }
TOMMapTile >> difficultyScalar [
	^difficultyScalar
]

{ #category : #accessing }
TOMMapTile >> globalPosition [
	" answer the global position of the tile, that is the actual position in the world "
	^self gridPosition * self class extent
]

{ #category : #accessing }
TOMMapTile >> gridPosition [
	" answer the local position in the grid "
	^gridPosition
]

{ #category : #accessing }
TOMMapTile >> gridPosition: aPoint [
	" assign the local position in the grid "
	gridPosition := aPoint
]

{ #category : #updating }
TOMMapTile >> moveObjectToGlobalSpace: object [
	object position: object position + self globalPosition
]

{ #category : #updating }
TOMMapTile >> moveObjectToTileLocalSpace: object [
	object position: object position - self globalPosition
]

{ #category : #updating }
TOMMapTile >> pointInGlobalSpace: aPoint [
	^aPoint + self globalPosition
]

{ #category : #initialization }
TOMMapTile >> populate: aScene [
	" initialize the tile while providing a reference to the gameWorld to access e.g. the player. no objects are added to the gameWorld yet "
	scene := aScene.
	objects := OrderedCollection new.
	awake := false.
	difficultyScalar := (self gridPosition dist: 0 @ 0) / self class distanceForMaxDifficulty min: 1.0.
	
	" upon waking, there is a 1:10 chance that a burning meteor may spawn on any given tile "
	10 atRandom = 1 ifTrue: [
		self addObject: ((TOMBurningMeteor newWith: scene assetFactory)
			position: self randomPoint) ]
]

{ #category : #helper }
TOMMapTile >> portionByDifficultyOf: anArray [
	^anArray copyFrom: 1 to: (self scaleByDifficulty: anArray size)
]

{ #category : #helper }
TOMMapTile >> randomPoint [
	^(TOMUtils randomFloatFrom: 0 to: self class extent x) @ (TOMUtils randomFloatFrom: 0 to: self class extent y)
]

{ #category : #helper }
TOMMapTile >> randomize: value [
	" takes a value and applies a random variance to it based on the global variance factor.
	  In practice this will be: value+-value*randomVariance "
	| variance |
	variance := value * TOMSpaceshooterGame varianceFactor.
	^(TOMUtils randomFloatFrom: value - variance to: value + variance) floor
]

{ #category : #updating }
TOMMapTile >> rectangleInGlobalSpace: aRectangle [
	^aRectangle translateBy: self globalPosition
]

{ #category : #helper }
TOMMapTile >> removeObject: aSprite [
	objects remove: aSprite ifAbsent: []
]

{ #category : #helper }
TOMMapTile >> scaleByDifficulty: aValue [
	^(aValue * self difficultyScalar) truncated max: 1
]

{ #category : #helper }
TOMMapTile >> scaleByDifficultyRandomized: aNumber [
	^self randomize: (self scaleByDifficulty: aNumber)
]

{ #category : #accessing }
TOMMapTile >> scene [
	^scene
]

{ #category : #updating }
TOMMapTile >> suspendAndGetLostObjects: aScene [
	" put tile to rest, mainly remove all of the tile's objects from the gameWorld sprites. Subclasses may do additional work "
	| lostObjects |
	awake := false.
	
	lostObjects := OrderedCollection new.
	
	objects copy do: [ :object |
		object alive
			ifFalse: [ objects remove: object ]
			ifTrue: [
				aScene removeFromGame: object.
				
				self moveObjectToTileLocalSpace: object.
					
				((0 asPoint extent: self class extent) containsPoint: object position) ifFalse: [
					self removeObject: object.
					lostObjects add: object ]]].
		
	^lostObjects
]

{ #category : #updating }
TOMMapTile >> takeObject: object [
	self addObject: object.
	
	" if the game's already running, add the object real quick "
	awake ifTrue: [
		self moveObjectToGlobalSpace: object.
		object scene ifNil: [ self scene addToGame: object ]]
]

{ #category : #updating }
TOMMapTile >> wake: aScene [
	" wake the tile, mainly add all objects to the gameWorld's sprites. Subclasses may do more work "
	awake := true.
	
	objects do: [ :object |
		aScene addToGame: object.
		self moveObjectToGlobalSpace: object ]
]
