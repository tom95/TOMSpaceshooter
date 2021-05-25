"
A TOMSpaceshipBeetle is a concrete spaceShip.

Beetles are the most basic of enemies. They shoot lasers and have low lifePoints.

"
Class {
	#name : #TOMSpaceshipBeetle,
	#superclass : #TOMSpaceship,
	#category : #TOMSpaceShooter
}

{ #category : #attributes }
TOMSpaceshipBeetle class >> baseTurnSpeed [ 
	^150
]

{ #category : #attributes }
TOMSpaceshipBeetle class >> brakeFactor [ 
	^0.99
]

{ #category : #attributes }
TOMSpaceshipBeetle class >> maxLifePoints [ 
	^400
]

{ #category : #attributes }
TOMSpaceshipBeetle class >> maxVelocity [
	^450
]

{ #category : #attributes }
TOMSpaceshipBeetle class >> spaceshipType [ 
	^#beetle
]
