"
A TOMSlotDisplay gives the player an indicator of their weapons and weaponCooldowns.

"
Class {
	#name : #TOMSlotDisplay,
	#superclass : #TOMUIElement,
	#instVars : [
		'slot'
	],
	#category : #TOMSpaceShooter
}

{ #category : #'initialize-release' }
TOMSlotDisplay >> initialize [
	super initialize.
	self file: #'Power-ups/powerupGreen'
]

{ #category : #accessing }
TOMSlotDisplay >> slot [
	^slot
]

{ #category : #accessing }
TOMSlotDisplay >> slot: aSlot [
	| displayItem |
	slot := aSlot.
	
	displayItem := (TOMSprite newWith: self assetFactory)
		file: slot displayIconFile;
		zIndex: 1;
		positionInCenterOfSprite: self;
		yourself.
	
	self
		removeAllChildren;
		addChild: displayItem fillMode: #center.
]

{ #category : #updating }
TOMSlotDisplay >> update: dt [
	| heightFactor |
	heightFactor := slot timeUntilUsePercent.
	heightFactor >= 1.0
		ifTrue: [ self file: #'Power-ups/powerupGreen' ]
		ifFalse: [ self file: #'Power-ups/powerupBlue' ].
	
	self extent: self extent x @ (texture extent y * heightFactor)
]
