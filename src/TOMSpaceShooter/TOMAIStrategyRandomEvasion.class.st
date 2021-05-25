"
A TOMAIStrategyRandomEvasion is an implementation of a TOMAIStrategy that changes to random directions in short intervals, hoping to confuse or evade enemy spaceships.
"
Class {
	#name : #TOMAIStrategyRandomEvasion,
	#superclass : #TOMAIStrategy,
	#instVars : [
		'timeUntilNewTurn',
		'targetAngle'
	],
	#category : #TOMSpaceShooter
}

{ #category : #updating }
TOMAIStrategyRandomEvasion >> determineCommands: dt [
	timeUntilNewTurn := timeUntilNewTurn - dt.
	
	timeUntilNewTurn <= 0 ifTrue: [
		targetAngle := self spaceship angle + (TOMUtils randomFloatFrom: Float halfPi negated to: Float halfPi).
		timeUntilNewTurn := TOMUtils randomFloatFrom: 0.2 to: 0.6 ].
	
	^{ TOMUtils shortestDirectionFrom: self spaceship angle to: targetAngle. #accelerate }
]

{ #category : #'initialize-release' }
TOMAIStrategyRandomEvasion >> initialize [
	timeUntilNewTurn := 0.
	targetAngle := 0
]
