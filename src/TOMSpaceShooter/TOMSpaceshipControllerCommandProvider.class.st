"
A TOMSpaceshipControllerCommandProvider works analogue to the CommandProvider, but instead of handling keyboard input it handles controller input.
"
Class {
	#name : #TOMSpaceshipControllerCommandProvider,
	#superclass : #TOMSpaceshipCommandProvider,
	#instVars : [
		'absoluteTurn',
		'weaponChangeTimeout',
		'index',
		'inputHandler'
	],
	#category : #TOMSpaceShooter
}

{ #category : #'instance creation' }
TOMSpaceshipControllerCommandProvider class >> newWithIndex: anIndex [
	^self basicNew
		index: anIndex;
		initialize;
		yourself
]

{ #category : #accessing }
TOMSpaceshipControllerCommandProvider >> absoluteTurn [
	^absoluteTurn 
]

{ #category : #accessing }
TOMSpaceshipControllerCommandProvider >> absoluteTurn: aBoolean [
	" set whether the joystick turning is considered to be absolute or relative to the ship's angle "
	absoluteTurn := aBoolean
]

{ #category : #updating }
TOMSpaceshipControllerCommandProvider >> accelerationTriggerThreshold [
	^100
]

{ #category : #updating }
TOMSpaceshipControllerCommandProvider >> activeCommands: dt [
	| commands |
	commands := super activeCommands: dt.
	
	(self inputHandler controller: self index axisAngleAt: #left threshold: self turnThreshold)
		ifNotNilDo: [ :angle |
			self absoluteTurn
				ifTrue: [ self applyAbsoluteTurn: angle commands: commands ]
				ifFalse: [ commands add: (TOMUtils shortestDirectionFrom: self spaceship angle to: angle) ]].
	
	weaponChangeTimeout := weaponChangeTimeout - dt.
	self applyButtonCommands: dt commands: commands.
	
	^commands
]

{ #category : #updating }
TOMSpaceshipControllerCommandProvider >> applyAbsoluteTurn: angle commands: commands [
	commands add: (angle < Float pi ifTrue: [#left] ifFalse: [#right])
]

{ #category : #updating }
TOMSpaceshipControllerCommandProvider >> applyButtonCommands: dt commands: commands [
	self inputHandler advancedControllerSupport
		ifTrue: [
			(self inputHandler controller: self index triggerAt: #right) > self accelerationTriggerThreshold
				ifTrue: [ commands add: #accelerate ].
			(self inputHandler controller: self index triggerAt: #left) > self accelerationTriggerThreshold
				ifTrue: [ commands add: #brake ]]
		ifFalse: [
			(self inputHandler controller: self index buttonActive: #b)
				ifTrue: [ commands add: #accelerate ]].
	
	(self inputHandler controller: self index buttonActive: #y)
		ifTrue: [ commands add: #enterStore ].
	(self inputHandler controller: self index buttonActive: #a)
		ifTrue: [ commands add: #shoot ].
	(self inputHandler controller: self index buttonActive: #x)
		ifTrue: [ self applyWeaponChange: dt commands: commands ].
]

{ #category : #updating }
TOMSpaceshipControllerCommandProvider >> applyWeaponChange: dt commands: commands [
	weaponChangeTimeout <= 0
		ifTrue: [
			weaponChangeTimeout := self timeoutAfterWeaponChange.
			commands add: (#('Inventory Slot 1' 'Inventory Slot 2' 'Inventory Slot 3' 'Inventory Slot 4')
				at: self spaceship activeInventorySlot \\ 4 + 1) ]
]

{ #category : #accessing }
TOMSpaceshipControllerCommandProvider >> index [
	^index
]

{ #category : #accessing }
TOMSpaceshipControllerCommandProvider >> index: anIndex [
	index := anIndex
]

{ #category : #'initialize-release' }
TOMSpaceshipControllerCommandProvider >> initialize [
	super initialize.
	absoluteTurn := true.
	weaponChangeTimeout := 0
]

{ #category : #accessing }
TOMSpaceshipControllerCommandProvider >> inputHandler [
	^inputHandler
]

{ #category : #accessing }
TOMSpaceshipControllerCommandProvider >> inputHandler: anInputHandler [
	inputHandler := anInputHandler
]

{ #category : #updating }
TOMSpaceshipControllerCommandProvider >> timeoutAfterWeaponChange [
	^0.3
]

{ #category : #updating }
TOMSpaceshipControllerCommandProvider >> turnThreshold [ 
	^0.7
]
