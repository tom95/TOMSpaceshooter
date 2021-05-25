"
A TOMSpaceshipNightjar is a concrete spaceShip.

The nightjar is a player ship. It can cloak to evade enemy detection of stop rockets from following it.

"
Class {
	#name : #TOMSpaceshipNightjar,
	#superclass : #TOMSpaceship,
	#category : #TOMSpaceShooter
}

{ #category : #attributes }
TOMSpaceshipNightjar class >> spaceshipType [
	^#nightjar
]

{ #category : #'initialize-release' }
TOMSpaceshipNightjar >> setupDefaultSlots [
	self
		fillSlot: 1 with: (TOMWeapon new projectileClass: TOMSimpleLaser);
		fillSlot: 2 with: TOMInvisibilityHull new;
		fillSlot: 3 with: (TOMWeapon new projectileClass: TOMFlak);
		fillSlot: 4 with: (TOMWeapon new projectileClass: TOMSimpleMine)
]
