"
A TOMMapTileValuableField contains a field of valuable meteors that are protected by a number of turrets around them.
"
Class {
	#name : #TOMMapTileValuableField,
	#superclass : #TOMMapTile,
	#category : #TOMSpaceShooter
}

{ #category : #'tile-placement' }
TOMMapTileValuableField class >> minPlayerTilesDistance [
	^12
]

{ #category : #'tile-placement' }
TOMMapTileValuableField class >> probabilityOfAppearance [
	^1 / 60.0
]

{ #category : #'initialize-release' }
TOMMapTileValuableField >> gridSize [
	^3
]

{ #category : #'initialize-release' }
TOMMapTileValuableField >> populate: aScene [
	super populate: aScene.
	
	1 to: self gridSize do: [ :x |
		1 to: self gridSize do: [ :y |
			self addObject: ((TOMTurret newWith: aScene assetFactory)
				position: (x @ y) * self spacing;
				yourself) ]].
	
	(self randomize: 20) timesRepeat: [
		self addObject: ((TOMValuableMeteor newWith: aScene assetFactory)
			position: (TOMUtils randomFloatFrom: self spacing to: self gridSize * self spacing) @
				(TOMUtils randomFloatFrom: self spacing to: self gridSize * self spacing);
			stationary: true;
			zIndex: -1;
			yourself) ]
]

{ #category : #'initialize-release' }
TOMMapTileValuableField >> spacing [
	^600
]
