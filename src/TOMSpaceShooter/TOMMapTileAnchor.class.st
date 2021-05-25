"
A TOMMapTileAnchor contains a TOMAnchor protected by neutral AIs.
"
Class {
	#name : #TOMMapTileAnchor,
	#superclass : #TOMMapTile,
	#category : #TOMSpaceShooter
}

{ #category : #'tile-placement' }
TOMMapTileAnchor class >> minPlayerTilesDistance [
	^3
]

{ #category : #'tile-placement' }
TOMMapTileAnchor class >> probabilityOfAppearance [
	^1 / 40.0
]

{ #category : #'initialize-release' }
TOMMapTileAnchor >> maxNumberOfShips [
	^2
]

{ #category : #'initialize-release' }
TOMMapTileAnchor >> populate: aScene [
	| enemyAnchor spaceship |
	super populate: aScene.
	
	self addObject: (enemyAnchor := (TOMAnchor newWith: aScene assetFactory)
		file: #'Spaceships/ufo_green';
		position: TOMMapTile extent / 2.0;
		yourself).
	
	self maxNumberOfShips timesRepeat: [
		spaceship := (TOMSpaceshipMantis newWith: aScene assetFactory fraction: #neutral)
			position: self randomPoint;
			commandProvider: (TOMSpaceshipAICommandProvider new
				aggressiveness: 0;
				territory: ((self rectangleInGlobalSpace: self class rectangle) insetBy: self class rectangle width * 0.3);
				yourself);
			yourself.
		self addObject: spaceship.
		enemyAnchor when: #attacked send: #target: to: spaceship commandProvider ]
]
