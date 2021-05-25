"
A TOMValuableMeteor inherits the behavior from the big meteor, except it has a number of life points before it dies and spawns coins.
"
Class {
	#name : #TOMValuableMeteor,
	#superclass : #TOMMeteorBig,
	#instVars : [
		'lifePoints',
		'stationary'
	],
	#category : #TOMSpaceShooter
}

{ #category : #collision }
TOMValuableMeteor >> collidedWithProjectile:  aProjectile [
		lifePoints := lifePoints - aProjectile damage.
		lifePoints < 0 ifTrue: [ self die ]
]

{ #category : #collision }
TOMValuableMeteor >> damage [
	^200
]

{ #category : #'initialize-release' }
TOMValuableMeteor >> die [
	self scene ifNotNil: [
		self scene addToGame:
			((TOMCoin newWith: self assetFactory)
				positionInCenterOfSprite: self;
				yourself)].
	super die
]

{ #category : #'initialize-release' }
TOMValuableMeteor >> initialize [ 
	super initialize.
	lifePoints := self maxLifePoints.
	stationary := false
]

{ #category : #'initialize-release' }
TOMValuableMeteor >> maxLifePoints [
	^100
]

{ #category : #'initialize-release' }
TOMValuableMeteor >> miniMapColor [ 
	^Color r: 0.8 g: 0.6 b: 0
]

{ #category : #'initialize-release' }
TOMValuableMeteor >> sprites [
	^#(#'Meteors/meteorGrey_big1'
		#'Meteors/meteorGrey_big2'
		#'Meteors/meteorGrey_big3'
		#'Meteors/meteorGrey_big4')
]

{ #category : #accessing }
TOMValuableMeteor >> stationary [
	^stationary
]

{ #category : #accessing }
TOMValuableMeteor >> stationary: aBoolean [
	stationary := aBoolean
]
