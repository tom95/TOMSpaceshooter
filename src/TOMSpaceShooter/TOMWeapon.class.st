"
A TOMWeapon is a concrete item.

TOMWeapon is an activator for our projectiles. Every TOMWeapon has a projectileClass, which it will call upon activate:.
"
Class {
	#name : #TOMWeapon,
	#superclass : #TOMUpgradableItem,
	#instVars : [
		'projectileClass',
		'speedMultiplier',
		'damageMultiplier',
		'cooldown'
	],
	#category : #TOMSpaceShooter
}

{ #category : #updating }
TOMWeapon >> activate: aSpaceship [
	" launches a projectile from the given spaceship. Returns true on success and false otherwise "
	
	self inCooldown ifFalse: [
		super activate: aSpaceship.
		
		1 to: 2 do: [ :index |
			aSpaceship scene addToGame:
				((projectileClass newWith: aSpaceship assetFactory)
					upgradeInfo: self;
					launchHere: (aSpaceship rectangle corners at: index)
					inDirection: aSpaceship angle
					withVelocity: aSpaceship velocity
					owner: aSpaceship;
					yourself) ].
			^true ].
	^false
]

{ #category : #updating }
TOMWeapon >> cooldown [
	^cooldown
]

{ #category : #accessing }
TOMWeapon >> damage [
	^damageMultiplier
]

{ #category : #accessing }
TOMWeapon >> description [ 
	^projectileClass description
]

{ #category : #accessing }
TOMWeapon >> displayIconFile [
	^projectileClass displayIconFile
]

{ #category : #'initialize-release' }
TOMWeapon >> initialize [
	super initialize.
	
	speedMultiplier := 1.
	damageMultiplier := 1.
]

{ #category : #accessing }
TOMWeapon >> projectileClass [
	^projectileClass
]

{ #category : #accessing }
TOMWeapon >> projectileClass: aProjectileClass [
	projectileClass := aProjectileClass.
	
	cooldown := projectileClass baseCooldown
]

{ #category : #accessing }
TOMWeapon >> speed [
	^speedMultiplier
]

{ #category : #accessing }
TOMWeapon >> title [
	^self projectileClass title
]

{ #category : #upgrading }
TOMWeapon >> upgrade [
	super upgrade.
	
	cooldown := TOMUtils upgrade: self projectileClass cooldown: cooldown.
	damageMultiplier := damageMultiplier + (damageMultiplier / 8).
	speedMultiplier := speedMultiplier * 1.1
]
