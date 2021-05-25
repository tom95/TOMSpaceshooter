"
A TOMAIStrategyIdle is an implementation of a TOMAIStrategy that is just being idle. It does literally nothing.
"
Class {
	#name : #TOMAIStrategyIdle,
	#superclass : #TOMAIStrategy,
	#category : #TOMSpaceShooter
}

{ #category : #updating }
TOMAIStrategyIdle >> determineCommands: dt [
	^Set new
]
