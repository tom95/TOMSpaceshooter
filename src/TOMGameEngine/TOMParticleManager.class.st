"
A TOMParticleManager holds the list of all particles currently alive. It is responsible for updating their physics and rendering them.
"
Class {
	#name : #TOMParticleManager,
	#superclass : #Object,
	#instVars : [
		'particlePool',
		'numParticles'
	],
	#pools : [ ],
	#category : #TOMGameEngine
}

{ #category : #'initialize-release' }
TOMParticleManager >> createParticle: aTexture [
	| particle |
	particle := TOMParticle new texture: aTexture.
	(self getParticlePoolBucket: aTexture) add: particle.
	^particle
]

{ #category : #'initialize-release' }
TOMParticleManager >> getParticlePoolBucket: aTexture [
	^	particlePool at: aTexture ifAbsentPut: [ OrderedCollection new ]
]

{ #category : #'initialize-release' }
TOMParticleManager >> initialize [ 
	particlePool := Dictionary new
]

{ #category : #physics }
TOMParticleManager >> physicsStep: dt [
	particlePool do: [ :list |
		list copy do: [ :particle |
			particle update: dt.
			
			particle lifePercent > 1.0 ifTrue: [ list remove: particle ]]]
]

{ #category : #rendering }
TOMParticleManager >> render: spriteRenderer camera: camera [
	spriteRenderer
		additiveBlending: true;
		withTransform: camera transform
		centeredGeometry: true
		render: [
			particlePool do: [ :list |
				list do: [ :particle |
					(camera viewport containsPoint: particle position) ifTrue: [
						spriteRenderer
							renderRectangle: particle texture
								transform: (TOMUtils
									matrixForTranslate: particle position
									scale: 1 asPoint
									rotation: particle angle
									around: 0 asPoint)
								color: particle color
								scale: particle texture extent * particle scale
								textureRegion: TOMRectangle unitSquare ]]]];
		additiveBlending: false
]
