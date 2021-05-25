"
A TOMMapTileDefensiveAI is a simple tile containing a number of defensive (neutral) AI ships.
"
Class {
	#name : #TOMMapTileDefensiveAI,
	#superclass : #TOMMapTile,
	#category : #TOMSpaceShooter
}

{ #category : #'tile-placement' }
TOMMapTileDefensiveAI class >> minPlayerTilesDistance [
	^1
]

{ #category : #'tile-placement' }
TOMMapTileDefensiveAI class >> probabilityOfAppearance [
	^1 / 4.0
]

{ #category : #'initialize-release' }
TOMMapTileDefensiveAI >> maxNumberOfShips [
	^10
]

{ #category : #'initialize-release' }
TOMMapTileDefensiveAI >> populate: aScene [
	| spaceships |
	
	super populate: aScene.
	
	spaceships := self portionByDifficultyOf: self spaceshipTypes.
	
	(self scaleByDifficultyRandomized: self maxNumberOfShips) timesRepeat: [
		self addObject: ((spaceships atRandom newWith: aScene assetFactory fraction: #neutral)
			position: self randomPoint;
			commandProvider: (TOMSpaceshipAICommandProvider new
				aggressiveness: 0;
				territory: (self rectangleInGlobalSpace: self class rectangle);
				yourself);
			yourself) ]
]

{ #category : #'initialize-release' }
TOMMapTileDefensiveAI >> spaceshipTypes [
	^{TOMSpaceshipMantis. TOMSpaceshipBeetle. TOMSpaceshipHornet}
]
