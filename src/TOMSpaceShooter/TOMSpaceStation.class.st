"
A TOMSpaceStation is the ingame shop. A player can approach it and access the shop scene.

"
Class {
	#name : #TOMSpaceStation,
	#superclass : #TOMSprite,
	#category : #TOMSpaceShooter
}

{ #category : #'initialize-release' }
TOMSpaceStation >> initialize [
	super initialize.
	
	self file: #'shop/shop03'
]

{ #category : #'initialize-release' }
TOMSpaceStation >> isTradePartner [
	^true
]

{ #category : #'initialize-release' }
TOMSpaceStation >> miniMapColor [
	^Color blue
]
