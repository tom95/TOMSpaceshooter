"
A TOMProgressBar is a simple colored bar that scales in width according to its percentage property.
"
Class {
	#name : #TOMProgressBar,
	#superclass : #TOMUIElement,
	#instVars : [
		'rightCap',
		'width',
		'currentWidth',
		'midPart',
		'leftCap'
	],
	#category : #TOMGameEngine
}

{ #category : #'instance creation' }
TOMProgressBar class >> newWith: anAssetFactory leftCap: leftCapSprite rightCap: rightCapSprite midPart: midPartSprite [
	^self new
		leftCapSprite: leftCapSprite;
		rightCapSprite: rightCapSprite;
		midPartSprite: midPartSprite;
		updateSprites;
		yourself
]

{ #category : #private }
TOMProgressBar >> animationSpeed [
	^2.0
]

{ #category : #'initialize-release' }
TOMProgressBar >> initialize [
	super initialize.
	
	midPart := (TOMUIElement newWith: self assetFactory).
	leftCap := (TOMUIElement newWith: self assetFactory).
	rightCap := (TOMUIElement newWith: self assetFactory).
	
	self
		addChild: rightCap;
		addChild: midPart;
		addChild: leftCap.
	
	width := self maxWidth.
	currentWidth := self maxWidth
]

{ #category : #accessing }
TOMProgressBar >> leftCapSprite: aFile [
	leftCap file: aFile
]

{ #category : #accessing }
TOMProgressBar >> maxWidth [
	^300
]

{ #category : #accessing }
TOMProgressBar >> midPartSprite: aFile [
	midPart file: aFile
]

{ #category : #accessing }
TOMProgressBar >> percentage: percentage [
	" set the percentage of health to be display "
	width := self maxWidth * percentage max: 0.001
]

{ #category : #accessing }
TOMProgressBar >> rightCapSprite: aFile [
	rightCap file: aFile
]

{ #category : #updating }
TOMProgressBar >> update: dt [
	currentWidth := currentWidth interpolateTo: width at: dt * self animationSpeed.
	midPart scale: currentWidth / midPart extent x @ 1.
	rightCap position: currentWidth @ 0
]

{ #category : #accessing }
TOMProgressBar >> updateSprites [
	leftCap position: leftCap extent x negated @ 0.
	self extent: self maxWidth + leftCap extent x + rightCap extent x @ midPart extent y
]
