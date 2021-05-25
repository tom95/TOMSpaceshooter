"
A TOMMapTileTurrets is a small gathering of enemy turrets that will shoot upon sight.
"
Class {
	#name : #TOMMapTileTurrets,
	#superclass : #TOMMapTile,
	#category : #TOMSpaceShooter
}

{ #category : #'tile-placement' }
TOMMapTileTurrets class >> minPlayerTilesDistance [
	^3
]

{ #category : #'tile-placement' }
TOMMapTileTurrets class >> probabilityOfAppearance [
	^1 / 9.0
]

{ #category : #'initialize-release' }
TOMMapTileTurrets >> formationDistance [
	^400
]

{ #category : #'initialize-release' }
TOMMapTileTurrets >> populate: aScene [
	| basePosition |
	super populate: aScene.
	
	basePosition := TOMMapTile extent * 0.25.
	
	(Array with: 0 @ 0 with: 1 @ 0 with: 1 @ 1 with: 0 @ 1) do: [ :position |
		self addObject: ((TOMTurret newWith: aScene assetFactory)
			position: basePosition + (position * self formationDistance)) ]
]
