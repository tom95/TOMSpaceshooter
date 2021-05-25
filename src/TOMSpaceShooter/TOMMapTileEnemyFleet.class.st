"
A TOMMapTileEnemyFleet is a large fleet of enemies of one fraction.
"
Class {
	#name : #TOMMapTileEnemyFleet,
	#superclass : #TOMMapTile,
	#category : #TOMSpaceShooter
}

{ #category : #'tile-attributes' }
TOMMapTileEnemyFleet class >> fraction [
	^#enemy1
]

{ #category : #'tile-placement' }
TOMMapTileEnemyFleet class >> minPlayerTilesDistance [
	^30
]

{ #category : #'tile-placement' }
TOMMapTileEnemyFleet class >> probabilityOfAppearance [
	^1 / 100.0
]

{ #category : #'initialize-release' }
TOMMapTileEnemyFleet >> populate: aScene [
	super populate: aScene.
	
	{TOMSpaceshipRoach. TOMSpaceshipHornet. TOMSpaceshipMantis. TOMSpaceshipBeetle. TOMSpaceshipMoth}
		doWithIndex: [ :spaceshipClass :x |
			1 to: self spaceshipsPerType do: [ :y |
				self addObject: ((spaceshipClass newWith: aScene assetFactory fraction: self class fraction)
					position: (x + 3 @ y) * self shipDistance;
					angle: Float halfPi negated;
					commandProvider: (TOMSpaceshipAICommandProvider new
						aggressiveness: 1;
						stubbornness: 0;
						yourself);
					yourself) ]]
]

{ #category : #'initialize-release' }
TOMMapTileEnemyFleet >> shipDistance [
	^200
]

{ #category : #'initialize-release' }
TOMMapTileEnemyFleet >> spaceshipsPerType [
	^7
]
