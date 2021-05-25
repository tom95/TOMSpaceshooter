"
A TOMSpaceshipInputCommandProvider is the command provider that translates key input to commands interpretable by the spaceship.

Instance Variables
	keys:		<Array of key symbols>

keys
	- The current array of active key symbols

"
Class {
	#name : #TOMSpaceshipInputCommandProvider,
	#superclass : #TOMSpaceshipCommandProvider,
	#instVars : [
		'inputHandler',
		'playerNumber'
	],
	#category : #TOMSpaceShooter
}

{ #category : #updating }
TOMSpaceshipInputCommandProvider >> activeCommands: dt [
	" assembles a set of commands to be run in this frame and returns it "
	| commands activeCommands |
	commands := super activeCommands: dt.
	activeCommands := inputHandler activeCommands.
	
	activeCommands do: [ :command |
		(command endsWith: '_', playerNumber) ifTrue: [
			commands add: (command copyFrom: 1 to: command size - 2) ]].
		
	^ commands
]

{ #category : #'initialize-release' }
TOMSpaceshipInputCommandProvider >> initialize [
	super initialize.
	
	playerNumber := 1
]

{ #category : #accessing }
TOMSpaceshipInputCommandProvider >> inputHandler [
	^inputHandler
]

{ #category : #accessing }
TOMSpaceshipInputCommandProvider >> inputHandler: anInputHandler [
	inputHandler := anInputHandler
]

{ #category : #accessing }
TOMSpaceshipInputCommandProvider >> playerNumber [
	^playerNumber
]

{ #category : #accessing }
TOMSpaceshipInputCommandProvider >> playerNumber: aNumber [
	playerNumber := aNumber
]
