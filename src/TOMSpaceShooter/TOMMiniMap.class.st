"
A TOMMiniMap renders a number of a colored quads for every sprite that currently in its viewport based on the camera position. It picks each object's miniMapColor to depict them, players get the mini version of their spaceships drawn instead.
"
Class {
	#name : #TOMMiniMap,
	#superclass : #TOMUIElement,
	#category : #TOMSpaceShooter
}

{ #category : #render }
TOMMiniMap >> hasPostRender [ 
	^true
]

{ #category : #'initialize-release' }
TOMMiniMap >> iconSize [
	^6
]

{ #category : #'initialize-release' }
TOMMiniMap >> initialize [
	super initialize.
	
	self file: #'extra/mapBackground'
]

{ #category : #'initialize-release' }
TOMMiniMap >> mapZoom [
	^25
]

{ #category : #render }
TOMMiniMap >> postRender: spriteRenderer [
	| transform pos baseTransform cameraPosition |
	baseTransform := TOMUtils translationMatrixForPoint: self rectangle topLeft.
	transform := Matrix4x4 identity.
	cameraPosition := self scene camera currentPosition.
	
	spriteRenderer withTransform: baseTransform render: [
		self scene gameLayerDo: [ :sprite |
			sprite miniMapColor ifNotNilDo: [ :color |
				pos := (sprite center - cameraPosition) / self mapZoom + (self extent / 2).
				
				(TOMUtils containedInLocalRect: self extent point: pos) ifTrue: [
					transform translationX: pos x y: pos y z: 0.
					
					sprite fraction = #player
						ifTrue: [
							self renderMiniSpaceship: sprite position: pos renderer: spriteRenderer ]
						ifFalse: [
							spriteRenderer
								renderRectangle: nil
								transform: transform transposed 
								color: color
								scale: self iconSize asPoint
								textureRegion: TOMRectangle unitSquare ]]]]]
]

{ #category : #render }
TOMMiniMap >> renderMiniSpaceship: aSpaceship position: aPosition renderer: aSpriteRenderer [
	| texture |
	texture := (self assetFactory getTexture: 'UI/',aSpaceship class spaceshipType,'Life_',aSpaceship paint).
	
	aSpriteRenderer
		renderRectangle: texture
		transform: (TOMUtils
			matrixForTranslate: aPosition
			scale: 1 @ 1
			rotation: aSpaceship angle
			around: texture extent / 2)
		color: Color white
		scale: texture extent
		textureRegion: texture region
]
