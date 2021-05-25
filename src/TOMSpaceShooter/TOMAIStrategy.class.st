"
A TOMAIStrategy is the base class for AI logic parts as implemented in the strategy pattern.
"
Class {
	#name : #TOMAIStrategy,
	#superclass : #Object,
	#instVars : [
		'spaceship',
		'commandProvider'
	],
	#category : #TOMSpaceShooter
}

{ #category : #'instance creation' }
TOMAIStrategy class >> newForCommandProvider: aCommandProvider [
	^self basicNew
		commandProvider: aCommandProvider;
		initialize;
		yourself
]

{ #category : #accessing }
TOMAIStrategy >> commandProvider [
	^commandProvider
]

{ #category : #accessing }
TOMAIStrategy >> commandProvider: aCommandProvider [
	commandProvider := aCommandProvider.
	
	self spaceship: aCommandProvider spaceship
]

{ #category : #updating }
TOMAIStrategy >> determineCommands: dt [
	^self subclassResponsibility
]

{ #category : #accessing }
TOMAIStrategy >> spaceship [
	^spaceship
]

{ #category : #accessing }
TOMAIStrategy >> spaceship: aSpaceship [
	spaceship := aSpaceship
]
