"
A TOMMapTileGeneric is a plain tile resembling the empty one but having a chance to be slightly populated, usually without things of interest to the player.
"
Class {
	#name : #TOMMapTileGeneric,
	#superclass : #TOMMapTile,
	#category : #TOMSpaceShooter
}

{ #category : #'tile-placement' }
TOMMapTileGeneric class >> minPlayerTilesDistance [
	^0
]

{ #category : #'tile-placement' }
TOMMapTileGeneric class >> probabilityOfAppearance [
	^3 / 4.0
]

{ #category : #'initialize-release' }
TOMMapTileGeneric >> bigMeteors [
	^10
]

{ #category : #'initialize-release' }
TOMMapTileGeneric >> populate: aScene [
	super populate: aScene.
	
	(self randomize: self bigMeteors) timesRepeat: [
		self addObject: ((TOMMeteorBig newWith: aScene assetFactory)
			place: TOMMapTile extent) ].
	(self randomize: self smallMeteors) timesRepeat: [
		self addObject: ((TOMMeteorDebris newWith: aScene assetFactory)
			place: TOMMapTile extent) ].
	(self randomize: self valuableMeteors) timesRepeat: [
		self addObject: ((TOMValuableMeteor newWith: aScene assetFactory)
			place: TOMMapTile extent) ]
]

{ #category : #'initialize-release' }
TOMMapTileGeneric >> smallMeteors [
	^10
]

{ #category : #'initialize-release' }
TOMMapTileGeneric >> valuableMeteors [
	^1
]
