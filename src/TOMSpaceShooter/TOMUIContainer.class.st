"
A TOMUIContainer is a container for UI elements. Can be used as a composite for menus and other extendable element-types that utilise child-elements.
"
Class {
	#name : #TOMUIContainer,
	#superclass : #TOMUIElement,
	#instVars : [
		'borderWidth'
	],
	#category : #TOMSpaceShooter
}

{ #category : #presentation }
TOMUIContainer >> appendChild: aSprite on: aDirection [
	"uses same symbols as used as fillmodes in TOMSprite>>fitInto:fillMode:padded:"
	
	self extendBy: aSprite extent on: aDirection.
	self addChild: aSprite fillMode: aDirection padded: self borderWidth
]

{ #category : #accessing }
TOMUIContainer >> borderWidth [
	^ borderWidth
]

{ #category : #accessing }
TOMUIContainer >> borderWidth: aNumber [
	borderWidth := aNumber
]

{ #category : #presentation }
TOMUIContainer >> extendBy: anExtent on: aDirection [
	| minimumSize |
	
	aDirection caseOf: {
		[#topLeft] -> [ self extendBy: anExtent on: #left; extendBy: anExtent on: #top ].
		[#topRight] -> [ self extendBy: anExtent on: #right; extendBy: anExtent on: #top ].
		[#bottomLeft] -> [ self extendBy: anExtent on: #left; extendBy: anExtent on: #bottom ].
		[#bottomRight] -> [ self extendBy: anExtent on: #right; extendBy: anExtent on: #bottom ].
		[#top] -> [ "TODO currently unused anyway" ].
		[#bottom] -> [ self height: self height + anExtent y + self borderWidth ].
		[#left] -> [ "TODO currently unused anyway" ].
		[#right] -> [ self width: self width + anExtent x + self borderWidth ].
		[#center] -> [ "TODO currently unused anyway" ]}.
	
	minimumSize := anExtent + (self borderWidth * 2).
	self extent x < minimumSize x ifTrue: [ self width: minimumSize x ].
	self extent y < minimumSize y ifTrue: [ self height: minimumSize y ]
]

{ #category : #'initialize-release' }
TOMUIContainer >> initialize [
	super initialize.
	 
	self
		borderWidth: 15;
		extent: 1 asPoint;
		zIndex: 0;
		file: #'UI/MenuBackgroundBlack'.
	
	extent := self borderWidth asPoint
]
