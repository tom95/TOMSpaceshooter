"
A TOMAIStrategyReturnHome is an implementation of a TOMAIStrategy that makes the ship return to a certain set point recognized as ""home"".
"
Class {
	#name : #TOMAIStrategyReturnHome,
	#superclass : #TOMAIStrategy,
	#instVars : [
		'homePosition'
	],
	#category : #TOMSpaceShooter
}

{ #category : #updating }
TOMAIStrategyReturnHome >> determineCommands: dt [
	homePosition ifNil: [^Set new].
	
	^{ #accelerate.
		(TOMUtils
			shortestDirectionFrom: self spaceship angle
			to: (TOMUtils angleFrom: self spaceship center to: homePosition)) }
]

{ #category : #accessing }
TOMAIStrategyReturnHome >> homePosition [
	^homePosition
]

{ #category : #accessing }
TOMAIStrategyReturnHome >> homePosition: aPoint [
	homePosition := aPoint
]
