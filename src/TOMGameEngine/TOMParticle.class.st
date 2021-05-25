"
A TOMParticle holds the various attributes of a single particle in a particle system.

alphaBySpeed:
	Reduce alpha value based on the current speed of the particle
	
lengthMultiplier:
	Value by which length of the particle (y scale) will be multiplied with, effectively stretching it. Disable by setting this value to 0.
	

"
Class {
	#name : #TOMParticle,
	#superclass : #Object,
	#instVars : [
		'texture',
		'position',
		'angle',
		'scale',
		'color',
		'duration',
		'lifePercent',
		'velocity',
		'lengthMultiplier',
		'alpha',
		'varyWithSpeed'
	],
	#category : #TOMGameEngine
}

{ #category : #accessing }
TOMParticle >> alpha [
	^alpha
]

{ #category : #accessing }
TOMParticle >> alpha: anAlphaValue [
	^alpha := anAlphaValue
]

{ #category : #accessing }
TOMParticle >> angle [
	^angle
]

{ #category : #accessing }
TOMParticle >> angle: anAngle [
	angle := anAngle
]

{ #category : #accessing }
TOMParticle >> color [
	^color
]

{ #category : #accessing }
TOMParticle >> color: aColor [
	color := aColor
]

{ #category : #'initialize-release' }
TOMParticle >> copyAttributes: other [
	other
		position: position;
		angle: angle;
		color: color;
		lifePercent: lifePercent;
		duration: duration;
		scale: scale;
		texture: texture;
		velocity: velocity;
		lengthMultiplier: lengthMultiplier;
		alpha: alpha;
		varyWithSpeed: varyWithSpeed
]

{ #category : #accessing }
TOMParticle >> duration [
	^duration
]

{ #category : #accessing }
TOMParticle >> duration: aDuration [
	duration := aDuration
]

{ #category : #'initialize-release' }
TOMParticle >> initialize [
	super initialize.
	
	texture := nil.
	position := 0 asPoint.
	angle := 0.
	scale := 1 asPoint.
	color := Color white.
	duration := 1.
	lifePercent := 0.0.
	velocity := 0 asPoint.
	lengthMultiplier := 1.0.
	alpha := 1.0.
	varyWithSpeed := true
]

{ #category : #accessing }
TOMParticle >> lengthMultiplier [
	^lengthMultiplier
]

{ #category : #accessing }
TOMParticle >> lengthMultiplier: aMultiplier [
	lengthMultiplier := aMultiplier
]

{ #category : #accessing }
TOMParticle >> lifePercent [
	^lifePercent
]

{ #category : #accessing }
TOMParticle >> lifePercent: aPercentage [
	lifePercent := aPercentage
]

{ #category : #accessing }
TOMParticle >> position [
	^position
]

{ #category : #accessing }
TOMParticle >> position: aPosition [
	position := aPosition
]

{ #category : #accessing }
TOMParticle >> scale [
	^scale
]

{ #category : #accessing }
TOMParticle >> scale: aScale [
	scale := aScale
]

{ #category : #updating }
TOMParticle >> slowDown [ 
	^0.97
]

{ #category : #accessing }
TOMParticle >> texture [
	^texture
]

{ #category : #accessing }
TOMParticle >> texture: aTexture [
	texture := aTexture
]

{ #category : #updating }
TOMParticle >> update: dt [
	| speed progress |
	self lifePercent: self lifePercent + (dt / self duration).
	self position: self position + self velocity.
	self velocity: self velocity * self slowDown.
	
	speed := TOMUtils length: self velocity.
	
	" progress either goes from 1 to 0 if we vary by time or increases by speed if we vary by speed "
	self varyWithSpeed
		ifTrue: [ progress := ((speed min: 1.0 - self lifePercent * 2.0) clampHigh: 1) squared ]
		ifFalse: [ progress := 1 - self lifePercent ].
	
	self color: (self color alpha: self alpha * progress).
	
	self lengthMultiplier ~= 0 ifTrue: [
		self scale: self scale x @ (self lengthMultiplier * ((0.2 * speed + 0.1) min: 1.0) min: progress) ]
]

{ #category : #accessing }
TOMParticle >> varyWithSpeed [
	^varyWithSpeed
]

{ #category : #accessing }
TOMParticle >> varyWithSpeed: aBoolean [
	varyWithSpeed := aBoolean
]

{ #category : #accessing }
TOMParticle >> velocity [
	^ velocity
]

{ #category : #accessing }
TOMParticle >> velocity: aVelocity [
	velocity := aVelocity
]
