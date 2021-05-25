"
A TOMAIStrategyShoot is an implementation of a TOMAIStrategy that handles the weaponry of a ship and shoots at a given target when hitting it seems likely.
"
Class {
	#name : #TOMAIStrategyShoot,
	#superclass : #TOMAIStrategy,
	#instVars : [
		'target'
	],
	#category : #TOMSpaceShooter
}

{ #category : #updating }
TOMAIStrategyShoot >> couldHitTarget: aSprite [
	" determines whether the angle to the given target deviates only by a certain threshold
	  from the spaceship's angle "
	^(Float pi / 3) > (TOMUtils
		differenceAngle: self spaceship angle
		to: (TOMUtils angleFrom: self spaceship center to: aSprite position))
]

{ #category : #updating }
TOMAIStrategyShoot >> determineCommands: dt [
	| commands |
	
	commands := Set new.
	
	self target ifNil: [^commands].
	
	(self spaceship position squaredDistanceTo: self target position) > self squaredWeaponSwitchDistance
		ifTrue: [ self commandProvider longRangeWeaponSlot >= 1 ifTrue: [
			commands add: ('Inventory Slot ' , self commandProvider longRangeWeaponSlot) asSymbol ].
			self maybeShoot: commands ]
		ifFalse: [ self commandProvider shortRangeWeaponSlot >= 1 ifTrue: [
			commands add: ('Inventory Slot ' , self commandProvider shortRangeWeaponSlot) asSymbol ].
			commands add: #shoot ].
	
	^commands
]

{ #category : #updating }
TOMAIStrategyShoot >> maybeShoot: commands [
	((self couldHitTarget: self target) and:
	[(self wouldHitAlly: self target center) not])
		ifTrue: [ commands add: #shoot ]
]

{ #category : #updating }
TOMAIStrategyShoot >> squaredWeaponSwitchDistance [
	^300 squared
]

{ #category : #accessing }
TOMAIStrategyShoot >> target [
	^target
]

{ #category : #accessing }
TOMAIStrategyShoot >> target: aTarget [
	target := aTarget
]

{ #category : #updating }
TOMAIStrategyShoot >> wouldHitAlly: aPosition [
	^(self spaceship scene spatialHash
		allObjectsOnLineFrom: self spaceship center
		to: aPosition
		select: [ :object |
			object ~~ self spaceship and: [TOMUtils isAlly: object with: self spaceship ]]) notEmpty
]
