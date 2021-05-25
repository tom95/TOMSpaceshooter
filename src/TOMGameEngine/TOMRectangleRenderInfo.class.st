"
A TOMRectangleRenderInfo is container for rendering information used for batched draw calls in the external sprite renderer.
"
Class {
	#name : #TOMRectangleRenderInfo,
	#superclass : #ExternalStructure,
	#category : #TOMGameEngine
}

{ #category : #'class initialization' }
TOMRectangleRenderInfo class >> fields [
	^#(
		(modelTransform0	'float')
		(modelTransform1	'float')
		(modelTransform2	'float')
		(modelTransform3	'float')
		(modelTransform4	'float')
		(modelTransform5	'float')
		(modelTransform6	'float')
		(modelTransform7	'float')
		(modelTransform8	'float')
		(modelTransform9	'float')
		(modelTransform10	'float')
		(modelTransform11	'float')
		(modelTransform12	'float')
		(modelTransform13	'float')
		(modelTransform14	'float')
		(modelTransform15	'float')
		(scaleX			'float')
		(scaleY			'float')
		(red					'float')
		(green			'float')
		(blue				'float')
		(alpha			'float')
		(texcoordsOffset0 'float')
		(texcoordsOffset1 'float')
		(texcoordsOffset2 'float')
		(texcoordsOffset3 'float')
		(useTexture		'long'))
]

