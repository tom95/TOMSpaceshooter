"
A TOMPhysicsManager is responsbile for triggering physics updates on all necessary objects and then checking where collisions occured and informing the sprites of those.

Instance Variables
	dt:		<Float>
	lastTimeFrame:		<Integer>

dt
	- delta of time since last frame drawn

lastTimeFrame
	- Time at which last frame started rendering

"
Class {
	#name : #TOMPhysicsManager,
	#superclass : #Object,
	#instVars : [
		'lastTimeFrame',
		'dt'
	],
	#category : #TOMGameEngine
}

{ #category : #collision }
TOMPhysicsManager >> checkCollisions: aScene [
	aScene spatialHash allProximalPairsDo: [ :spriteA :spriteB |
		(spriteA isCollider and:
		[spriteB isCollider and:
		[spriteA alive and:
		[spriteB alive and:
		[spriteA collisionGroup ~~ spriteB collisionGroup and:
		[spriteA rectangle intersects: spriteB rectangle]]]]])
	 ifTrue: [
			spriteA collided: spriteB.
			spriteB collided: spriteA ]]
]

{ #category : #accessing }
TOMPhysicsManager >> currentDeltaTime [
	^dt
]

{ #category : #'initialize-release' }
TOMPhysicsManager >> initialize [ 
	super initialize.
	lastTimeFrame := Time millisecondClockValue
]

{ #category : #accessing }
TOMPhysicsManager >> lastTimeFrame [
	^lastTimeFrame
]

{ #category : #accessing }
TOMPhysicsManager >> lastTimeFrame: aTime [
	" set the timestamp of the last frame considered for deltaTime calculation (required for pause/play) "
	lastTimeFrame := aTime
]

{ #category : #stepping }
TOMPhysicsManager >> physicsStep: aScene paused: paused [
	| timeNow |

	timeNow := Time millisecondClockValue.
	dt := (timeNow - lastTimeFrame) / 1000.0.
	lastTimeFrame := timeNow.
	
	paused ifFalse: [ self sceneGameUpdate: aScene ].
	aScene overlayLayerDo: [ :obj | obj update: dt ].
	
	TOMGame benchmark report: #Collision time: [
		TOMGame collisionsEnabled ifTrue: [ self checkCollisions: aScene ]] timeToRun
]

{ #category : #stepping }
TOMPhysicsManager >> sceneGameUpdate: aScene [
	TOMGame benchmark
		report: #Physics
		time: [
			aScene
				gameLayerDo: [ :sprite | sprite ifAliveDo: [ sprite physicsStep: dt ]];
				updateDelayedActions: dt.
			
			aScene particleManager physicsStep: dt.
			aScene camera update: dt.
			aScene gameLayerDo: [ :sprite | sprite ifAliveDo: [ sprite postPhysicsStep: dt ]]] timeToRun;
		
		report: #'Spatial Hash'
		time: [ aScene updateSpatialHash ] timeToRun 
]
