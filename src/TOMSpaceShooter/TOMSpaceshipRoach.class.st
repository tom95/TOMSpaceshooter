"
A TOMSpaceshipRoach is a concrete spaceShip.

The roach is a difficult enemy. It is slow moving, but shoots rockets and lays mines. It has a lot of lifePoints.

"
Class {
	#name : #TOMSpaceshipRoach,
	#superclass : #TOMSpaceship,
	#category : #TOMSpaceShooter
}

{ #category : #attributes }
TOMSpaceshipRoach class >> baseTurnSpeed [ 
	^100
]

{ #category : #attributes }
TOMSpaceshipRoach class >> maxLifePoints [ 
	^800
]

{ #category : #attributes }
TOMSpaceshipRoach class >> maxVelocity [
	^150
]

{ #category : #attributes }
TOMSpaceshipRoach class >> spaceshipType [ 
	^#roach
]

{ #category : #accessing }
TOMSpaceshipRoach >> commandProvider: aCommandProvider [
	super commandProvider: aCommandProvider.
	
	aCommandProvider
		shortRangeWeaponSlot: 1;
		longRangeWeaponSlot: 2
]

{ #category : #'initialize-release' }
TOMSpaceshipRoach >> setupDefaultSlots [
	self
		fillSlot: 1 with: (TOMWeapon new projectileClass: TOMSimpleMine);
		fillSlot: 2 with: (TOMWeapon new projectileClass: TOMRocket)
]
