"
A TOMUIElement is a sprite that is placed in a scene's UILayer. It provides additional callbacks for click events and the 'update' callback, which is sent to sprites in the UILayer instead of 'physicsStep:'.
"
Class {
	#name : #TOMUIElement,
	#superclass : #TOMSprite,
	#category : #TOMGameEngine
}

{ #category : #behaviour }
TOMUIElement >> clicked [
	" subclasses may implement an action here "
]

{ #category : #updating }
TOMUIElement >> update: dt [
	" received every tick with delta time "
]
