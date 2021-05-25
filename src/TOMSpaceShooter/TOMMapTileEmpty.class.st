"
A TOMMapTileEmpty is literally just an empty map tile. Used to make space appear larger and as a starting point for the players (so we don't get to collide with any meteors at the very start or similar).
"
Class {
	#name : #TOMMapTileEmpty,
	#superclass : #TOMMapTile,
	#category : #TOMSpaceShooter
}

{ #category : #'tile-placement' }
TOMMapTileEmpty class >> minPlayerTilesDistance [
	^0
]

{ #category : #'tile-placement' }
TOMMapTileEmpty class >> probabilityOfAppearance [
	^1 / 80.0
]

{ #category : #'initialize-release' }
TOMMapTileEmpty >> populate: aScene [
	super populate: aScene.
	
	" we really want this to be empty, so remove all the default spawning objects if any "
	objects removeAll
]
