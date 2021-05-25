"
A TOMMapTileMeteorField is map tile containing a number of meteors, including a chance to contain valuable meteors.
"
Class {
	#name : #TOMMapTileMeteorField,
	#superclass : #TOMMapTile,
	#category : #TOMSpaceShooter
}

{ #category : #'tile-placement' }
TOMMapTileMeteorField class >> minPlayerTilesDistance [
	^0
]

{ #category : #'tile-placement' }
TOMMapTileMeteorField class >> probabilityOfAppearance [
	^1 / 10.0
]

{ #category : #'initialize-release' }
TOMMapTileMeteorField >> bigMeteors [
	^20
]

{ #category : #'initialize-release' }
TOMMapTileMeteorField >> populate: aScene [
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
TOMMapTileMeteorField >> smallMeteors [
	^50
]

{ #category : #'initialize-release' }
TOMMapTileMeteorField >> valuableMeteors [
	^3
]
