"
A TOMCamera holds the viewport information and can follow a given list of sprites.
It does so by adjusting its position and zoom level. Optionally, it can emulate camera shake and smooth position changes.
"
Class {
	#name : #TOMCamera,
	#superclass : #Object,
	#instVars : [
		'follow',
		'shakeIntensity',
		'viewSize',
		'viewport',
		'currentShakeDisplacement',
		'zoom',
		'position',
		'smoothPosition',
		'currentPosition',
		'baseZoomLevel',
		'soundListener'
	],
	#category : #TOMGameEngine
}

{ #category : #private }
TOMCamera >> applyListenerUpdate: dt [
	" if we follow a single sprite we focus on it, otherwise we focus on camera's center "
	follow size = 1
		ifTrue: [ self soundListener mirrorSprite: follow first dt: dt ]
		ifFalse: [ self soundListener position: currentPosition; angle: 0 velocity: 0 ]
]

{ #category : #private }
TOMCamera >> applyShaking: dt [
	shakeIntensity <= 0.0 ifTrue: [^self].
	
	shakeIntensity := shakeIntensity - (self shakeDecay * dt).
	
	currentPosition := shakeIntensity * ((TOMUtils randomFloatFrom: -1 to: 1) @
		(TOMUtils randomFloatFrom: -1 to: 1)) + currentPosition
]

{ #category : #accessing }
TOMCamera >> baseZoomLevel [
	^baseZoomLevel
]

{ #category : #accessing }
TOMCamera >> baseZoomLevel: aNumber [
	baseZoomLevel := aNumber
]

{ #category : #private }
TOMCamera >> computeCenterPosition [
	| minAndMax |
	self follow ifEmpty: [ ^self position ].
	
	minAndMax := TOMUtils minMaxCoordinates: (follow collect: [ :object | object center ]).
	
	^(minAndMax first corner: minAndMax second) center
]

{ #category : #private }
TOMCamera >> computeZoomLevel [
	" computes square of maximum distances between any two followers "
	| scale |
	
	self follow ifEmpty: [ ^self zoom ].
	
	scale := self maximumDistanceBetweenFollors + self zoomViewPadding / viewSize.
	
	^((scale x max: scale y) max: 1) + self baseZoomLevel
]

{ #category : #accessing }
TOMCamera >> currentPosition [
	^currentPosition
]

{ #category : #accessing }
TOMCamera >> follow [
	^follow
]

{ #category : #accessing }
TOMCamera >> follow: anArray [
	" set the object that the camera will follow/focus on "
	follow := anArray ifNil: [ Array new ]
]

{ #category : #accessing }
TOMCamera >> followSingle: aSprite [
	follow := Array with: aSprite
]

{ #category : #'initialize-release' }
TOMCamera >> initialize [ 
	viewport := 0 asPoint extent: 0 asPoint.
	shakeIntensity := 0.
	follow := Array new.
	position := 0 asPoint.
	zoom := 1.
	currentPosition := 0 asPoint.
	smoothPosition := false.
	baseZoomLevel := 0.
	soundListener := TOMSoundSourceEmpty new
]

{ #category : #accessing }
TOMCamera >> maxShakeIntensity [
	^300
]

{ #category : #geometry }
TOMCamera >> maxZoomLevel [
	^3
]

{ #category : #private }
TOMCamera >> maximumDistanceBetweenFollors [
	| delta maximumDistance |
	
	maximumDistance := 0 asPoint.
	
	1 to: self follow size do: [ :i |
		i + 1 to: self follow size do: [ :j |
			delta := ((self follow at: i) center - (self follow at: j) center) abs.
			
			delta x > maximumDistance x ifTrue: [ maximumDistance := delta x @ maximumDistance y ].
			delta y > maximumDistance y ifTrue: [ maximumDistance := maximumDistance x @ delta y ]]].
	
	^maximumDistance
]

{ #category : #accessing }
TOMCamera >> position [
	^position
]

{ #category : #accessing }
TOMCamera >> position: aPoint [
	position = aPoint ifTrue: [^self].
	
	position := aPoint.
	soundListener position: aPoint
]

{ #category : #accessing }
TOMCamera >> shake: impact [
	" indicate that an impact of a given strength happened and that the camera may now shake "
	shakeIntensity := (shakeIntensity + impact min: self maxShakeIntensity) / 5.0
]

{ #category : #accessing }
TOMCamera >> shakeDecay [
	" how fast shaking will stop again. will be multiplied by dt "
	^20
]

{ #category : #geometry }
TOMCamera >> smoothFactor [
	^10
]

{ #category : #accessing }
TOMCamera >> smoothPosition [
	^smoothPosition
]

{ #category : #accessing }
TOMCamera >> smoothPosition: aBoolean [
	smoothPosition := aBoolean
]

{ #category : #accessing }
TOMCamera >> soundListener [
	^soundListener
]

{ #category : #accessing }
TOMCamera >> soundListener: aSoundActor [
	soundListener := aSoundActor
]

{ #category : #geometry }
TOMCamera >> transform [
	" answers the 2d transform required to move the camera to the desired point "
	| transform zoomedViewSize topLeftCorner halfViewSize |
	transform := Matrix4x4 identity.
	
	halfViewSize := viewSize // 2.
	transform *= (Matrix4x4 withOffset: (Vector3 x: halfViewSize x y: halfViewSize y z: 0)).
	transform *= (Matrix4x4 withScale: (Vector3 value: 1.0 / zoom)).
	transform *= (Matrix4x4 withOffset: (Vector3 x: currentPosition x negated y: currentPosition y negated z: 0)).
	
	zoomedViewSize := viewSize * zoom.
	topLeftCorner := currentPosition - (zoomedViewSize / 2).
	viewport := topLeftCorner extent: zoomedViewSize.
		
	^transform
]

{ #category : #geometry }
TOMCamera >> update: dt [
	self follow ifNotEmpty: [
		zoom := self computeZoomLevel clampHigh: self maxZoomLevel.
		position := self computeCenterPosition ].
	
	self smoothPosition
		ifTrue: [ currentPosition := currentPosition interpolateTo: position at: dt * self smoothFactor ]
		ifFalse: [ currentPosition := position ].
	
	self
		applyListenerUpdate: dt;
		applyShaking: dt;
		transform
]

{ #category : #accessing }
TOMCamera >> viewSize [
	^viewSize
]

{ #category : #accessing }
TOMCamera >> viewSize: aSize [
	viewSize := aSize
]

{ #category : #accessing }
TOMCamera >> viewport [
	^viewport
]

{ #category : #accessing }
TOMCamera >> zoom [
	^zoom
]

{ #category : #accessing }
TOMCamera >> zoom: aNumber [
	zoom := aNumber
]

{ #category : #geometry }
TOMCamera >> zoomViewPadding [
	^600
]
