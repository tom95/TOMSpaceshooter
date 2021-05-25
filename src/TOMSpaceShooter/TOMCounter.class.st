"
A TOMCounter is a simple UI element that displays numbers using the number sprites from our sprite set.
"
Class {
	#name : #TOMCounter,
	#superclass : #TOMUIContainer,
	#instVars : [
		'number'
	],
	#category : #TOMSpaceShooter
}

{ #category : #accessing }
TOMCounter >> increment: aValue [
	self number: self number + aValue
]

{ #category : #'initialize-release' }
TOMCounter >> initialize [
	super initialize.
	
	number := 0.
	
	self borderWidth: 0.
	self
		file: #'UI/MenuBackgroundTransparent';
		rebuild
]

{ #category : #accessing }
TOMCounter >> number [
	^number
]

{ #category : #accessing }
TOMCounter >> number: aNumber [
	number := aNumber.
	self rebuild
]

{ #category : #private }
TOMCounter >> rebuild [
	" rebuild the display "
	| sprite |
	children copy do: [ :digit | self removeChild: digit ].
	self extent: 0 @ 0.
	
	number asString do: [ :char |
		sprite := (TOMUIElement newWith: self assetFactory)
			file: #'UI/numeral' , char;
			yourself.
		self appendChild: sprite on: #right].
]
