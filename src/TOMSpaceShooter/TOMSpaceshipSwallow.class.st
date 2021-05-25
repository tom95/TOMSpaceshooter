"
A TOMSpaceshipSwallow is a concrete spaceShip.

The swallow is a player ship. It is the only rocket-based player ship.
Extremely fragile!

"
Class {
	#name : #TOMSpaceshipSwallow,
	#superclass : #TOMSpaceship,
	#category : #TOMSpaceShooter
}

{ #category : #attributes }
TOMSpaceshipSwallow class >> baseTurnSpeed [ 
	^250
]

{ #category : #attributes }
TOMSpaceshipSwallow class >> brakeFactor [
	^0.975
]

{ #category : #attributes }
TOMSpaceshipSwallow class >> maxLifePoints [ 
	^400
]

{ #category : #attributes }
TOMSpaceshipSwallow class >> maxVelocity [
	^800
]

{ #category : #attributes }
TOMSpaceshipSwallow class >> spaceshipType [ 
	^#swallow
]

{ #category : #'initialize-release' }
TOMSpaceshipSwallow >> setupDefaultSlots [
	self
		fillSlot: 1 with: (TOMWeapon new projectileClass: TOMShell);
		fillSlot: 2 with: (TOMWeapon new projectileClass: TOMRocket);
		fillSlot: 3 with: TOMShield new;
		fillSlot: 4 with: (TOMWeapon new projectileClass: TOMPreciseHomingRocket)
]
