"
A TOMSpaceshipCommandProvider is the base class that is queried by spaceships for commads to be executed.

Instance Variables
	commands:		<Array of command symbols>

commands
	- The array of commands to be sent to the spaceship

"
Class {
	#name : #TOMSpaceshipCommandProvider,
	#superclass : #Object,
	#instVars : [
		'spaceship'
	],
	#category : #TOMSpaceShooter
}

{ #category : #updating }
TOMSpaceshipCommandProvider >> activeCommands: dt [
	" answers the list of commands to be executed by the spaceship. Subclasses shall fill the returned set "
	^Set new
]

{ #category : #updating }
TOMSpaceshipCommandProvider >> requestTarget: aTarget [
	" request this command provider to switch to the given target. ignores the request by default "
]

{ #category : #'initialize-release' }
TOMSpaceshipCommandProvider >> spaceship [
	^spaceship
]

{ #category : #'initialize-release' }
TOMSpaceshipCommandProvider >> spaceship: aSpaceship [
	spaceship := aSpaceship
]
