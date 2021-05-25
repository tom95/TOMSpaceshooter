"
A TOMAIStrategyTrack is an implementation of a TOMAIStrategy that tracks a given target, it tries to catch up and will then circle it or stop close by depending on the AI's precision settings.
"
Class {
	#name : #TOMAIStrategyTrack,
	#superclass : #TOMAIStrategy,
	#instVars : [
		'target'
	],
	#category : #TOMSpaceShooter
}

{ #category : #updating }
TOMAIStrategyTrack >> determineCommands: dt [
	| commands angleToTarget |
	commands := Set new.
	
	self target ifNil: [^commands].
	
	angleToTarget := TOMUtils angleFrom: self spaceship center to: self target center.
	
	commands add: (TOMUtils
		shortestDirectionFrom: self spaceship angle
		to: angleToTarget).
	
	" if the angle between us and the target is too large, accelerating would not benefit us "
	(TOMUtils differenceAngle: self spaceship angle to: angleToTarget) >
	(Float halfPi * (1 / self commandProvider precision))
		ifTrue: [ commands add: #brake ]
		ifFalse: [
			(self spaceship position
				squaredDistanceTo: self target position) <= self randomSquaredBrakeDistance
				ifTrue: [ commands add: #brake ]
				ifFalse: [ commands add: #accelerate ]].
	
	^commands
]

{ #category : #updating }
TOMAIStrategyTrack >> randomSquaredBrakeDistance [
	| baseDistance variance |
	baseDistance := 40 * self commandProvider precision.
	variance := baseDistance * 0.4.
	
	^(TOMUtils randomFloatFrom: baseDistance - variance to: baseDistance + variance) squared
]

{ #category : #accessing }
TOMAIStrategyTrack >> target [
	^target
]

{ #category : #accessing }
TOMAIStrategyTrack >> target: aTarget [
	target := aTarget
]
