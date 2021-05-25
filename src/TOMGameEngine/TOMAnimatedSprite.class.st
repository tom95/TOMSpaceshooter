"
A TOMAnimatedSprite is a sprite that displays portions of its texture sequentially. It moves forward based on its 'timePerFrame' value, and wraps according to its 'loop' message.

The texture must be dividable in a horizontal row of equidistant tiles.
"
Class {
	#name : #TOMAnimatedSprite,
	#superclass : #TOMSprite,
	#instVars : [
		'timePassed',
		'step',
		'maxSteps',
		'loop',
		'isAnimated'
	],
	#category : #TOMGameEngine
}

{ #category : #initialization }
TOMAnimatedSprite >> file: aFile size: aCellSize [
	" initializes an animated sprite with the given file. cellSize determines the size of each
	  sub image in the file. If cellSize equals 0@0, the sprite is assumed to be a single image
	  that should not be animated (that's just here for simplified inheritance purposes) "
	self file: aFile.
	
	isAnimated := aCellSize ~= 0 asPoint.
	isAnimated ifTrue: [ self extent: aCellSize ].
	
	step := 0.
	loop := false.
	centerOfRotation := extent / 2.0.
	timePassed := 0.0.
	maxSteps := texture extent x / extent x
]

{ #category : #accessing }
TOMAnimatedSprite >> loop [
	^loop
]

{ #category : #accessing }
TOMAnimatedSprite >> loop: aBoolean [
	loop := aBoolean
]

{ #category : #stepping }
TOMAnimatedSprite >> nextStep [
	maxSteps = 1 ifTrue: [ ^self ].
	timePassed := 0.
	
	step := step + 1.
	step >= maxSteps ifTrue: [
		self loop
			ifTrue: [ step := 0 ]
			ifFalse: [ self delete ]]
]

{ #category : #stepping }
TOMAnimatedSprite >> physicsStep: dt [
	super physicsStep: dt.
	
	timePassed := timePassed + dt.
	timePassed > self timePerFrame ifTrue: [ self nextStep ]
]

{ #category : #accessing }
TOMAnimatedSprite >> texcoords [
	isAnimated
		ifTrue: [ ^self texture subRegionAt: step ]
		ifFalse: [ ^super texcoords ]
]

{ #category : #stepping }
TOMAnimatedSprite >> timePerFrame [
	^0.003
]
