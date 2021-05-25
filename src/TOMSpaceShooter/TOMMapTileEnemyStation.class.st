"
A TOMMapTileEnemyStation is a well protected station of an enemy AI fraction.
"
Class {
	#name : #TOMMapTileEnemyStation,
	#superclass : #TOMMapTile,
	#category : #TOMSpaceShooter
}

{ #category : #'tile-attributes' }
TOMMapTileEnemyStation class >> fraction [
	^#enemy3
]

{ #category : #'tile-placement' }
TOMMapTileEnemyStation class >> minPlayerTilesDistance [
	^30
]

{ #category : #'tile-placement' }
TOMMapTileEnemyStation class >> probabilityOfAppearance [
	^1 / 100.0
]

{ #category : #'initialize-release' }
TOMMapTileEnemyStation >> createRandomSpaceship [
	^({TOMSpaceshipRoach. TOMSpaceshipMantis. TOMSpaceshipHornet} atRandom
				newWith: self scene assetFactory
				fraction: self class fraction)
				commandProvider: (TOMSpaceshipAICommandProvider new
					aggressiveness: 1;
					yourself);
				yourself
]

{ #category : #'initialize-release' }
TOMMapTileEnemyStation >> createTurret [
	^(TOMTurret newWith: self scene assetFactory)
			fraction: self class fraction;
			yourself
]

{ #category : #'initialize-release' }
TOMMapTileEnemyStation >> populate: aScene [
	| station |
	super populate: aScene.
	
	station := (TOMSprite newWith: aScene assetFactory)
		file: #'enemyStation';
		zIndex: -1;
		fitInto: self class rectangle fillMode: #center;
		yourself.
	
	#(topLeft topRight bottomLeft bottomRight left right) do: [ :position |
		self
			addObject: (self createTurret
				fitInto: station bounds fillMode: position padded: 180 @ 24;
				yourself);
			addObject: (self createRandomSpaceship
				fitInto: station bounds fillMode: position;
				yourself) ].
	
	{ 100 @ 300. 100 @ 1500 } do: [ :position |
		self addObject: (self createTurret position: position; yourself) ].
	
	1 to: 3 do: [ :index |
		self addObject: ((TOMSpaceshipMoth
			newWith: aScene assetFactory
			fraction: self class fraction)
			commandProvider: (TOMSpaceshipAICommandProvider new
				aggressiveness: 1;
				territory: (self rectangleInGlobalSpace: self class rectangle);
				yourself);
			position: 100 @ (300 * index)
			yourself) ].
	
	self addObject: station
]
