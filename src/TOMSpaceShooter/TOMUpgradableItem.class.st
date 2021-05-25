"
A TOMUpgradableItem is the abstract template for inventory items of spaceships.

Items are activated by the spaceship slots they're in. In turn, they usually activate a weapon or some other ability.
"
Class {
	#name : #TOMUpgradableItem,
	#superclass : #Object,
	#instVars : [
		'level',
		'counterUntilReuse'
	],
	#category : #TOMSpaceShooter
}

{ #category : #updating }
TOMUpgradableItem >> activate: spaceship [
	" activates the attribute, which makes it cooldown start counting "
	counterUntilReuse := self cooldown
]

{ #category : #updating }
TOMUpgradableItem >> cooldown [
	" time until an attribute may be activated again after use "
	^0
]

{ #category : #accessing }
TOMUpgradableItem >> description [
	^'Missing description'
]

{ #category : #accessing }
TOMUpgradableItem >> displayIconFile [
	^'Power-ups/things_bronze'
]

{ #category : #accessing }
TOMUpgradableItem >> inCooldown [
	" answers whether the attribute is currently on cooldown and thus may not be used "
	^counterUntilReuse > 0.0
]

{ #category : #'initialize-release' }
TOMUpgradableItem >> initialize [
	level := 1.
	counterUntilReuse := 0
]

{ #category : #accessing }
TOMUpgradableItem >> level [
	^level
]

{ #category : #updating }
TOMUpgradableItem >> removedFrom: spaceship [
]

{ #category : #updating }
TOMUpgradableItem >> timeUntilUsePercent [
	" returns the percentage of the time until reuse. 1 means the item is ready "
	counterUntilReuse = 0 ifTrue: [ ^1 ].
	
	^(self cooldown - (counterUntilReuse max: 0)) / self cooldown
]

{ #category : #accessing }
TOMUpgradableItem >> title [
	^'Item'
]

{ #category : #updating }
TOMUpgradableItem >> update: dt for: spaceship [
	counterUntilReuse > 0 ifTrue: [
		counterUntilReuse := counterUntilReuse - dt ]
]

{ #category : #upgrading }
TOMUpgradableItem >> upgrade [
	level := level + 1
]

{ #category : #upgrading }
TOMUpgradableItem >> upgradeCost [
	^(50 * (self level raisedTo: 1.2)) truncated 
	
]
