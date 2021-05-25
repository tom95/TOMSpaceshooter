"
A TOMSpaceshipEagle is a concrete spaceShip.

The Eagle is a player ship. It is fast and agile and has a jump ability which propells it forwards, dealing moderate damage for the duration.

"
Class {
	#name : #TOMSpaceshipEagle,
	#superclass : #TOMSpaceship,
	#category : #TOMSpaceShooter
}

{ #category : #attributes }
TOMSpaceshipEagle class >> baseTurnSpeed [
	^300
]

{ #category : #attributes }
TOMSpaceshipEagle class >> brakeFactor [
	^0.97
]

{ #category : #attributes }
TOMSpaceshipEagle class >> maxLifePoints [ 
	^600
]

{ #category : #attributes }
TOMSpaceshipEagle class >> maxVelocity [
	^1000
]

{ #category : #attributes }
TOMSpaceshipEagle class >> spaceshipType [ 
	^#eagle
]

{ #category : #'initialize-release' }
TOMSpaceshipEagle >> setupDefaultSlots [
	self
		fillSlot: 1 with: (TOMWeapon new projectileClass: TOMSimpleLaser);
		fillSlot: 2 with: TOMWarpEngine new;
		fillSlot: 3 with: (TOMWeapon new projectileClass: TOMFlak);
		fillSlot: 4 with: (TOMWeapon new projectileClass: TOMSimpleMine)
]
