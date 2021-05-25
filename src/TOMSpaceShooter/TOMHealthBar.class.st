"
A TOMHealthBar is a special progress bar that reacts to health changes of a spaceship.
"
Class {
	#name : #TOMHealthBar,
	#superclass : #TOMColoredProgressBar,
	#category : #TOMSpaceShooter
}

{ #category : #callbacks }
TOMHealthBar >> handleHealthChanged: health delta: delta attacker: attacker [
	self percentage: health
]
