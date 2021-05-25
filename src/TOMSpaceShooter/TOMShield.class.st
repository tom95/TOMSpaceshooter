"
A TOMShield is a concrete item.

Activating the shield provides a damageReduction for the duration of the shield.
"
Class {
	#name : #TOMShield,
	#superclass : #TOMUpgradableItem,
	#instVars : [
		'damageReduction',
		'duration',
		'active',
		'shield',
		'remainingDuration'
	],
	#category : #TOMSpaceShooter
}

{ #category : #updating }
TOMShield >> activate: aSpaceship [
	self inCooldown ifTrue: [^self].
	
	super activate: aSpaceship.
	
	aSpaceship setActivateShield: self.
	
	shield ifNil: [
		shield := (TOMSprite newWith: aSpaceship assetFactory) file: 'Effects/shield1' ].
	
	active ifFalse: [ aSpaceship addChild: shield fillMode: #center padded: (0 @ -0.6). ].
	
	active := true.
	remainingDuration := duration.
	
	TOMUtils spawnHalo: aSpaceship center color: (Color r: 0.74 g: 0.89 b: 1.0) velocity: 15 in: aSpaceship scene
]

{ #category : #accessing }
TOMShield >> active [
	^active
]

{ #category : #updating }
TOMShield >> cooldown [
	^10 + self duration
]

{ #category : #upgrading }
TOMShield >> damageReduction [
	^damageReduction
]

{ #category : #accessing }
TOMShield >> description [
	^'Absorbs a percentage of damage dealt to your ship while active'
]

{ #category : #accessing }
TOMShield >> displayIconFile [
	^'Power-ups/shield_bronze'
]

{ #category : #upgrading }
TOMShield >> duration [
	^duration
]

{ #category : #'initialize-release' }
TOMShield >> initialize [
	super initialize.
	
	active := false.
	duration := 10.
	damageReduction := 0.2
]

{ #category : #accessing }
TOMShield >> reduceDamage: damage [
	^damage * self damageReduction
]

{ #category : #updating }
TOMShield >> removedFrom: spaceship [
	super removedFrom: spaceship.
	
	remainingDuration := 0.
	active := false.
	
	spaceship removeChild: shield
]

{ #category : #accessing }
TOMShield >> title [
	^'Shield'
]

{ #category : #updating }
TOMShield >> update: dt for: spaceship [
	super update: dt for: spaceship.
	
	active ifTrue: [
		remainingDuration < 0
			ifTrue: [ self removedFrom: spaceship ]
			ifFalse: [ remainingDuration := remainingDuration - dt ]]
]

{ #category : #upgrading }
TOMShield >> upgrade [
	super upgrade.
	
	damageReduction := damageReduction * 1.1.
	duration := duration * 1.1.
]
