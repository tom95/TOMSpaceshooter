"
A TOMColoredProgressBar is a ""convenience"" subclass for the TOMProgressBar that sets the required sprites for the progress bar according to a color code from our sprite set.
"
Class {
	#name : #TOMColoredProgressBar,
	#superclass : #TOMProgressBar,
	#category : #TOMSpaceShooter
}

{ #category : #accessing }
TOMColoredProgressBar >> colorCode: aColor [
	self
		midPartSprite: 'extra/barHorizontal_',aColor,'_mid';
		leftCapSprite: 'extra/barHorizontal_',aColor,'_left';
		rightCapSprite: 'extra/barHorizontal_',aColor,'_right';
		updateSprites
]