{ #category : #'class initialization' }
TOMRectangleRenderInfo class >> initialize [
	super initialize.
	self defineFields
]

{ #category : #accessing }
TOMRectangleRenderInfo >> alpha [
	"This method was automatically generated"
	^handle floatAt: 85
]

{ #category : #accessing }
TOMRectangleRenderInfo >> alpha: anObject [
	"This method was automatically generated"
	handle floatAt: 85 put: anObject
]

{ #category : #accessing }
TOMRectangleRenderInfo >> blue [
	"This method was automatically generated"
	^handle floatAt: 81
]

{ #category : #accessing }
TOMRectangleRenderInfo >> blue: anObject [
	"This method was automatically generated"
	handle floatAt: 81 put: anObject
]

{ #category : #accessing }
TOMRectangleRenderInfo >> green [
	"This method was automatically generated"
	^handle floatAt: 77
]

{ #category : #accessing }
TOMRectangleRenderInfo >> green: anObject [
	"This method was automatically generated"
	handle floatAt: 77 put: anObject
]

{ #category : #accessing }
TOMRectangleRenderInfo >> modelTransform [
	| matrix |
	matrix := Matrix4x4 new.
	
	1 to: 16 do: [ :index |
		matrix at: index put: (handle floatAt: (index - 1) * 4 + 1) ].
	
	^matrix
]

{ #category : #accessing }
TOMRectangleRenderInfo >> modelTransform0 [
	"This method was automatically generated"
	^handle floatAt: 1
]

{ #category : #accessing }
TOMRectangleRenderInfo >> modelTransform0: anObject [
	"This method was automatically generated"
	handle floatAt: 1 put: anObject
]

{ #category : #accessing }
TOMRectangleRenderInfo >> modelTransform1 [
	"This method was automatically generated"
	^handle floatAt: 5
]

{ #category : #accessing }
TOMRectangleRenderInfo >> modelTransform10 [
	"This method was automatically generated"
	^handle floatAt: 41
]

{ #category : #accessing }
TOMRectangleRenderInfo >> modelTransform10: anObject [
	"This method was automatically generated"
	handle floatAt: 41 put: anObject
]

{ #category : #accessing }
TOMRectangleRenderInfo >> modelTransform11 [
	"This method was automatically generated"
	^handle floatAt: 45
]

{ #category : #accessing }
TOMRectangleRenderInfo >> modelTransform11: anObject [
	"This method was automatically generated"
	handle floatAt: 45 put: anObject
]

{ #category : #accessing }
TOMRectangleRenderInfo >> modelTransform12 [
	"This method was automatically generated"
	^handle floatAt: 49
]

{ #category : #accessing }
TOMRectangleRenderInfo >> modelTransform12: anObject [
	"This method was automatically generated"
	handle floatAt: 49 put: anObject
]

{ #category : #accessing }
TOMRectangleRenderInfo >> modelTransform13 [
	"This method was automatically generated"
	^handle floatAt: 53
]

{ #category : #accessing }
TOMRectangleRenderInfo >> modelTransform13: anObject [
	"This method was automatically generated"
	handle floatAt: 53 put: anObject
]

{ #category : #accessing }
TOMRectangleRenderInfo >> modelTransform14 [
	"This method was automatically generated"
	^handle floatAt: 57
]

{ #category : #accessing }
TOMRectangleRenderInfo >> modelTransform14: anObject [
	"This method was automatically generated"
	handle floatAt: 57 put: anObject
]

{ #category : #accessing }
TOMRectangleRenderInfo >> modelTransform15 [
	"This method was automatically generated"
	^handle floatAt: 61
]

{ #category : #accessing }
TOMRectangleRenderInfo >> modelTransform15: anObject [
	"This method was automatically generated"
	handle floatAt: 61 put: anObject
]

{ #category : #accessing }
TOMRectangleRenderInfo >> modelTransform1: anObject [
	"This method was automatically generated"
	handle floatAt: 5 put: anObject
]

{ #category : #accessing }
TOMRectangleRenderInfo >> modelTransform2 [
	"This method was automatically generated"
	^handle floatAt: 9
]

{ #category : #accessing }
TOMRectangleRenderInfo >> modelTransform2: anObject [
	"This method was automatically generated"
	handle floatAt: 9 put: anObject
]

{ #category : #accessing }
TOMRectangleRenderInfo >> modelTransform3 [
	"This method was automatically generated"
	^handle floatAt: 13
]

{ #category : #accessing }
TOMRectangleRenderInfo >> modelTransform3: anObject [
	"This method was automatically generated"
	handle floatAt: 13 put: anObject
]

{ #category : #accessing }
TOMRectangleRenderInfo >> modelTransform4 [
	"This method was automatically generated"
	^handle floatAt: 17
]

{ #category : #accessing }
TOMRectangleRenderInfo >> modelTransform4: anObject [
	"This method was automatically generated"
	handle floatAt: 17 put: anObject
]

{ #category : #accessing }
TOMRectangleRenderInfo >> modelTransform5 [
	"This method was automatically generated"
	^handle floatAt: 21
]

{ #category : #accessing }
TOMRectangleRenderInfo >> modelTransform5: anObject [
	"This method was automatically generated"
	handle floatAt: 21 put: anObject
]

{ #category : #accessing }
TOMRectangleRenderInfo >> modelTransform6 [
	"This method was automatically generated"
	^handle floatAt: 25
]

{ #category : #accessing }
TOMRectangleRenderInfo >> modelTransform6: anObject [
	"This method was automatically generated"
	handle floatAt: 25 put: anObject
]

{ #category : #accessing }
TOMRectangleRenderInfo >> modelTransform7 [
	"This method was automatically generated"
	^handle floatAt: 29
]

{ #category : #accessing }
TOMRectangleRenderInfo >> modelTransform7: anObject [
	"This method was automatically generated"
	handle floatAt: 29 put: anObject
]

{ #category : #accessing }
TOMRectangleRenderInfo >> modelTransform8 [
	"This method was automatically generated"
	^handle floatAt: 33
]

{ #category : #accessing }
TOMRectangleRenderInfo >> modelTransform8: anObject [
	"This method was automatically generated"
	handle floatAt: 33 put: anObject
]

{ #category : #accessing }
TOMRectangleRenderInfo >> modelTransform9 [
	"This method was automatically generated"
	^handle floatAt: 37
]

{ #category : #accessing }
TOMRectangleRenderInfo >> modelTransform9: anObject [
	"This method was automatically generated"
	handle floatAt: 37 put: anObject
]

{ #category : #accessing }
TOMRectangleRenderInfo >> modelTransform: a4x4Matrix [
	1 to: 16 do: [ :index |
		handle floatAt: (index - 1) * 4 + 1 put: (a4x4Matrix at: index) ]
]

{ #category : #accessing }
TOMRectangleRenderInfo >> red [
	"This method was automatically generated"
	^handle floatAt: 73
]

{ #category : #accessing }
TOMRectangleRenderInfo >> red: anObject [
	"This method was automatically generated"
	handle floatAt: 73 put: anObject
]

{ #category : #accessing }
TOMRectangleRenderInfo >> scaleX [
	"This method was automatically generated"
	^handle floatAt: 65
]

{ #category : #accessing }
TOMRectangleRenderInfo >> scaleX: anObject [
	"This method was automatically generated"
	handle floatAt: 65 put: anObject
]

{ #category : #accessing }
TOMRectangleRenderInfo >> scaleY [
	"This method was automatically generated"
	^handle floatAt: 69
]

{ #category : #accessing }
TOMRectangleRenderInfo >> scaleY: anObject [
	"This method was automatically generated"
	handle floatAt: 69 put: anObject
]

{ #category : #accessing }
TOMRectangleRenderInfo >> texcoordsOffset [
	| array |
	array := FloatArray new: 4.
	
	1 to: 4 do: [ :index |
		array at: index put: (handle floatAt: (index - 1) * 4 + 89) ].
	
	^array
]

{ #category : #accessing }
TOMRectangleRenderInfo >> texcoordsOffset0 [
	"This method was automatically generated"
	^handle floatAt: 89
]

{ #category : #accessing }
TOMRectangleRenderInfo >> texcoordsOffset0: anObject [
	"This method was automatically generated"
	handle floatAt: 89 put: anObject
]

{ #category : #accessing }
TOMRectangleRenderInfo >> texcoordsOffset1 [
	"This method was automatically generated"
	^handle floatAt: 93
]

{ #category : #accessing }
TOMRectangleRenderInfo >> texcoordsOffset1: anObject [
	"This method was automatically generated"
	handle floatAt: 93 put: anObject
]

{ #category : #accessing }
TOMRectangleRenderInfo >> texcoordsOffset2 [
	"This method was automatically generated"
	^handle floatAt: 97
]

{ #category : #accessing }
TOMRectangleRenderInfo >> texcoordsOffset2: anObject [
	"This method was automatically generated"
	handle floatAt: 97 put: anObject
]

{ #category : #accessing }
TOMRectangleRenderInfo >> texcoordsOffset3 [
	"This method was automatically generated"
	^handle floatAt: 101
]

{ #category : #accessing }
TOMRectangleRenderInfo >> texcoordsOffset3: anObject [
	"This method was automatically generated"
	handle floatAt: 101 put: anObject
]

{ #category : #accessing }
TOMRectangleRenderInfo >> texcoordsOffset: anArray [
	1 to: 4 do: [ :index |
		handle floatAt: (index - 1) * 4 + 89 put: (anArray at: index) ]
]

{ #category : #accessing }
TOMRectangleRenderInfo >> unsignedByteAt: anIndex [
	^handle unsignedByteAt: anIndex
]

{ #category : #accessing }
TOMRectangleRenderInfo >> useTexture [
	"This method was automatically generated"
	^handle signedLongAt: 105
]

{ #category : #accessing }
TOMRectangleRenderInfo >> useTexture: anObject [
	"This method was automatically generated"
	handle signedLongAt: 105 put: anObject
]
