"
A TOMMapTileAIBattle is a map tile containing a large number of AI ships of two different fractions.
"
Class {
	#name : #TOMMapTileAIBattle,
	#superclass : #TOMMapTile,
	#category : #TOMSpaceShooter
}

{ #category : #'tile-placement' }
TOMMapTileAIBattle class >> minPlayerTilesDistance [
	^7
]

{ #category : #'tile-placement' }
TOMMapTileAIBattle class >> probabilityOfAppearance [
	^1.0 / 50.0
]

{ #category : #'initialize-release' }
TOMMapTileAIBattle >> maxSpaceshipsPerFraction [
	^30
]

{ #category : #'initialize-release' }
TOMMapTileAIBattle >> populate: aScene [
	| spaceshipClasses |
	super populate: aScene.
	
	spaceshipClasses := {TOMSpaceshipBeetle. TOMSpaceshipHornet. TOMSpaceshipMantis. TOMSpaceshipMoth}.
	
	{#enemy1. #enemy2} do: [ :fraction |
		(self scaleByDifficultyRandomized: self maxSpaceshipsPerFraction) timesRepeat: [
			self addObject: ((spaceshipClasses atRandom newWith: aScene assetFactory fraction: fraction)
				position: self randomPoint;
				angle: TOMUtils randomAngle;
				commandProvider: TOMSpaceshipAICommandProvider new;
				yourself) ]]
]
