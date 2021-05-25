"
A TOMTexture holds data and information about loaded images. It is never to be created manually, but only accessed via the assetFactory.
"
Class {
	#name : #TOMTexture,
	#superclass : #Object,
	#instVars : [
		'form',
		'extent',
		'region'
	],
	#category : #TOMGameEngine
}

{ #category : #accessing }
TOMTexture >> extent [
	^extent
]

{ #category : #accessing }
TOMTexture >> extent: aPoint [
	extent := aPoint
]

{ #category : #accessing }
TOMTexture >> form [
	^form
]

{ #category : #accessing }
TOMTexture >> form: aForm [
	form := aForm
]

{ #category : #mirroring }
TOMTexture >> mirrorHorizontally [
	^region := region topRight corner: region bottomLeft
]

{ #category : #mirroring }
TOMTexture >> mirrorVertically [
	^region := region bottomLeft corner: region topRight
]

{ #category : #accessing }
TOMTexture >> region [
	^region
]

{ #category : #accessing }
TOMTexture >> region: aRectangle [
	region := aRectangle
]

{ #category : #'as yet unclassified' }
TOMTexture >> subRegionAt: aNumber [
	" assumes a row layout of square subtextures "
	| stepSize |
	stepSize := (extent y / extent x) asFloat.
	
	^ region topLeft + (aNumber * stepSize @ 0)
		corner: region bottomLeft + ((aNumber + 1) * stepSize @ 0)
]
