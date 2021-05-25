Extension { #name : #TOMSprite }

{ #category : #'*TOMSpaceshooter-collision-dispatch' }
TOMSprite >> collidedWithAnchor: anAnchor [
]

{ #category : #'*TOMSpaceshooter-collision-dispatch' }
TOMSprite >> collidedWithBurningMeteor: aBurningMeteor [
]

{ #category : #'*TOMSpaceshooter-collision-dispatch' }
TOMSprite >> collidedWithCollectable: aCollectable [
]

{ #category : #'*TOMSpaceshooter-collision-dispatch' }
TOMSprite >> collidedWithMeteor: aMeteor [
]

{ #category : #'*TOMSpaceshooter-collision-dispatch' }
TOMSprite >> collidedWithProjectile: aProjectile [
]

{ #category : #'*TOMSpaceshooter-collision-dispatch' }
TOMSprite >> collidedWithSpaceship: aSpaceship [
]

{ #category : #'*TOMSpaceshooter-collision-dispatch' }
TOMSprite >> collidedWithTurret: aTurret [
]

{ #category : #'*TOMSpaceshooter-testing' }
TOMSprite >> isDestructibleObstacle [
	" answer if this sprite is an obstable for the player that may be destroyed by him "
	^false
]

{ #category : #'*TOMSpaceshooter-testing' }
TOMSprite >> isTradePartner [
	" answer if this sprite may be used for trading with the player "
	^false
]

{ #category : #'*TOMSpaceshooter-minimap' }
TOMSprite >> miniMapColor [
	" answer nil to not appear on the map "
	^nil
]
