"
A TOMBackgroundImage is a TOMSprite that displays a tiled background image as a rectangle that is slightly larger than the viewport and then repeatedly moved into the correct place of the viewport to give the illusion of a continuos tiled image.
"
Class {
	#name : #TOMBackgroundImage,
	#superclass : #TOMSprite,
	#instVars : [
		'texcoords'
	],
	#category : #TOMSpaceShooter
}

{ #category : #'initialize-release' }
TOMBackgroundImage >> initialize [
	super initialize.
	
	self
		file: #'Backgrounds/blue';
		zIndex: -2.
	
	texcoords := TOMRectangle unitSquare
]

{ #category : #rendering }
TOMBackgroundImage >> postPhysicsStep: dt [
	| viewport offset timesToViewport |
	super physicsStep: dt.
	
	viewport := self scene camera viewport.
	
	timesToViewport := viewport topLeft / self texture extent.
	offset := timesToViewport - timesToViewport floor.
	
	self
		position: viewport topLeft - (self texture extent * offset);
		extent: viewport extent + self texture extent
]

{ #category : #accessing }
TOMBackgroundImage >> texcoords [
	^0 asPoint
		corner: (self scene camera viewport extent + self texture extent) / self texture extent
]
