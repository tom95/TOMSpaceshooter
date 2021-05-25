"
A TOMAIStrategySTurnEvasion is an implementation of a TOMAIStrategy that flies in tight S turns in order to evade enemies.
"
Class {
	#name : #TOMAIStrategySTurnEvasion,
	#superclass : #TOMAIStrategy,
	#instVars : [
		'timeUntilNewTurn',
		'currentIsLeft',
		'baseAngle'
	],
	#category : #TOMSpaceShooter
}

{ #category : #updating }
TOMAIStrategySTurnEvasion >> determineCommands: dt [
	| targetAngle |
	timeUntilNewTurn := timeUntilNewTurn - dt.
	
	timeUntilNewTurn <= 0 ifTrue: [
		currentIsLeft := currentIsLeft not.
		timeUntilNewTurn := self turnInterval ].
	
	targetAngle := Float halfPi / 2.
	currentIsLeft ifFalse: [ targetAngle := targetAngle negated ].
	
	^{ TOMUtils shortestDirectionFrom: self spaceship angle to: baseAngle + targetAngle. #accelerate }
]

{ #category : #'initialize-release' }
TOMAIStrategySTurnEvasion >> initialize [
	currentIsLeft := true.
	self updateBaseAngle
]

{ #category : #updating }
TOMAIStrategySTurnEvasion >> turnInterval [
	^1.5
]

{ #category : #updating }
TOMAIStrategySTurnEvasion >> updateBaseAngle [
	timeUntilNewTurn := 0.
	baseAngle := self spaceship angle
]
