"
A TOMStateMachine is a versatile implementation of a state machine, providing event based, condition based and time based triggers.
"
Class {
	#name : #TOMStateMachine,
	#superclass : #Object,
	#instVars : [
		'conditionalTransitions',
		'signalTransitions',
		'enterActions',
		'leaveActions',
		'state',
		'timeTransitions'
	],
	#category : #TOMGameEngine
}

{ #category : #private }
TOMStateMachine >> ensureTriggerListsFor: aState [
	signalTransitions at: aState ifAbsentPut: [ Dictionary new ].
	conditionalTransitions at: aState ifAbsentPut: [ Dictionary new ].
	timeTransitions at: aState ifAbsentPut: [ Dictionary new ].
	leaveActions at: aState ifAbsentPut: [ OrderedCollection new ].
	enterActions at: aState ifAbsentPut: [ OrderedCollection new ]
]

{ #category : #transitions }
TOMStateMachine >> from: startState to: endState after: aDuration [
	" transition after spending `aDuration` in startState "
	(timeTransitions at: startState ifAbsentPut: [ Dictionary new ])
		at: endState
		put: {aDuration. aDuration}
]

{ #category : #transitions }
TOMStateMachine >> from: startState to: endState if: aBlock [
	" transition when aBlock becomes true "
	(conditionalTransitions at: startState ifAbsentPut: [ Dictionary new ])
		at: aBlock
		put: endState
]

{ #category : #transitions }
TOMStateMachine >> from: startState to: endState when: aSignal [
	" transition upon receiving a signal "
	(signalTransitions at: startState ifAbsentPut: [ Dictionary new ])
		at: aSignal
		put: endState
]

{ #category : #transitions }
TOMStateMachine >> fromAll: startStates to: endState after: aDuration [
	startStates do: [ :startState | self from: startState to: endState after: aDuration ]
]

{ #category : #transitions }
TOMStateMachine >> fromAll: startStates to: endState if: aBlock [
	startStates do: [ :startState | self from: startState to: endState if: aBlock ]
]

{ #category : #transitions }
TOMStateMachine >> fromAll: startStates to: endState when: aSignal [
	startStates do: [ :startState | self from: startState to: endState when: aSignal ]
]

{ #category : #initialization }
TOMStateMachine >> initialState: aState [
	state := aState.
	
	self ensureTriggerListsFor: state
]

{ #category : #initialization }
TOMStateMachine >> initialize [
	super initialize.
	
	signalTransitions := Dictionary new.
	conditionalTransitions := Dictionary new.
	timeTransitions := Dictionary new.
	
	enterActions := Dictionary new.
	leaveActions := Dictionary new
]

{ #category : #private }
TOMStateMachine >> resetTimeTransitionsFor: aState [
	(timeTransitions at: aState) keysAndValuesDo: [ :endState :time |
		time at: 1 put: time second ]
]

{ #category : #accessing }
TOMStateMachine >> state [
	^state
]

{ #category : #accessing }
TOMStateMachine >> state: newState [
	| oldState |
	
	oldState := self state.
	(leaveActions at: oldState) do: [ :action | action valueWithEnoughArguments: newState ].
	
	state := newState.
	self ensureTriggerListsFor: newState.
	self resetTimeTransitionsFor: newState.
	
	(enterActions at: self state) do: [ :action | action valueWithEnoughArguments: oldState ]
]

{ #category : #transitions }
TOMStateMachine >> tick: dt [
	" iterate over all active conditional and time transitions and check if they were triggered "
	| passedDuration |
	passedDuration := dt seconds.
	
	(conditionalTransitions at: self state) keysAndValuesDo: [ :conditionalBlock :endState |
		conditionalBlock value ifTrue: [ ^self state: endState ]].
	
	(timeTransitions at: self state) keysAndValuesDo: [ :endState :time |
		time at: 1 put: time first - passedDuration.
		time first negative ifTrue: [ ^self state: endState ]]
]

{ #category : #transitions }
TOMStateMachine >> trigger: aSignal [
	(signalTransitions at: self state) at: aSignal ifPresent: [ :endState |
		self state: endState ]
]

{ #category : #transitions }
TOMStateMachine >> uponEnter: aState do: aBlock [
	(enterActions at: aState ifAbsentPut: [ OrderedCollection new ]) add: aBlock
]

{ #category : #transitions }
TOMStateMachine >> uponLeave: aState do: aBlock [
	(leaveActions at: aState ifAbsentPut: [ OrderedCollection new ]) add: aBlock
]
