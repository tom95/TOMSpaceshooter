"
A TOMWarpEngine is a concrete item.

It will propell the user forwards, dealing damage on the way and ignoring damage dealt to the user.
"
Class {
	#name : #TOMWarpEngine,
	#superclass : #TOMUpgradableItem,
	#instVars : [
		'duration',
		'remainingDuration',
		'speedBoost',
		'pushDamage'
	],
	#category : #TOMSpaceShooter
}

{ #category : #updating }
TOMWarpEngine >> activate: aSpaceship [
	| direction manager texture |
	self inCooldown ifTrue: [^self].
	
	super activate: aSpaceship.
	
	aSpaceship
		setActivateShield: self;
		pushDamage: pushDamage;
		setVelocityBoost: speedBoost.
	
	remainingDuration := duration.
	
	" basically the halo effect, (TOMUtils>>spawnSmallHalo:color:velocity:in:) except inverse "
	manager := aSpaceship scene particleManager.
	texture := aSpaceship assetFactory getTexture: 'extra/particle_line'.
	
	100 timesRepeat: [
		direction := TOMUtils randomVector: (TOMUtils randomPreferHigh: 30.0).
		
		(manager createParticle: texture)
			position: aSpaceship center + (direction * 15);
			angle: (TOMUtils angleForVector: direction) + Float halfPi;
			scale: 1 @ 6;
			color: (Color white);
			duration: 0.5;
			velocity: direction negated;
			varyWithSpeed: false ]
]

{ #category : #updating }
TOMWarpEngine >> cooldown [
	^1
]

{ #category : #accessing }
TOMWarpEngine >> description [
	^'Propels your spaceship forward at higher speed for a short time'
]

{ #category : #accessing }
TOMWarpEngine >> displayIconFile [
	^'Power-ups/bolt_bronze'
]

{ #category : #'initialize-release' }
TOMWarpEngine >> initialize [
	super initialize.
	
	speedBoost := 3000.
	duration := 0.2.
	pushDamage := 60.
	remainingDuration := 0
]

{ #category : #accessing }
TOMWarpEngine >> reduceDamage: damage [
	^0
]

{ #category : #updating }
TOMWarpEngine >> removedFrom: aSpaceship [
	super removedFrom: aSpaceship.
	
	aSpaceship
		setVelocityBoost: 0;
		pushDamage: 0;
		setActivateShield: nil.
	
	remainingDuration := 0.
	
	aSpaceship ifNotAliveDo: [^self].
	
	TOMUtils spawnSmallHalo: aSpaceship center color: Color white velocity: 30 in: aSpaceship scene
]

{ #category : #accessing }
TOMWarpEngine >> title [
	^'Warp Engine'
]

{ #category : #updating }
TOMWarpEngine >> update: dt for: spaceship [
	super update: dt for: spaceship.
	
	remainingDuration > 0 ifTrue: [
		remainingDuration := remainingDuration - dt.
		remainingDuration <= 0 ifTrue: [ self removedFrom: spaceship ]]
]

{ #category : #upgrading }
TOMWarpEngine >> upgrade [
	super upgrade.
	
	duration := duration * 1.1.
	pushDamage := pushDamage * 1.1
]
