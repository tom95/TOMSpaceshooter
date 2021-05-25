"
A TOMButton is a simple class to show a button shape with a text on it.
"
Class {
	#name : #TOMButton,
	#superclass : #TOMLabel,
	#instVars : [
		'uniformSize'
	],
	#category : #TOMSpaceShooter
}

{ #category : #'initialize-release' }
TOMButton >> initialize [
	super initialize.
	
	self
		file: #'UI/buttonBlue';
		textPadding: 12 @ 0.
		
	uniformSize := true
]

{ #category : #accessing }
TOMButton >> uniformSize [
	^uniformSize
]

{ #category : #accessing }
TOMButton >> uniformSize: aBoolean [
	uniformSize := aBoolean.
	self updateExtent
]

{ #category : #updating }
TOMButton >> updateExtent [
	uniformSize
		ifTrue: [ self extent: texture extent ]
		ifFalse: [ super updateExtent ]
]
