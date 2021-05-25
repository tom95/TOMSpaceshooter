"
A TOMAIStrategyWayPoints is an implementation of a TOMAIStrategy that passes along the given list of way points, cycling when running out.
"
Class {
	#name : #TOMAIStrategyWayPoints,
	#superclass : #TOMAIStrategy,
	#instVars : [
		'wayPoints',
		'currentPointIndex'
	],
	#category : #TOMSpaceShooter
}

{ #category : #updating }
TOMAIStrategyWayPoints >> addWayPoint: aPoint [
	wayPoints add: aPoint
]

{ #category : #updating }
TOMAIStrategyWayPoints >> determineCommands: dt [
	| commands angleToTarget target |
	(self spaceship center squaredDistanceTo: (wayPoints at: currentPointIndex)) < self squaredDistanceTolerance ifTrue: [
		currentPointIndex := currentPointIndex + 1.
		currentPointIndex > wayPoints size ifTrue: [ currentPointIndex := 1 ]].
	
	target := wayPoints at: currentPointIndex.
	angleToTarget := TOMUtils angleFrom: self spaceship center to: target.
	
	commands := Set new.
	commands add: (TOMUtils
		shortestDirectionFrom: self spaceship angle
		to: (TOMUtils angleFrom: self spaceship center to: target)).
	
	(TOMUtils differenceAngle: self spaceship angle to: angleToTarget) > (Float halfPi / 2)
		ifTrue: [ commands add: #brake ]
		ifFalse: [ commands add: #accelerate ].
	
	^commands
]

{ #category : #'initialize-release' }
TOMAIStrategyWayPoints >> initialize [
	super initialize.
	
	wayPoints := OrderedCollection new.
	currentPointIndex := 1
]

{ #category : #accessing }
TOMAIStrategyWayPoints >> squaredDistanceTolerance [
	" at what distance a way point is considered as being reached "
	^100 squared
]

{ #category : #accessing }
TOMAIStrategyWayPoints >> wayPoints [
	^wayPoints
]

{ #category : #accessing }
TOMAIStrategyWayPoints >> wayPoints: aList [
	wayPoints := aList
]
