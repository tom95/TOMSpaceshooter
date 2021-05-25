"
A TOMSpaceshipAlbatross is a concrete spaceShip.

The Albatross is the default player ship. Slow, durable and equipped with 4 different weapons.

"
Class {
	#name : #TOMSpaceshipAlbatross,
	#superclass : #TOMSpaceship,
	#category : #TOMSpaceShooter
}

{ #category : #attributes }
TOMSpaceshipAlbatross class >> spaceshipType [ 
	^#albatross
]
