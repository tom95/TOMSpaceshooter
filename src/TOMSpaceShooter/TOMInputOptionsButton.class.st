"
A TOMInputOptionsButton is a button that is used for displaying and picking keybindings for the user in the options menu.
"
Class {
	#name : #TOMInputOptionsButton,
	#superclass : #TOMButton,
	#instVars : [
		'command',
		'key',
		'inputHandler'
	],
	#category : #TOMSpaceShooter
}

{ #category : #accessing }
TOMInputOptionsButton >> command [
	^command
]

{ #category : #accessing }
TOMInputOptionsButton >> command: anObject [
	command := anObject
]

{ #category : #accessing }
TOMInputOptionsButton >> inputHandler [
	^inputHandler
]

{ #category : #accessing }
TOMInputOptionsButton >> inputHandler: anInputHandler [
	inputHandler := anInputHandler.
]

{ #category : #accessing }
TOMInputOptionsButton >> key [
	^key
]

{ #category : #accessing }
TOMInputOptionsButton >> key: anObject [
	key := anObject
]

{ #category : #'initialize-release' }
TOMInputOptionsButton >> postCopy [
	"required override to create a deep copy of a buttons prototype"
	self
		refreshOnClickAction;
		subscribeToInputRebinds
]

{ #category : #'initialize-release' }
TOMInputOptionsButton >> refreshOnClickAction [
	"only needs to be called after creating/copying buttons, resets references to 'self' "
	onClickAction := [
		self text: '- Press new key -'.
		self inputHandler when: #keyboardEvent send: #updateBindingTo: to: self ]
]

{ #category : #updating }
TOMInputOptionsButton >> reloadKeyForCommand [
	"will be triggered whenever a command gets a different key in inputHandler"
	self 
		key: (inputHandler keyForCommand: self command);
		text: key asString
]

{ #category : #'initialize-release' }
TOMInputOptionsButton >> subscribeToInputRebinds [
	"only needs to be called after creating/copying buttons, resets references to 'self' "
	
	inputHandler when: #updatedInputs send: #reloadKeyForCommand to: self
]

{ #category : #updating }
TOMInputOptionsButton >> updateBindingTo: anEvent [
	self inputHandler rebindCommand: self command to: anEvent key.
	
	self key: anEvent key.
	self text: anEvent key asString.
	
	self inputHandler removeActionsWithReceiver: self forEvent: #keyboardEvent
]
