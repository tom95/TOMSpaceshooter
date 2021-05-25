"
A TOMSpaceshipHornet is a concrete spaceShip.

The Hornet is the most advanced enemy. Very fast and agile and shoots exploding rockets.

"
Class {
	#name : #TOMSpaceshipHornet,
	#superclass : #TOMSpaceship,
	#category : #TOMSpaceShooter
}

{ #category : #attributes }
TOMSpaceshipHornet class >> baseTurnSpeed [ 
	^250
]

{ #category : #attributes }
TOMSpaceshipHornet class >> maxLifePoints [ 
	^600
]

{ #category : #attributes }
TOMSpaceshipHornet class >> maxVelocity [
	^800
]

{ #category : #attributes }
TOMSpaceshipHornet class >> spaceshipType [ 
	^#hornet
]

{ #category : #'initialize-release' }
TOMSpaceshipHornet >> setupDefaultSlots [
	self fillSlot: 1 with: (TOMWeapon new projectileClass: TOMRocket)
]
