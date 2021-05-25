"
A TOMMapTileHomingAI contains a number of enemy ships that will attack the player upon sight.
"
Class {
	#name : #TOMMapTileHomingAI,
	#superclass : #TOMMapTile,
	#category : #TOMSpaceShooter
}

{ #category : #'tile-placement' }
TOMMapTileHomingAI class >> minPlayerTilesDistance [
	^1
]

{ #category : #'tile-placement' }
TOMMapTileHomingAI class >> probabilityOfAppearance [
	^1 / 8.0
]

{ #category : #'initialize-release' }
TOMMapTileHomingAI >> maxNumberOfSpaceships [
	^6
]

{ #category : #'initialize-release' }
TOMMapTileHomingAI >> populate: aScene [
	| spaceships |
	
	super populate: aScene.
	
	spaceships := self portionByDifficultyOf: {TOMSpaceshipRoach. TOMSpaceshipHornet}.
	
	(self scaleByDifficultyRandomized: self maxNumberOfSpaceships) atRandom timesRepeat: [	
		self addObject: ((spaceships atRandom newWith: aScene assetFactory fraction: #enemy1)
			position: TOMMapTile extent / 2.0 + 300 atRandom;
			commandProvider: TOMSpaceshipAICommandProvider new;
			yourself) ]
]
