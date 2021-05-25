"
A TOMMap holds the map tiles and tracks the objects of interest through the map, instantiating new tiles as needed.

We activate all cells around the players including the one he is currently on. So for single player, we always have nine active tiles.
"
Class {
	#name : #TOMMap,
	#superclass : #Object,
	#instVars : [
		'cells',
		'currentCells',
		'scene',
		'objectsOfInterest'
	],
	#category : #TOMSpaceShooter
}

{ #category : #updating }
TOMMap >> cellsOfInterest [
	" find the two outer tiles in which our objects of interest are currently located, pad them by one tile on
	  each side and return an array of coordinates for each cell in the resulting rectangle "
	| cellsOfInterest minAndMax |
	cellsOfInterest := OrderedCollection new.
	(objectsOfInterest isNil or: [objectsOfInterest isEmpty])
		ifTrue: [ ^cellsOfInterest ].
	
	minAndMax := TOMUtils minMaxCoordinates: (objectsOfInterest collect: [ :object |
		(object position / TOMMapTile extent) floor ]).
	
	(minAndMax first x - 1) to: (minAndMax second x + 1) do: [ :x |
		(minAndMax first y - 1) to: (minAndMax second y + 1) do: [ :y |
			cellsOfInterest add: x @ y ]].
	
	^cellsOfInterest
]

{ #category : #private }
TOMMap >> createTileAt: gridPosition [
	" create a new random tile at the given position "
	| weightedRandomTarget weightedRandomSum sumProximalMapTileProbabilities candidates |
	
	candidates := TOMMapTile allSubclasses select: [ :tile |
		gridPosition abs >= tile minPlayerTilesDistance asPoint ].
	
	" algorithm works as follows: keep adding each item's probability until our target is reached.
	  That way we get a weighted random distribution based on the individual probability "
	sumProximalMapTileProbabilities := candidates inject: 0 into: [ :accumulated :tile |
			accumulated + tile probabilityOfAppearance ].
	
	weightedRandomTarget := TOMUtils randomFloatFrom: 0 to: sumProximalMapTileProbabilities.
	weightedRandomSum := 0.
	
	^self createTileAt: gridPosition type: (candidates detect: [ :tile |
		weightedRandomSum := weightedRandomSum + tile probabilityOfAppearance.
		
		weightedRandomSum > weightedRandomTarget.
	] ifNone: [ self assert: false ])
]

{ #category : #private }
TOMMap >> createTileAt: gridPosition type: mapTileClass [
	" create a new tile at the given position "
	| tile |
	tile := mapTileClass new.
	
	^tile
		gridPosition: gridPosition;
		populate: scene;
		yourself
]

{ #category : #private }
TOMMap >> delete [
	cells do: [ :cell | cell delete ]
]

{ #category : #private }
TOMMap >> globalPositionToGridPosition: position [
	^(position / TOMMapTile extent) floor
]

{ #category : #private }
TOMMap >> handleTileBorderCrossing: objects from: tile [
	| newGridPosition |
	objects do: [ :object |
		tile moveObjectToGlobalSpace: object.
	
		newGridPosition := self globalPositionToGridPosition: object position.
	
		((self tileAtGlobalPoint: object position)
			ifNil: [
				cells
					at: (TOMUtils pointGridHash: newGridPosition)
					put: (self createTileAt: newGridPosition) ])
			moveObjectToTileLocalSpace: object;
			takeObject: object]
]

{ #category : #'initialize-release' }
TOMMap >> initialize [ 
	cells := Dictionary new
]

{ #category : #accessing }
TOMMap >> objectOfInterest: anObject [
	" sets the object of interest, aka the object that defines which tiles are loaded/created "
	objectsOfInterest := Array with: anObject
]

{ #category : #accessing }
TOMMap >> objectsOfInterest [
	" return the object of interest, see also objectOfInterest: "
	^ objectsOfInterest
]

{ #category : #accessing }
TOMMap >> objectsOfInterest: anArrayOfObjects [
	objectsOfInterest := anArrayOfObjects
]

{ #category : #updating }
TOMMap >> predefineTileAt: gridPosition type: mapTileClass [
	cells
		at: (TOMUtils pointGridHash: gridPosition)
		put: (self createTileAt: gridPosition type: mapTileClass).
]

{ #category : #accessing }
TOMMap >> scene [
	^scene
]

{ #category : #accessing }
TOMMap >> scene: aScene [
	scene := aScene
]

{ #category : #accessing }
TOMMap >> tileAtGlobalPoint: aPoint [
	^self tileAtGlobalPoint: aPoint createIfAbsent: false
]

{ #category : #accessing }
TOMMap >> tileAtGlobalPoint: aPoint createIfAbsent: aBoolean [
	" returns the tile at the given global point "
 | cellPosition |
	cellPosition := (aPoint / TOMMapTile extent) floor.
	
	^cells
		at: (TOMUtils pointGridHash: cellPosition)
		ifAbsentPut: [
			aBoolean
				ifTrue: [self createTileAt: cellPosition]
				ifFalse: [nil]]
]

{ #category : #accessing }
TOMMap >> tileAtGridPoint: aPoint [
	" returns the tile at the given grid point "
 	^cells at: (TOMUtils pointGridHash: aPoint) ifAbsent: [ nil ]
]

{ #category : #updating }
TOMMap >> update [
	" collect or create the cells around our objectsOfInterest and wake/suspend accordingly "
	| activeCells |
	
	activeCells := OrderedCollection new.
	
	self cellsOfInterest do: [ :cellPosition |
		activeCells add: (cells at: (TOMUtils pointGridHash: cellPosition)
			ifAbsentPut: [ self createTileAt: cellPosition ]) ].

	currentCells
		ifNotNil: [
			" compare previous to new cells, wake/suspend accordingly "
			currentCells do: [ :cell |
				(activeCells includes: cell) ifFalse: [
					self handleTileBorderCrossing: (cell suspendAndGetLostObjects: scene) from: cell ]].
			
			activeCells do: [ :cell |
				(currentCells includes: cell) ifFalse: [ cell wake: scene ]]]
		ifNil: [
			" game's starting up, wake all "
			activeCells do: [ :cell | cell wake: scene ]].
	
	currentCells := activeCells
]
