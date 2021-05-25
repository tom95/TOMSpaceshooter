"
A TOMMapTileProtectedShop contains a shop that is protected by four neutral turrets.
"
Class {
	#name : #TOMMapTileProtectedShop,
	#superclass : #TOMMapTile,
	#category : #TOMSpaceShooter
}

{ #category : #'tile-placement' }
TOMMapTileProtectedShop class >> minPlayerTilesDistance [
	^2
]

{ #category : #'tile-placement' }
TOMMapTileProtectedShop class >> probabilityOfAppearance [
	^1 / 6.0
]

{ #category : #'initialize-release' }
TOMMapTileProtectedShop >> populate: aScene [
	| station turret |
	super populate: aScene.
	
	station := TOMSpaceStation newWith: aScene assetFactory.
	station position: (TOMMapTile extent / 2) - (station extent / 2).
	self addObject: station.
	
	(Array with: 0 @ 0 with: 0 @ 1 with: 1 @ 0 with: 1 @ 1) do: [ :position |
		turret := (TOMTurret newWith: aScene assetFactory)
			fraction: #neutral.
		turret position: station position - turret extent + (position * station extent) + (turret extent * position).
		self addObject: turret ]
]
