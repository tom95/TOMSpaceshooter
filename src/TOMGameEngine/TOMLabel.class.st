"
A TOMLabel is both a base class for all UIElements displaying text as well as a generic label.
By setting maxWidth, multiline text can be enabled.
"
Class {
	#name : #TOMLabel,
	#superclass : #TOMUIElement,
	#instVars : [
		'text',
		'font',
		'onClickAction',
		'fontSize',
		'color',
		'maxWidth',
		'blink',
		'opacityIncreasing',
		'textPadding'
	],
	#category : #TOMGameEngine
}

{ #category : #accessing }
TOMLabel >> blink [
	^blink
]

{ #category : #accessing }
TOMLabel >> blink: aBoolean [
	blink := aBoolean
]

{ #category : #behaviour }
TOMLabel >> clicked [
	onClickAction ifNotNil: [ onClickAction value ]
]

{ #category : #accessing }
TOMLabel >> color [
	^color
]

{ #category : #accessing }
TOMLabel >> color: aColor [
	color := aColor
]

{ #category : #accessing }
TOMLabel >> fontSize [
	^fontSize
]

{ #category : #accessing }
TOMLabel >> fontSize: aNumber [
	fontSize := aNumber.
	
	self updateExtent
]

{ #category : #rendering }
TOMLabel >> hasPostRender [
	^true
]

{ #category : #'initialize-release' }
TOMLabel >> height [
	^39
]

{ #category : #'initialize-release' }
TOMLabel >> initialize [
	super initialize.
	
	self zIndex: 1.
	
	text := ''.
	maxWidth := -1.
	fontSize := 22.
	textPadding := 0 asPoint.
	extent := self width @ self height.
	color := Color black.
	blink := false.
	opacityIncreasing := false
]

{ #category : #accessing }
TOMLabel >> maxWidth [
	^maxWidth
]

{ #category : #accessing }
TOMLabel >> maxWidth: width [
	" constrain text size to the given width. pass in a value <= 0 to make size unconstrained "
	maxWidth := width.
	
	self updateExtent
]

{ #category : #behaviour }
TOMLabel >> onClickDo: aBlock [
	onClickAction := aBlock.
]

{ #category : #rendering }
TOMLabel >> postRender: spriteRenderer [
	| y height |
	
	height := spriteRenderer class calculateTextHeight: self text forSize: self fontSize.
	y := (self extent y / 2) - (height / 2) + height.
	
	spriteRenderer renderText: self text
	    at: (self rectangle topLeft @ 0) + (0 @ y @ 0) + (self textPadding @ 0)
	    size: self fontSize
				color: (self color alpha: self color alpha * self opacity)
				maxWidth: self maxWidth
]

{ #category : #accessing }
TOMLabel >> text [
	^text
]

{ #category : #accessing }
TOMLabel >> text: aText [
	text := aText.
	
	self updateExtent
]

{ #category : #accessing }
TOMLabel >> textPadding [
	^textPadding
]

{ #category : #accessing }
TOMLabel >> textPadding: aPoint [
	textPadding := aPoint
]

{ #category : #updating }
TOMLabel >> update: dt [
	self blink ifFalse: [^self].
	
	opacityIncreasing
		ifTrue: [ self opacity: self opacity + dt ]
		ifFalse: [ self opacity: self opacity - dt ].
	
	self opacity < 0 ifTrue: [ self opacity: 0. opacityIncreasing := true ].
	self opacity > 1 ifTrue: [ self opacity: 1. opacityIncreasing := false ]
]

{ #category : #updating }
TOMLabel >> updateExtent [
	self extent: (self maxWidth >= 0
		ifTrue: [ self maxWidth ]
		ifFalse: [ (TOMGame rendererClass calculateTextWidth: self text forSize: self fontSize) ]) @ 
		self extent y + (self textPadding * 2)
]

{ #category : #'initialize-release' }
TOMLabel >> width [
	^222
]
