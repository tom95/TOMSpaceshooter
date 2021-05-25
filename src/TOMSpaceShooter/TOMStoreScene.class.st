"
A TOMStoreScene displays a UI where players can upgrade their weapons and repair their ship ingame. 
"
Class {
	#name : #TOMStoreScene,
	#superclass : #TOMScene,
	#instVars : [
		'store',
		'player',
		'valueOfResourcesDisplay',
		'background'
	],
	#category : #TOMSpaceShooter
}

{ #category : #presentation }
TOMStoreScene >> addRepairButtonAt: aPoint [
	| repairButton icon |
	icon :=  (TOMUIElement newWith: assetFactory)
		file: #'UI/', self player class spaceshipType asString ,'Life_', self player paint asString;
		zIndex: 3;
		yourself.

	repairButton := (TOMButton newWith: assetFactory)
		text: 'Repair for ', self calculateRepairCost , TOMSpaceshooterGame currencySymbol;
		fitInto: self viewRectangle fillMode: #topLeft padded: aPoint x + (self padding * 3) @ aPoint y;
		uniformSize: false;
		yourself.
	
	repairButton onClickDo: [
		(self tryPay: self calculateRepairCost) ifTrue: [
			self player repair.
			self removeFromOverlay: repairButton.
			self removeFromOverlay: icon ]].
	
	icon position: aPoint x + self padding @ (repairButton position y + ((repairButton extent y / 2) - (icon extent y / 2))).

	self
		addToOverlay: repairButton;
		addToOverlay: icon
]

{ #category : #presentation }
TOMStoreScene >> addUpgradeButtonsAt: aPoint [
	| y |
	y := aPoint y.

	self player slots keysAndValuesDo: [ :slotName :slotItem |
		| upgradeButton upgradeLabel upgradeIcon |
		upgradeLabel := (TOMLabel newWith: assetFactory).
		upgradeLabel
			position: aPoint x + (self padding * 2) @ y;
			color: Color white;
			yourself.
			
		upgradeIcon := (TOMUIElement newWith: assetFactory).
		upgradeIcon 
			position: aPoint x @ y + upgradeLabel extent y;
			file: slotItem displayIconFile;
			zIndex: 2;
			yourself.
			
		upgradeButton := (TOMButton newWith: assetFactory).
		upgradeButton
			position: aPoint x + self padding @ y + upgradeLabel extent y;
			uniformSize: false;
			onClickDo: [
				(self tryPay: slotItem upgradeCost) ifTrue: [
					slotItem upgrade.
					self updateLabelFor: slotItem button: upgradeButton label: upgradeLabel ]].
		
		self
			updateLabelFor: slotItem button: upgradeButton label: upgradeLabel;
			addToOverlay: upgradeButton;
			addToOverlay: upgradeIcon;
			addToOverlay: upgradeLabel.
		
		y := y + upgradeButton extent y + (self padding * 2) ]
]

{ #category : #presentation }
TOMStoreScene >> addValueOfResourcesDisplay [
	valueOfResourcesDisplay := (TOMCounter newWith: self assetFactory)
		fitInto: self storeRectangle fillMode: #bottomLeft padded: self padding * 2 @ self padding;
		number: self player valueOfResources;
		yourself.
	
	self player when: #valueOfResourcesChanged send: #number: to: valueOfResourcesDisplay.
	
	self 
		addToOverlay: ((TOMUIElement newWith: self assetFactory)
			file: #'Power-ups/coinGold';
			extent: valueOfResourcesDisplay extent y asPoint;
			fitInto: self storeRectangle fillMode: #bottomLeft padded: self padding asPoint;
			yourself);
		addToOverlay: valueOfResourcesDisplay
]

{ #category : #'initialize-release' }
TOMStoreScene >> backgroundColor [
	^TOMSpaceshooterGame backgroundColor
]

{ #category : #'store-logic' }
TOMStoreScene >> calculateRepairCost [
	^(1 - self player lifePercent * 200.0) truncated
]

{ #category : #'initialize-release' }
TOMStoreScene >> cursor [
	^'UI/cursor'
]

{ #category : #callbacks }
TOMStoreScene >> handleKeyboardCommand: aCommand [
	aCommand = #quickStartGame ifTrue: [self handleStoreLeft]
]

{ #category : #callbacks }
TOMStoreScene >> handleStoreLeft [
	self requestSceneSwitch: TOMGameScene rebuild: false argument: nil
]

{ #category : #presentation }
TOMStoreScene >> padding [
	^36 * TOMGame scale
]

{ #category : #accessing }
TOMStoreScene >> player [
	^player
]

{ #category : #accessing }
TOMStoreScene >> player: aPlayer [
	player := aPlayer
]

{ #category : #'initialize-release' }
TOMStoreScene >> resume: anObject [
	super resume: anObject.
	
	self inputHandler when: #commandEvent send: #handleKeyboardCommand: to: self
]

{ #category : #'initialize-release' }
TOMStoreScene >> start: aPlayer [
	| x |
	super start: aPlayer.
	
	self player: aPlayer.
	
	background :=  (TOMUIElement newWith: self assetFactory)
		file: #'storeScreen';
		fitInto: self viewRectangle fillMode: #fill;
		zIndex: -1;
		yourself.
	self addToOverlay: background.	
	
	x := (self viewSize x - (background extent * background scale ) x) / 2.
	
	"add leave store button"
	self addToOverlay: ((TOMButton newWith: assetFactory)
		text: 'Leave Store';
		onClickDo: [ self handleStoreLeft ];
		fitInto: self viewRectangle fillMode: #topRight padded: self padding asPoint + (x @ 0);
		yourself).
	
	"add spaceship icon"
	self addToOverlay: ((TOMUIElement newWith: assetFactory)
		file: (self player class sprite: self player paint);
		fitInto: self viewRectangle fillMode: #bottomRight padded: (self padding * 2 * background scale) asPoint + (x @ 0) ;
		zIndex: 3;
		yourself).
	
	"add repair button if player is damaged"
	self player lifePercent < 1.0
		ifTrue: [ self addRepairButtonAt: x @ self padding ].
	
	"add upgrade buttons, labels and icons for inventory slots of player"
	self addUpgradeButtonsAt: x @ (self padding * 4).
	
	self addValueOfResourcesDisplay
]

{ #category : #'initialize-release' }
TOMStoreScene >> stop [
	super stop.
	
	self inputHandler removeActionsWithReceiver: self
]

{ #category : #presentation }
TOMStoreScene >> storeRectangle [
	^(self viewSize x - (background extent * background scale ) x) / 2 @ 0 extent: (background extent * background scale)
]

{ #category : #'store-logic' }
TOMStoreScene >> tryPay: anAmount [
	self player valueOfResources < anAmount ifTrue: [^false].
	
	self player valueOfResources: self player valueOfResources - anAmount.
	^true
]

{ #category : #presentation }
TOMStoreScene >> updateLabelFor: slotItem button: aButton label: aLabel [
	aLabel text: slotItem title, ', Level: ', slotItem level.
	aButton text: 'Upgrade for ', slotItem upgradeCost, TOMSpaceshooterGame currencySymbol
]
