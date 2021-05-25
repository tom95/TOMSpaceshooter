"
A TOMSpatialHashTable is a hash table that maps 2d object positions to 1d array for fast location or proximity queries.

Instance Variables
	cellSize:		<Float>
	spatialHash:	<Dictionary>

cellSize
	- The size of each cell in the 1d array

spatialHash
	- The dictionary mapping grid cells to objects

"
Class {
	#name : #TOMSpatialHashTable,
	#superclass : #Object,
	#instVars : [
		'cellSize',
		'spatialHash'
	],
	#category : #TOMGameEngine
}

{ #category : #'instance creation' }
TOMSpatialHashTable class >> newWithCellSize: aNumber [
	^self basicNew
		cellSize: aNumber;
		initialize
]

{ #category : #accessing }
TOMSpatialHashTable >> allInArea: anArea [
	^self allInArea: anArea select: [ :item | true ]
]

{ #category : #accessing }
TOMSpatialHashTable >> allInArea: anArea do: aBlock [
	(self allInArea: anArea) do: aBlock
]

{ #category : #accessing }
TOMSpatialHashTable >> allInArea: anArea select: aConditionBlock [
	" answer a set of all objects that are roughly in that area (it will also include some in the outer edges that may go beyond the exact area. if an exact representation is needed, an intersection test will also have to be done) "
	| start end all |
	start := (anArea topLeft / self cellSize) floor.
	end := (anArea bottomRight / self cellSize) floor + 1 asPoint.
	
	all := IdentitySet new.
	
	start x to: end x do: [ :x |
		start y to: end y do: [ :y |
			spatialHash at: (TOMUtils pointGridHash: x @ y) ifPresent: [ :list |
				list do: [ :item | (aConditionBlock value: item) ifTrue: [ all add: item ]]]]].

	^all asOrderedCollection
]

{ #category : #accessing }
TOMSpatialHashTable >> allObjectsOnLineFrom: aStartPoint to: anEndPoint [
	^self allObjectsOnLineFrom: aStartPoint to: anEndPoint select: [ :object | ^true ]
]

{ #category : #accessing }
TOMSpatialHashTable >> allObjectsOnLineFrom: aStartPoint to: anEndPoint select: aBlock [
	| line hitObjects |
	line := {aStartPoint. anEndPoint}.
	hitObjects := IdentitySet new.
	
	(self allTilesOnLineFrom: aStartPoint to: anEndPoint) do: [ :tilePoint |
		spatialHash at: (TOMUtils pointGridHash: tilePoint) ifPresent: [ :objects |
				objects do: [ :object |
					((aBlock value: object) and: [TOMUtils shape: object rectangle corners intersects: line])
						ifTrue: [ hitObjects add: object ]]]].
	
	^hitObjects asOrderedCollection
]

{ #category : #accessing }
TOMSpatialHashTable >> allProximalPairsDo: aBlock [
	" execute block on all pairs that are near to each other according to cellSize "
	spatialHash do: [ :list |
		1 to: list size do: [ :i | (i + 1) to: list size do: [ :j |
				aBlock value: (list at: i) value: (list at: j) ]]]
]

{ #category : #private }
TOMSpatialHashTable >> allTilesOnLineFrom: aStartPoint to: anEndPoint [
	" pretty much standard integer based line rasterization algorithm "
	| startCell endCell error tiles delta currentPoint increment |
	
	tiles := OrderedCollection new.
	
	startCell := (aStartPoint / cellSize) truncated.
	endCell := (anEndPoint / cellSize) truncated.
	
	delta := (endCell - startCell) abs.
	currentPoint := startCell.
	increment := (endCell x > startCell x ifTrue: [1] ifFalse: [-1]) @
		(endCell y > startCell y ifTrue: [1] ifFalse: [-1]).
	error := delta x - delta y.
	delta := delta * 2.
	
	2 + delta x + delta y timesRepeat: [
		tiles add: currentPoint.
		
		error > 0
			ifTrue: [
				currentPoint := (currentPoint x + increment x) @ currentPoint y.
				error := error - delta x ]
			ifFalse: [
				currentPoint := currentPoint x @ (currentPoint y + increment y).
				error := error + delta y ]].
	
	^tiles
]

{ #category : #accessing }
TOMSpatialHashTable >> cellSize [
	^cellSize
]

{ #category : #accessing }
TOMSpatialHashTable >> cellSize: aSize [
	cellSize := aSize asFloat
]

{ #category : #accessing }
TOMSpatialHashTable >> closestObjectTo: aPosition within: aRadius select: aBlock [
	^TOMUtils
		closestObject: (self objectsAt: aPosition radius: aRadius select: aBlock)
		to: aPosition
]

{ #category : #'initialize-release' }
TOMSpatialHashTable >> initialize [
	super initialize.
	spatialHash := Dictionary new
]

{ #category : #updating }
TOMSpatialHashTable >> insert: aSprite [
	| hash end start |
	
	start := (aSprite largestBounds topLeft / cellSize) floor.
	end := (aSprite largestBounds bottomRight / cellSize) floor.
	
	start x to: end x do: [ :x |
		start y to: end y do: [ :y |
			hash := TOMUtils pointGridHash: x @ y.
			
			(spatialHash at: hash ifAbsentPut: [OrderedCollection new]) add: aSprite ]]
]

{ #category : #accessing }
TOMSpatialHashTable >> objectsAt: aPosition exactRadius: aRadius [
	" returns all objects around the given point for radius. "
	| radiusSquared |
	radiusSquared := aRadius squared.
	^self objectsAt: aPosition radius: aRadius select: [ :sprite |
		(sprite position squaredDistanceTo: aPosition) < radiusSquared]
]

{ #category : #accessing }
TOMSpatialHashTable >> objectsAt: aPosition radius: aRadius [
	" returns at least all objects around the given point for radius. Uses a square as estimation "
	^self objectsAt: aPosition radius: aRadius select: [ :item | true ]
]

{ #category : #accessing }
TOMSpatialHashTable >> objectsAt: aPosition radius: aRadius select: aConditionBlock [
	" returns at least all objects around the given point for radius that pass the select block. Uses a quad as estimation "
	^self allInArea: (aPosition - aRadius asPoint extent: aRadius asPoint * 2) select: aConditionBlock
]

{ #category : #updating }
TOMSpatialHashTable >> rebuildIndex: anArrayOfSprites [
	spatialHash := Dictionary new.
	anArrayOfSprites do: [ :sprite | self insert: sprite ]
]
