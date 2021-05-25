"
A TOMSpaceshipMoth is a concrete spaceShip.

It's a basic enemy, that shoots the flak weapon.
"
Class {
	#name : #TOMSpaceshipMoth,
	#superclass : #TOMSpaceship,
	#category : #TOMSpaceShooter
}

{ #category : #attributes }
TOMSpaceshipMoth class >> baseTurnSpeed [ 
	^350
]

{ #category : #attributes }
TOMSpaceshipMoth class >> maxLifePoints [ 
	^400
]

{ #category : #attributes }
TOMSpaceshipMoth class >> maxVelocity [
	^400
]

{ #category : #attributes }
TOMSpaceshipMoth class >> spaceshipType [ 
	^#moth
]

{ #category : #'initialize-release' }
TOMSpaceshipMoth >> setupDefaultSlots [
	self fillSlot: 1 with: (TOMWeapon new projectileClass: TOMFlak)
]
