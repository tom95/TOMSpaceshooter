"
A TOMRectangle is an oriented rectangle, as opposed to Squeaks default Rectangle class of which most opperations only work for axis-aligned rectangles. It largely tries to mimic its interface in order to be a drop-in replacement.

Concerning the naming, this class represents an actual arbitrary rectangle, thus deserving the name. The one from squeak on the other hand is not as appropriately named, as shown before. A more descriptive name could have been AARectangle/AxisAlignedRectangle or similar.
"
Class {
	#name : #TOMRectangle,
	#superclass : #Object,
	#instVars : [
		'topLeft',
		'topRight',
		'bottomLeft',
		'bottomRight'
	],
	#category : #TOMGameEngine
}

{ #category : #'instance creation' }
TOMRectangle class >> empty [
	^ self new
		topLeft: 0 asPoint;
		topRight: 0 asPoint;
		bottomRight: 0 asPoint;
		bottomLeft: 0 asPoint;
		yourself
]

{ #category : #'instance creation' }
TOMRectangle class >> fromPoints: anArray [
	^ self new
		topLeft: anArray first;
		topRight: anArray second;
		bottomRight: anArray third;
		bottomLeft: anArray fourth;
		yourself
]

{ #category : #'instance creation' }
TOMRectangle class >> origin: originPoint corner: cornerPoint [
	^ self new
		topLeft: originPoint;
		topRight: cornerPoint x @ originPoint y;
		bottomRight: cornerPoint;
		bottomLeft: originPoint x @ cornerPoint y;
		yourself
]

{ #category : #'instance creation' }
TOMRectangle class >> origin: originPoint extent: extentPoint [
	^ self new
		topLeft: originPoint;
		topRight: originPoint + (extentPoint x @ 0);
		bottomRight: originPoint + extentPoint;
		bottomLeft: originPoint + (0 @ extentPoint y);
		yourself
]

{ #category : #'instance creation' }
TOMRectangle class >> topLeft: topLeftPoint topRight: topRightPoint bottomRight: bottomRightPoint bottomLeft: bottomLeftPoint [
	^ self new
		topLeft: topLeftPoint;
		topRight: topRightPoint;
		bottomRight: bottomRightPoint;
		bottomLeft: bottomLeftPoint;
		yourself
]

{ #category : #'instance creation' }
TOMRectangle class >> unitSquare [
	^ self origin: 0 asPoint corner: 1 asPoint
]

{ #category : #accessing }
TOMRectangle >> asAxisAligned [
	" calculates the axlis aligned rectangle that contains this rectangle "
	| extents |
	extents := TOMUtils minMaxCoordinates: self corners.
	^TOMRectangle origin: extents first corner: extents second
]

{ #category : #accessing }
TOMRectangle >> bottomCenter [
	^self bottomLeft interpolateTo: self bottomRight at: 0.5
]

{ #category : #accessing }
TOMRectangle >> bottomLeft [
	^bottomLeft
]

{ #category : #accessing }
TOMRectangle >> bottomLeft: aPoint [
	bottomLeft := aPoint
]

{ #category : #accessing }
TOMRectangle >> bottomRight [
	^bottomRight
]

{ #category : #accessing }
TOMRectangle >> bottomRight: aPoint [
	bottomRight := aPoint
]

{ #category : #accessing }
TOMRectangle >> center [
	^self topCenter interpolateTo: self bottomCenter at: 0.5
]

{ #category : #geometry }
TOMRectangle >> containsPoint: aPoint [
	| top topDot right rightDot |
	top := self topRight - self topLeft.
	topDot := top dotProduct: aPoint - self topLeft.
	
	(0 <= topDot and: [topDot <= (top dotProduct: top)]) ifFalse: [^false].
	
	right := self bottomRight - self topRight.
	rightDot := right dotProduct: aPoint - self topRight.
	
	^0 <= rightDot and: [rightDot <= (right dotProduct: right)]
]

{ #category : #geometry }
TOMRectangle >> corners [
	^{ self topLeft. self topRight. self bottomRight. self bottomLeft }
]

{ #category : #geometry }
TOMRectangle >> extent [
	^self topLeft y = self topRight y
		ifTrue: [((self topRight  x - self topLeft x) @ (self bottomLeft y - self topLeft y)) abs]
		ifFalse: [(self topLeft dist: self topRight) @ (self topLeft dist: bottomLeft)]
]

{ #category : #geometry }
TOMRectangle >> intersects: otherRectangle [
	| aVectorX aVectorY bVectorX bVectorY minA maxA minB maxB vectors newA newB |
	" OBB collision detection. This code is (more or less) duplicated from TOMUtils>>shape:intersects:
	  because we can do considerable optimizations when we need to test rectangles as opposed to
	  arbitrary shapes. This code runs about twice as fast for the same set of inputs. "
	
	aVectorY := self topLeft - self topRight.
	aVectorX := self topRight - self bottomRight.
	
	bVectorY := otherRectangle topLeft - otherRectangle topRight.
	bVectorX := otherRectangle topRight - otherRectangle bottomRight.
	
	vectors := Array with: aVectorY with: aVectorX with: bVectorY with: bVectorX. 
	
	vectors detect: [ :vector |
		minA :=  self topLeft dotProduct: vector.
		maxA := minA.
		2 to: 4 do: [ :corner |
			newA := (self corners at: corner) dotProduct: vector.
			newA < minA ifTrue: [minA := newA].
			newA > maxA ifTrue: [maxA := newA]].
		
		minB := otherRectangle topLeft dotProduct: vector.
		maxB := minB.
		2 to: 4 do: [ :corner |
			newB := (otherRectangle corners at: corner) dotProduct: vector.
			newB < minB ifTrue: [minB := newB].
			newB > maxB ifTrue: [maxB := newB]].
		
		(maxA < minB or: [maxB < minA])] ifNone: [^true].
	
	^false
]

{ #category : #accessing }
TOMRectangle >> topCenter [
	^self topLeft interpolateTo: self topRight at: 0.5
]

{ #category : #accessing }
TOMRectangle >> topLeft [
	^topLeft
]

{ #category : #accessing }
TOMRectangle >> topLeft: aPoint [
	topLeft := aPoint
]

{ #category : #accessing }
TOMRectangle >> topRight [
	^topRight
]

{ #category : #accessing }
TOMRectangle >> topRight: aPoint [
	topRight := aPoint
]
