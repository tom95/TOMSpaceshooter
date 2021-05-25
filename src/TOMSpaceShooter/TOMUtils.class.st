"
A TOMUtils is a utensil class. We use it for general-use functions that squeak lacks. 
The wide majority of these functions is not easily integratable as a member-function of a built-in class, so the decision was made to avoid extending built-in classes altogether. 
"
Class {
	#name : #TOMUtils,
	#superclass : #Object,
	#category : #TOMSpaceShooter
}

{ #category : #alliances }
TOMUtils class >> alliances [
	^{
		#neutral -> #(player).
		#player -> #(neutral)
	} as: Dictionary
]

{ #category : #geometry }
TOMUtils class >> angleForVector: vector [
	" just calls vector theta and moves to our coordinate system "
	^self normalizeAngle: Float twoPi - vector theta
]

{ #category : #'separating-axis-theorem' }
TOMUtils class >> angleFrom: sourcePoint to: destPoint [
	^ (sourcePoint x - destPoint x) arcTan: 
	  (sourcePoint y - destPoint y)
]

{ #category : #'separating-axis-theorem' }
TOMUtils class >> calculateEdgeNormals: shape [
	| edgeNormals |
	edgeNormals := Array new: shape size.
	
	1 to: shape size do: [ :index |
			edgeNormals at: index put:
				((shape at: index) - (shape at: (index = shape size ifTrue: [1] ifFalse: [index + 1]))) leftRotated ].
	
	^edgeNormals
]

{ #category : #'separating-axis-theorem' }
TOMUtils class >> calculateMinMaxProjectionValues: shape normal: normal [
	| min max new |
	
	min := max := ((shape at: 1) dotProduct: normal).
		
	2 to: shape size do: [ :cornerIndex |
		new := (shape at: cornerIndex) dotProduct: normal.
		new < min ifTrue: [min := new].
		new > max ifTrue: [max := new]].
	
	^{min. max}
]

{ #category : #geometry }
TOMUtils class >> closestObject: objects to: position [
	| closest closestDistance distance |
	objects ifEmpty: [^nil].
	
	closest := objects first.
	closestDistance := position squaredDistanceTo: closest position.
	
	objects allButFirstDo: [ :object |
		distance := position squaredDistanceTo: object position.
		distance < closestDistance ifTrue: [ closestDistance := distance. closest := object ]].
	
	^closest
]

{ #category : #geometry }
TOMUtils class >> containedInLocalRect: extent point: point [
	" checks if the point is within the rect given by `0 @ 0 extent: extent` "
	 ^point x >= 0 and: [point y >= 0 and: [point x < extent x and: [point y < extent y]]]
]

{ #category : #geometry }
TOMUtils class >> differenceAngle: fromAngle to: toAngle [
	| delta |
	delta := (fromAngle - toAngle) abs.
	^Float twoPi - delta min: delta
]

{ #category : #geometry }
TOMUtils class >> interpolateAngleFrom: start to: end at: amount [
	"Interpolates angle while taking the shortest path to where you want to look. Assumes normalized angles [0;2pi] "
	| a b |
	a := start.
	b := end.
	
	(a - b) abs > Float pi ifTrue: [
		a > b
			ifTrue: [ a := a - Float twoPi. ]
			ifFalse: [ b := b - Float twoPi. ]].

	^a + ((b - a) * amount)
]

{ #category : #alliances }
TOMUtils class >> isAlly: aSprite with: otherSprite [
	(otherSprite fraction isNil or: [aSprite fraction isNil]) ifTrue: [^false].
	
	^aSprite fraction = otherSprite fraction or:
		[(self alliances at: aSprite fraction
			ifPresent: [ :list | list includes: otherSprite fraction ]
			ifAbsent: [false])]
]

{ #category : #alliances }
TOMUtils class >> isEnemy: aSprite for: ownSprite [
	^self isEnemy: aSprite for: ownSprite ignoreAlliances: false
]

{ #category : #alliances }
TOMUtils class >> isEnemy: aSprite for: ownSprite ignoreAlliances: aBoolean [
	^aSprite notNil and:
		[aSprite alive and:
		[aSprite fraction notNil and:
		[aSprite fraction ~= ownSprite fraction and:
		[aBoolean or: [(self isAlly: aSprite with: ownSprite) not ]]]]]
]

{ #category : #geometry }
TOMUtils class >> length: aPoint [
	^(aPoint x squared + aPoint y squared) sqrt
]

{ #category : #geometry }
TOMUtils class >> matrixForTranslate: translate scale: scale rotation: angle around: centerOfRotation [
	| matrix a c cos sin |
	matrix := Matrix4x4 new.
	
	cos := angle cos.
	sin := angle sin.
	a := translate + centerOfRotation.
	c := centerOfRotation negated.
	
	" composite transform of
			translate(position+centerOfRotation),
			rotate(angle)
			translate(-centerOfRotation)
			scale(scale) "
	
	^matrix
		a11: scale x * cos;
		a12: scale x * sin negated;
		a21: scale y * sin;
		a22: scale y * cos;
		a41: (c x * cos) + (c y * sin) + a x;
		a42: (c x * sin negated) + (c  y * cos) + a y;
		a33: 1.0;
		a44: 1.0
]

{ #category : #geometry }
TOMUtils class >> minMaxCoordinates: anArrayOfPoints [
	| min max |
	
	min := max := anArrayOfPoints first.
	
	anArrayOfPoints allButFirstDo: [ :point |
		point x < min x ifTrue: [ min := point x @ min y ].
		point y < min y ifTrue: [ min := min x @ point y ].
		
		point x > max x ifTrue: [ max := point x @ max y ].
		point y > max y ifTrue: [ max := max x @ point y ]].
	
	^{min. max}
]

{ #category : #geometry }
TOMUtils class >> normalizeAngle: angle [
	" returns the given angle in radians normalized to an interval of [0;2PI] "
	
	" algorithm found here: http://commons.apache.org/proper/commons-math/apidocs/src-html/org/apache/commons/math3/util/MathUtils.html "
	^angle - (Float twoPi * ((angle + Float pi - Float pi) / Float twoPi) floor)
]

{ #category : #geometry }
TOMUtils class >> objectsInConeStartPoint: start startWidth: startWidth angle: angle endWidth: endWidth distance: distance in: aScene select: aBlock [
	| cone coneCenterTip minMax perpendicularVector |
	coneCenterTip := start + (TOMUtils vectorForAngle: angle length: distance).
	
	perpendicularVector := TOMUtils vectorForAngle: angle + Float halfPi length: 1.
	
	cone := Array
		with: coneCenterTip + (perpendicularVector * endWidth / 2)
		with: coneCenterTip - (perpendicularVector * endWidth / 2)
		with: start + (perpendicularVector * startWidth / 2)
		with: start - (perpendicularVector * startWidth / 2).
	
	minMax := TOMUtils minMaxCoordinates: cone.
	
	^aScene spatialHash
		allInArea: (Rectangle left: minMax first x right: minMax second x top: minMax first y bottom: minMax second y) 
		select: [ :object | (aBlock value: object) and: [(TOMUtils shape: object rectangle corners intersects: cone)] ]
]

{ #category : #geometry }
TOMUtils class >> pointGridHash: point [
	" Szudzik's pair function, maps two (signed) Integers to one "
	| x y |
	x := point x >= 0 ifTrue: [ 2 * point x ] ifFalse: [ -2 * point x - 1 ].
	y := point y >= 0 ifTrue: [ 2 * point y ] ifFalse: [ -2 * point y - 1 ].
	^ x >= y ifTrue: [ x * x + x + y ] ifFalse: [ x + (y * y) ]
]

{ #category : #random }
TOMUtils class >> randomAngle [
	^TOMUtils randomFloatFrom: 0 to: Float twoPi
]

{ #category : #random }
TOMUtils class >> randomFloatFrom: start to: end [
	" returns a random float within the range of [start;end]. start<end must be true. "
	^ start + ((end - start) * ThreadSafeRandom value next)
]

{ #category : #random }
TOMUtils class >> randomPreferHigh: max [
	^1.0 - (1.0 / (TOMUtils randomFloatFrom: 0 to: 10.0)) * max
]

{ #category : #random }
TOMUtils class >> randomVector: length [
	" returns a random vector (point) with the given length "
	^self
		vectorForAngle: (Float twoPi * ThreadSafeRandom value next)
		length: length
]

{ #category : #random }
TOMUtils class >> randomVectorFrom: minLength to: maxLength [
	" returns a random vector (point) within the given length "
	^self
		vectorForAngle: (Float twoPi * ThreadSafeRandom value next)
		length: (TOMUtils randomFloatFrom: minLength to: maxLength)
]

{ #category : #geometry }
TOMUtils class >> scaleForSize: childSize into: parentSize [
	^parentSize x / childSize x min: parentSize y / childSize y
]

{ #category : #'separating-axis-theorem' }
TOMUtils class >> shape: shapeA intersects: shapeB [
	" takes two convex shapes denoted by their corner points and determines whether they intersect "
	| edgeNormalsA edgeNormalsB minMaxA minMaxB |
	
	edgeNormalsA := self calculateEdgeNormals: shapeA.
	edgeNormalsB := self calculateEdgeNormals: shapeB.
	
	edgeNormalsA,edgeNormalsB do: [ :normal |
		minMaxA := self calculateMinMaxProjectionValues: shapeA normal: normal.
		minMaxB := self calculateMinMaxProjectionValues: shapeB normal: normal.
		
		(minMaxA second < minMaxB first or: [minMaxB second < minMaxA first]) ifTrue: [^false]].

	^true
]

{ #category : #geometry }
TOMUtils class >> shortestDirectionFrom: fromAngle to: toAngle [
	" answers the direction (#left or #right) needed to get closer to the given angle "
	| left source dest |
	source := TOMUtils normalizeAngle: fromAngle.
	dest := TOMUtils normalizeAngle: toAngle.
	
	left := source < dest.
	
	" if we have to move more that 180° (PI), the other way around is faster "
	(source - dest) abs > Float pi ifTrue: [ left := left not ].

	left
		ifTrue: [ ^#left ]
		ifFalse: [ ^#right ]
]

{ #category : #effects }
TOMUtils class >> spawn: aNumber sparksAt: aPosition angle: anAngle color: aColor in: aScene [
	| texture manager direction |
	manager := aScene particleManager.
	texture := aScene assetFactory getTexture: 'extra/particle_line'.
	
	aNumber timesRepeat: [
		direction := (TOMUtils vectorForAngle: anAngle length: 10.0) +
			(TOMUtils randomVector: (TOMUtils randomPreferHigh: 1.5)).
		
		(manager createParticle: texture)
			position: aPosition;
			angle: anAngle;
			color: aColor;
			duration: 0.6;
			velocity: direction ]
]

{ #category : #effects }
TOMUtils class >> spawnDefaultSparksAt: aPosition angle: anAngle in: aScene [
	self 
		spawn: 8
		sparksAt: aPosition
		angle: anAngle
		color: Color orange 
		in: aScene 
]

{ #category : #effects }
TOMUtils class >> spawnDefaultTrailAt: aPosition angle: anAngle in: aScene [
	self spawnTrailAt: aPosition angle: anAngle color: Color orange in: aScene
]

{ #category : #effects }
TOMUtils class >> spawnHalo: aPosition color: aColor velocity: aVelocity in: aScene [
	| direction texture |
	texture := aScene assetFactory getTexture: 'extra/particle_line'.
	
	100 timesRepeat: [
		direction := TOMUtils randomVector: (TOMUtils randomPreferHigh: aVelocity).
		
		(aScene particleManager createParticle: texture)
			position: aPosition;
			angle: (TOMUtils angleForVector: direction) + Float halfPi;
			scale: 1 @ 6;
			color: aColor;
			lengthMultiplier: 5.0;
			duration: 3;
			velocity: direction ]
]

{ #category : #effects }
TOMUtils class >> spawnSmallHalo: aPosition color: aColor velocity: aVelocity in: aScene [
	| direction texture |
	texture := aScene assetFactory getTexture: 'extra/particle_line'.
	
	30 timesRepeat: [
		direction := TOMUtils randomVector: (TOMUtils randomPreferHigh: aVelocity).
		
		(aScene particleManager createParticle: texture)
			position: aPosition;
			angle: (TOMUtils angleForVector: direction) + Float halfPi;
			scale: 1 @ 6;
			color: aColor;
			lengthMultiplier: 5.0;
			duration: 0.6;
			velocity: direction;
			varyWithSpeed: false ]
]

{ #category : #effects }
TOMUtils class >> spawnTrailAt: aPosition angle: anAngle color: aColor in: aScene [
	self spawnTrailAt: aPosition angle: anAngle color: aColor scale: 0.7 asPoint in: aScene
]

{ #category : #effects }
TOMUtils class >> spawnTrailAt: aPosition angle: anAngle color: aColor scale: aScale in: aScene [
	2 timesRepeat: [
		(aScene particleManager createParticle: (aScene assetFactory getTexture: 'extra/particle_round'))
			position: aPosition;
			scale: aScale asPoint;
			color: aColor;
			duration: 0.4;
			velocity: (TOMUtils vectorForAngle: anAngle length: -3) + (TOMUtils randomVector: 1.0);
			lengthMultiplier: 0;
			varyWithSpeed: true ]
]

{ #category : #geometry }
TOMUtils class >> translationMatrixForPoint: aPoint [
	^Matrix4x4 identity translationX: aPoint x y: aPoint y z: 0
]

{ #category : #upgrading }
TOMUtils class >> upgrade: aProjectileClass cooldown: aTime [
	| cooldown |
	
	cooldown := aTime.
	aProjectileClass hasUpgradableCooldown ifFalse: [ ^aTime ].
	^(aTime * 0.9 < 0.1 
		ifTrue: [ cooldown * 0.9 ] 
		ifFalse: [ cooldown - 0.05 ]) max: 1 / 60.0
]

{ #category : #geometry }
TOMUtils class >> vectorForAngle: angle length: length [
	" returns a vector pointing to the given angle scaled by length "
	| angleLocal |
	" our coordinate system is a bit different than your typical math coordinate system. rotating by 270° (3pi/2) gets us there. "
	angleLocal := Float halfPi * 3 - angle.
	^(angleLocal cos * length) @ (angleLocal sin * length)
]
