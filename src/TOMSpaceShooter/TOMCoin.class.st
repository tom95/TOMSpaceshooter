"
A TOMCoin is a simple collectable granting resources to its collector.
"
Class {
	#name : #TOMCoin,
	#superclass : #TOMCollectable,
	#instVars : [
		'remainingTimeToLive',
		'opacityIncreasing'
	],
	#category : #TOMSpaceShooter
}

{ #category : #physics }
TOMCoin >> applyEffectsOn: aSpaceship [
	aSpaceship valueOfResources: aSpaceship valueOfResources + self resourceValue
]

{ #category : #physics }
TOMCoin >> blinkSpeedFactor [
	^2.7
]

{ #category : #'initialize-release' }
TOMCoin >> die [
	self scene ifNotNil: [
		TOMUtils spawnHalo: self center color: (Color r: 0.8 g: 0.6 b: 0) velocity: 5 in: self scene ].
	
	self delete
]

{ #category : #'initialize-release' }
TOMCoin >> initialize [
	super initialize.
	
	self file: #'Power-ups/coinGold'.
	
	remainingTimeToLive := self timeToLive.
	opacityIncreasing := false
]

{ #category : #physics }
TOMCoin >> physicsStep: dt [
	remainingTimeToLive := remainingTimeToLive - dt.
	
	remainingTimeToLive < self startBlinkAt ifTrue: [
		opacityIncreasing
			ifTrue: [ self opacity: self opacity + (dt * self blinkSpeedFactor) ]
			ifFalse: [ self opacity: self opacity - (dt * self blinkSpeedFactor) ].
		
		self opacity < 0.3 ifTrue: [ self opacity: 0.3. opacityIncreasing := true ].
		self opacity > 1 ifTrue: [ self opacity: 1. opacityIncreasing := false ]].
	
	remainingTimeToLive <= 0 ifTrue: [ self delete ]
]

{ #category : #'initialize-release' }
TOMCoin >> resourceValue [
	^50
]

{ #category : #physics }
TOMCoin >> startBlinkAt [
	^3
]

{ #category : #physics }
TOMCoin >> timeToLive [
	^8
]
