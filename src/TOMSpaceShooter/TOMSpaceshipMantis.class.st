"
A TOMSpaceshipMantis is a concrete spaceShip.

The Mantis is a basic enemy that shoots rockets instead of the default lasers.

"
Class {
	#name : #TOMSpaceshipMantis,
	#superclass : #TOMSpaceship,
	#category : #TOMSpaceShooter
}

{ #category : #attributes }
TOMSpaceshipMantis class >> baseTurnSpeed [ 
	^150
]

{ #category : #attributes }
TOMSpaceshipMantis class >> maxLifePoints [ 
	^400
]

{ #category : #attributes }
TOMSpaceshipMantis class >> maxVelocity [
	^450
]

{ #category : #attributes }
TOMSpaceshipMantis class >> spaceshipType [ 
	^#mantis
]

{ #category : #'initialize-release' }
TOMSpaceshipMantis >> setupDefaultSlots [
	self fillSlot: 1 with: (TOMWeapon new projectileClass: TOMRocket)
]
