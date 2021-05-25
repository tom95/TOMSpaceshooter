"
A TOMAIStrategyClearPath is an implementation of a TOMAIStrategy that begins shooting upon recognizing a meteor or similar (more precisely: any object that answers true in its ""isDestructibleObstacle"" message) in its current flight path.
"
Class {
	#name : #TOMAIStrategyClearPath,
	#superclass : #TOMAIStrategy,
	#category : #TOMSpaceShooter
}

{ #category : #updating }
TOMAIStrategyClearPath >> detectionConeDistance [
	^300
]

{ #category : #updating }
TOMAIStrategyClearPath >> detectionConeWidth [
	^300
]

{ #category : #updating }
TOMAIStrategyClearPath >> determineCommands: dt [
	^(TOMUtils
		objectsInConeStartPoint: self spaceship center
		startWidth: self spaceship extent x
		angle: self spaceship angle
		endWidth: self detectionConeWidth
		distance: self detectionConeDistance
		in: self spaceship scene
		select: [ :object | object isDestructibleObstacle ])
			ifNotEmpty: [ ^{#shoot} ]
			ifEmpty: [ ^Set new ]
]
