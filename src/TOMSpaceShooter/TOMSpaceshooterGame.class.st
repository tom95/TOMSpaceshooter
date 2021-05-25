"
A TOMSpaceshooterGame is a subclass of TOMGame, thus the main entry point for the actual space shooter. It defines its starting scene and command mappings and maintains the game menus. 
"
Class {
	#name : #TOMSpaceshooterGame,
	#superclass : #TOMGame,
	#instVars : [
		'playerSpaceship',
		'menuElements',
		'menuBuilder',
		'inMenu'
	],
	#classVars : [
		'NameForHighscore',
		'NameInHighscore'
	],
	#category : #TOMSpaceShooter
}

{ #category : #'feature-configuration' }
TOMSpaceshooterGame class >> aiDebug [
	^false
]

{ #category : #'feature-configuration' }
TOMSpaceshooterGame class >> assetsBasePath [
	^ (FileDirectory uri: 'TOMSpaceShooter') exists
		ifTrue: ['TOMSpaceShooter']
		ifFalse: [
			MCRepositoryGroup default repositories
				detect: [:repo | (repo isKindOf: MCFetchGithubRepository) and: [repo goferReferences anySatisfy: [:ref | ref name beginsWith: 'TOMSpaceShooter']]]
				ifFound: [:repo | (repo directory containingDirectory / 'assets') fullName]
				ifNone: [self error: 'path to assets not found']]
]

{ #category : #'feature-configuration' }
TOMSpaceshooterGame class >> backgroundColor [
	^Color r: 0.164 g: 0.176 b: 0.2
]

{ #category : #'feature-configuration' }
TOMSpaceshooterGame class >> currencySymbol [
	" one may set a currency symbol. or not. "
	^''
]

{ #category : #exporting }
TOMSpaceshooterGame class >> exportAsSar [
	| zip packages packageExtractCode installOGLCode |

	packages := #('TOMGameEngine' 'TOMSpaceShooter').

	zip := ZipArchive new.
	
	" packages "
	packages do: [ :package | | mczStream |
		mczStream := RWBinaryOrTextStream on: (String new: 10000).
		(MCWorkingCopy forPackage: (MCPackage new name: package)) newVersion fileOutOn: mczStream.
		(zip addString: mczStream contents as: package, '.mcz') desiredCompressionLevel: 0 ].
	
	" external resources "
	zip addTree: Smalltalk imagePath match: [:e | e fullName startsWith:
		Smalltalk imagePath, FileDirectory slash, self assetsBasePath ].
	
	" install routine "
	installOGLCode := '(Installer repository: ''http://source.squeak.org/FFI'')
			install: ''FFI-Pools-eem.3'';
			install: ''FFI-Kernel-EstebanLorenzano.29'';
			install: ''FFI-Tests-EstebanLorenzano.8''.
		(Installer repository: ''http://www.squeaksource.com/CroquetGL'')
			install: ''3DTransform'';
			install: ''OpenGL-Pools'';
			install: ''OpenGL-Core''.'.
	packageExtractCode := (packages
		inject: ''
		into: [ :concat :package | concat, 'self fileInMonticelloZipVersionNamed: ''', package, '.mcz''.' ]),
		'(self membersMatching: ''', self assetsBasePath, FileDirectory slash, '*.*'') do: [ :f | self extractMember: f].'.
	
	zip
		addString: installOGLCode, packageExtractCode as: 'install/preamble';
		writeToFileNamed: self name, '.sar'
]

{ #category : #'feature-configuration' }
TOMSpaceshooterGame class >> friendlyFire [
	^true
]

{ #category : #highscores }
TOMSpaceshooterGame class >> highscoreClass [
	^TOMRemoteHighscore
]

{ #category : #highscores }
TOMSpaceshooterGame class >> nameInHighscore [
	^NameInHighscore
]

{ #category : #highscores }
TOMSpaceshooterGame class >> setHighscoreName [
	NameInHighscore := UIManager default request: 'Enter your name for the highscore'
]

{ #category : #'feature-configuration' }
TOMSpaceshooterGame class >> varianceFactor [ 
	" factor by which values in map generation may vary.
	
	  E.g. a value of 20 with a varianceFactor of 0.1 would map to the range
	  20*0.1=2: [20-2,20+2]=[18,22] "
	^0.5
]

{ #category : #accessing }
TOMSpaceshooterGame >> activeScene: aScene [
	super activeScene: aScene.
	
	self inMenu ifTrue: [ self closeMenu ]
]

{ #category : #menus }
TOMSpaceshooterGame >> closeMenu [
	menuElements ifNil: [^self].
	
	self inMenu ifTrue: [ menuElements do: [ :element | self activeScene removeFromOverlay: element ]].
	self spriteRenderer cursor: (self activeScene cursor ifNotNilDo: [ :cursor | self assetFactory getTexture: cursor ]).
	
	inMenu := false
]

{ #category : #menus }
TOMSpaceshooterGame >> executeCommand: aCommand [
	super executeCommand: aCommand.
	
	(aCommand == #pause) ifTrue: [ self togglePauseMenu ]
]

{ #category : #menus }
TOMSpaceshooterGame >> inMenu [
	^inMenu
]

{ #category : #'initialize-release' }
TOMSpaceshooterGame >> initialize [
	super initialize.
	
	inMenu := false.
	
	self setupCommands.
	
	menuBuilder := TOMMenuBuilder new
		owner: self;
		createButtonPrototypes;
		inputHandler: self inputHandler;
		createOptionButtonPrototypes;
		yourself.
	
	(self class highscoreClass requiresName and: [self class nameInHighscore])
		ifNil: [ self class setHighscoreName ].
	
	self startScene: TOMIntroScene with: nil
]

{ #category : #'initialize-release' }
TOMSpaceshooterGame >> newGame [
	self gamePaused: false.
	self switchToSceneClass: TOMIntroScene rebuild: false argument: nil
]

{ #category : #menus }
TOMSpaceshooterGame >> openMenu [
	menuElements ifNil: [^self].
	
	self inMenu ifFalse: [ menuElements do: [ :element | self activeScene addToOverlay: element ]].
	self spriteRenderer cursor: (self assetFactory getTexture: 'UI/cursor').
	
	inMenu := true
]

{ #category : #'initialize-release' }
TOMSpaceshooterGame >> prefetchAssets [
	"pre load all assets that would otherwise cause blocking I/O while playing "
	
	"textureManager loadAtlas: 'spaceshooter_sheet'."
	
	(assetFactory getTexture: #'Effects/speed') mirrorVertically.
	(assetFactory getTexture: #'Spaceships/moth_green') mirrorVertically.
	(assetFactory getTexture: #'Spaceships/moth_black') mirrorVertically.
	(assetFactory getTexture: #'Spaceships/moth_blue') mirrorVertically.
	(assetFactory getTexture: #'Spaceships/moth_orange') mirrorVertically.
	(assetFactory getTexture: #'Spaceships/mantis_blue') mirrorVertically.
	(assetFactory getTexture: #'Spaceships/mantis_black') mirrorVertically.
	(assetFactory getTexture: #'Spaceships/mantis_green') mirrorVertically.
	(assetFactory getTexture: #'Spaceships/mantis_orange') mirrorVertically.
	(assetFactory getTexture: #'Spaceships/beetle_black') mirrorVertically.
	(assetFactory getTexture: #'Spaceships/beetle_blue') mirrorVertically.
	(assetFactory getTexture: #'Spaceships/beetle_green') mirrorVertically.
	(assetFactory getTexture: #'Spaceships/beetle_orange') mirrorVertically.
	(assetFactory getTexture: #'Spaceships/roach_orange') mirrorVertically.
	(assetFactory getTexture: #'Spaceships/roach_green') mirrorVertically.
	(assetFactory getTexture: #'Spaceships/roach_black') mirrorVertically.
	(assetFactory getTexture: #'Spaceships/roach_blue') mirrorVertically.
	(assetFactory getTexture: #'Spaceships/hornet_orange') mirrorVertically.
	(assetFactory getTexture: #'Spaceships/hornet_black') mirrorVertically.
	(assetFactory getTexture: #'Spaceships/hornet_green') mirrorVertically.
	(assetFactory getTexture: #'Spaceships/hornet_blue') mirrorVertically.
	(assetFactory getTexture: #'Damage/beetle_damage1') mirrorVertically.
	(assetFactory getTexture: #'Damage/beetle_damage2') mirrorVertically.
	(assetFactory getTexture: #'Damage/beetle_damage3') mirrorVertically.
	(assetFactory getTexture: #'Damage/roach_damage1') mirrorVertically.
	(assetFactory getTexture: #'Damage/roach_damage2') mirrorVertically.
	(assetFactory getTexture: #'Damage/roach_damage3') mirrorVertically.
	(assetFactory getTexture: #'Damage/hornet_damage1') mirrorVertically.
	(assetFactory getTexture: #'Damage/hornet_damage2') mirrorVertically.
	(assetFactory getTexture: #'Damage/hornet_damage3') mirrorVertically.
	(assetFactory getTexture: #'Damage/mantis_damage1') mirrorVertically.
	(assetFactory getTexture: #'Damage/mantis_damage2') mirrorVertically.
	(assetFactory getTexture: #'Damage/mantis_damage3') mirrorVertically.
	(assetFactory getTexture: #'Damage/moth_damage1') mirrorVertically.
	(assetFactory getTexture: #'Damage/moth_damage2') mirrorVertically.
	(assetFactory getTexture: #'Damage/moth_damage3') mirrorVertically.
	(assetFactory getTexture: #'Parts/gun09') mirrorVertically.
	(assetFactory getTexture: #'Parts/gun10') mirrorVertically.
	assetFactory getTexture: #'Damage/swallow_damage1'.
	assetFactory getTexture: #'Damage/swallow_damage2'.
	assetFactory getTexture: #'Damage/swallow_damage3'.
	assetFactory getTexture: #'Damage/eagle_damage1'.
	assetFactory getTexture: #'Damage/eagle_damage2'.
	assetFactory getTexture: #'Damage/eagle_damage3'.
	assetFactory getTexture: #'Damage/albatross_damage1'.
	assetFactory getTexture: #'Damage/albatross_damage2'.
	assetFactory getTexture: #'Damage/albatross_damage3'.
	assetFactory getTexture: #'explosion'.
	assetFactory getTexture: #'galaxy'.
	assetFactory getTexture: #'spaceBomb'.
	assetFactory getTexture: #'smallExplosion'.
	assetFactory getTexture: #'introScreen'.
	assetFactory getTexture: #'gameOverScreen'.
	assetFactory getTexture: #'extra/mapBackground'.
	assetFactory getTexture: #'extra/particle_line'.
	assetFactory getTexture: #'extra/particle_glow'.
	assetFactory getTexture: #'extra/particle_round'.
	assetFactory getTexture: #'red_sparkles'.
	assetFactory getTexture: #'blue_sparkles'.
	assetFactory getTexture: #'shop/shop03'.
	assetFactory getTexture: #'extra/platform'.
	assetFactory getTexture: #'extra/barHorizontal_blue_right'.
	assetFactory getTexture: #'extra/barHorizontal_blue_mid'.
	assetFactory getTexture: #'extra/barHorizontal_blue_left'.
	assetFactory getTexture: #'extra/barHorizontal_red_right'.
	assetFactory getTexture: #'extra/barHorizontal_red_mid'.
	assetFactory getTexture: #'extra/barHorizontal_red_left'.
	assetFactory getTexture: #'extra/barHorizontal_green_right'.
	assetFactory getTexture: #'extra/barHorizontal_green_mid'.
	assetFactory getTexture: #'extra/barHorizontal_green_left'.
	assetFactory getTexture: #'extra/barHorizontal_orange_right'.
	assetFactory getTexture: #'extra/barHorizontal_orange_mid'.
	assetFactory getTexture: #'extra/barHorizontal_orange_left'
]

{ #category : #'initialize-release' }
TOMSpaceshooterGame >> setupCommands [
	self inputHandler
		bindCommandMapping: #accelerate_1 -> #i;
		bindCommandMapping: #brake_1 ->  #k;
		bindCommandMapping: #left_1 ->  #j;
		bindCommandMapping: #right_1 -> #l;
		bindCommandMapping: #'Inventory Slot 1_1' -> #num1;
		bindCommandMapping: #'Inventory Slot 2_1' -> #num2;
		bindCommandMapping: #'Inventory Slot 3_1' -> #num3;
		bindCommandMapping: #'Inventory Slot 4_1' ->  #num4;
		bindCommandMapping: #shoot_1 -> #space;
		bindCommandMapping: #enterStore_1 -> #e;
		
		bindCommandMapping: #accelerate_2 -> #w;
		bindCommandMapping: #brake_2 -> #s;
		bindCommandMapping: #left_2 -> #a;
		bindCommandMapping: #right_2 -> #d;
		bindCommandMapping: #'Inventory Slot 1_2' -> #y;
		bindCommandMapping: #'Inventory Slot 2_2' -> #x;
		bindCommandMapping: #'Inventory Slot 3_2' -> #c;
		bindCommandMapping: #'Inventory Slot 4_2' -> #v;
		bindCommandMapping: #shoot_2 -> #q;
		bindCommandMapping: #enterStore_2 -> #f;
		
		bindCommandMapping: #accelerate_3 -> #up;
		bindCommandMapping: #brake_3 -> #down;
		bindCommandMapping: #left_3 -> #left;
		bindCommandMapping: #right_3 -> #right;
		bindCommandMapping: #'Inventory Slot 1_3' -> #b;
		bindCommandMapping: #'Inventory Slot 2_3' -> #n;
		bindCommandMapping: #'Inventory Slot 3_3' -> #m;
		bindCommandMapping: #'Inventory Slot 4_3' -> #comma;
		bindCommandMapping: #shoot_3 -> #enter;
		bindCommandMapping: #enterStore_3 -> #dot;
		
		bindCommandMapping: #pause -> #p;
		bindCommandMapping: #quickStartGame -> #tab
]

{ #category : #menus }
TOMSpaceshooterGame >> setupMenu: type [
	| menu |
	
	menuElements := OrderedCollection new.
	
	type = #pause ifTrue: [ menu := menuBuilder buildPauseMenu. ].
	type = #options ifTrue: [ menu := menuBuilder buildOptionsMenu. ].

	menuElements add: (menu
			fitInto: (0 asPoint extent: self class viewSize) fillMode: #center;
			yourself)
]

{ #category : #menus }
TOMSpaceshooterGame >> switchToHighscore [
	self switchToSceneClass: TOMGameOverScene rebuild: true argument: nil
]

{ #category : #menus }
TOMSpaceshooterGame >> switchToOptionsMenu [
	self
		closeMenu;
		setupMenu: #options;
		openMenu
]

{ #category : #menus }
TOMSpaceshooterGame >> switchToPauseMenu [
	self
		closeMenu;
		setupMenu: #pause;
		openMenu
]

{ #category : #menus }
TOMSpaceshooterGame >> toggleMenu [
	self inMenu
		ifFalse: [ self openMenu ]
		ifTrue: [ self closeMenu ].
]

{ #category : #menus }
TOMSpaceshooterGame >> togglePauseMenu [
	inMenu
		ifFalse: [
			self 
				gamePaused: true;
				setupMenu: #pause;
				openMenu]
		ifTrue: [
			self
				gamePaused: false;
				closeMenu]
]
