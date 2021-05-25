"
A TOMInvisibilityHull is a concrete item.

Activating the invisibilityHull will make enemy entities stop targeting the activator. Before becoming visible again, the spaceship starts flashing for two seconds.

"
Class {
	#name : #TOMInvisibilityHull,
	#superclass : #TOMUpgradableItem,
	#instVars : [
		'duration',
		'remainingDuration',
		'originalFraction',
		'opacityIncreasing'
	],
	#category : #TOMSpaceShooter
}

{ #category : #updating }
TOMInvisibilityHull >> activate: spaceship [
	self inCooldown ifTrue: [^self].
	
	super activate: spaceship.
	
	originalFraction := spaceship fraction.
	
	spaceship
		fraction: nil;
		opacity: 0.2.
	
	remainingDuration := duration.
	opacityIncreasing := false
]

{ #category : #updating }
TOMInvisibilityHull >> blinkSpeedFactor [
	^2
]

{ #category : #updating }
TOMInvisibilityHull >> cooldown [ 
	^duration + 5
]

{ #category : #accessing }
TOMInvisibilityHull >> description [
	^'Turns your ship temporarily invisible. No enemies can target you, however you will not be attributed any points you collect while invisible.'
]

{ #category : #'initialize-release' }
TOMInvisibilityHull >> initialize [
	super initialize.
	
	duration := 5.
	remainingDuration := 0
]

{ #category : #updating }
TOMInvisibilityHull >> removedFrom: spaceship [
	super removedFrom: spaceship.
	
	spaceship
		fraction: originalFraction;
		opacity: 1
]

{ #category : #updating }
TOMInvisibilityHull >> startBlinkAt [
	^duration - 2
]

{ #category : #accessing }
TOMInvisibilityHull >> title [
	^'Invisibility Hull'
]

{ #category : #updating }
TOMInvisibilityHull >> update: dt for: spaceship [
	super update: dt for: spaceship.
	
	remainingDuration > 0 ifTrue: [
		remainingDuration := remainingDuration - dt.
			
		remainingDuration < self startBlinkAt ifTrue: [
			opacityIncreasing
				ifTrue: [ spaceship opacity: spaceship opacity + (dt * self blinkSpeedFactor) ]
				ifFalse: [ spaceship opacity: spaceship opacity - (dt * self blinkSpeedFactor) ].
		
		spaceship opacity < 0.3 ifTrue: [ spaceship opacity: 0.3. opacityIncreasing := true ].
		spaceship opacity > 1 ifTrue: [ spaceship opacity: 1. opacityIncreasing := false ]].
	
		remainingDuration <= 0 ifTrue: [ self removedFrom: spaceship ]]
]

{ #category : #upgrading }
TOMInvisibilityHull >> upgrade [
	super upgrade.
	
	duration := duration * 1.1
]
