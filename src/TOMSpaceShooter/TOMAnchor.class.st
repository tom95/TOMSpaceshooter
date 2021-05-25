"
A TOMAnchor is a valuable target for the player. It drops a number of coins upon being killed.
"
Class {
	#name : #TOMAnchor,
	#superclass : #TOMSprite,
	#instVars : [
		'lifePoints'
	],
	#category : #TOMSpaceShooter
}

{ #category : #'game-attributes' }
TOMAnchor class >> maxLifePoints [
	^1000
]

{ #category : #'initialize-release' }
TOMAnchor >> coinDropCount [
	^4
]

{ #category : #collision }
TOMAnchor >> collided: otherObject [
	otherObject collidedWithAnchor: self
]

{ #category : #collision }
TOMAnchor >> collidedWithProjectile: aProjectile [
	aProjectile owner fraction ~= self fraction ifTrue: [
		self triggerEvent: #attacked with: aProjectile owner.
		lifePoints := lifePoints - aProjectile damage.
		lifePoints < 0 ifTrue: [ self die ]]
]

{ #category : #'initialize-release' }
TOMAnchor >> die [	
	" spawn an explosion where we are, then delete ourselves "
	self triggerEvent: #destroyed.
	
	self scene ifNotNil: [
		self scene addToGame: ((TOMExplosion newWith: self assetFactory)
			matchDimensions: self).
		
		self coinDropCount timesRepeat: [
			self scene addToGame: ((TOMCoin newWith: self assetFactory)
				position: self position + (TOMUtils randomVectorFrom: -60 to: 60);
				yourself) ]].
	
	self delete
]

{ #category : #'initialize-release' }
TOMAnchor >> initialize [
	super initialize.
	
	self fraction: #neutral.
	lifePoints := self class maxLifePoints
]

{ #category : #collision }
TOMAnchor >> isCollider [ 
	^true
]

{ #category : #'initialize-release' }
TOMAnchor >> maxLifePoints [
	^10000
]

{ #category : #'initialize-release' }
TOMAnchor >> miniMapColor [
	^Color r: 0.4 g: 1 b: 0.3
]

{ #category : #physics }
TOMAnchor >> physicsStep: dt [
	super physicsStep: dt.
	self angle: self angle + dt.
]

{ #category : #alliances }
TOMAnchor >> requestTarget: aTarget [
]
