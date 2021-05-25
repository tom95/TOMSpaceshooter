"
A TOMUserInputHandler receives events from Squeak's EventSensor class and translates them to the appropriate TOMEvents. 

It emits the following events:
	- #mouseEvent: TOMMouseEvent
	- #keyboardEvent: TOMKeyboardEvent
	- #controllerEvent: TOMControllerEvent
	- #commandEvent: Symbol (via 'bindCommandMapping:' the TOMUserInputHandler can be instructed to emit symbolic commands upon receiving certain keys)
Additionally a list of currently held keys/commands is maintained in the activeKeys/Commands lists.
"
Class {
	#name : #TOMUserInputHandler,
	#superclass : #Object,
	#instVars : [
		'commandMappings',
		'activeKeys',
		'activeCommands',
		'advancedControllerSupport',
		'lastEvent',
		'cursorPosition',
		'valueToKeyMapping'
	],
	#pools : [
		'EventSensorConstants'
	],
	#category : #TOMGameEngine
}

{ #category : #'input mappings' }
TOMUserInputHandler class >> controllerButtonIndexToSymbol: buttonIndex [
	^#(
		a
		b
		x
		y
		leftshoulder
		rightshoulder
		leftstick
		rightstick
		start
		back
		guide
		lefttrigger
		righttrigger
		leftx
		lefty
		rightx
		righty) at: buttonIndex
]

{ #category : #'input mappings' }
TOMUserInputHandler class >> keyCodeMappingUnix [
	" thus far only tested for ubuntu "
	^Dictionary new
		at: 8 put: #backspace;
		at: 9 put: #tab;
		at: 13 put: #enter;
		at: 27 put: #escape;
		at: 28 put: #left;
		at: 29 put: #right;
		at: 30 put: #up;
		at: 31 put: #down;
		at: 32 put: #space;
		at: 44 put: #comma;
		at: 46 put: #dot;
		at: 48 put: #num0;
		at: 49 put: #num1;
		at: 50 put: #num2;
		at: 51 put: #num3;
		at: 52 put: #num4;
		at: 53 put: #num5;
		at: 54 put: #num6;
		at: 55 put: #num7;
		at: 56 put: #num8;
		at: 57 put: #num9;
		at: 97 put: #a;
		at: 98 put: #b;
		at: 99 put: #c;
		at: 100 put: #d;
		at: 101 put: #e;
		at: 102 put: #f;
		at: 103 put: #g;
		at: 104 put: #h;	
		at: 105 put: #i;
		at: 106 put: #j;
		at: 107 put: #k;
		at: 108 put: #l;	
		at: 109 put: #m;
		at: 110 put: #n;
		at: 111 put: #o;
		at: 112 put: #p;
		at: 113 put: #q;
		at: 114 put: #r;
		at: 115 put: #s;
		at: 116 put: #t;
		at: 117 put: #u;
		at: 118 put: #v;
		at: 119 put: #w;
		at: 120 put: #x;
		at: 121 put: #y;
		at: 122 put: #z;
		yourself
]

{ #category : #'input mappings' }
TOMUserInputHandler class >> keyCodeMappingWin32 [
	^Dictionary new
		at: 8 put: #backspace;
		at: 9 put: #tab;
		at: 13 put: #enter;
		at: 27 put: #escape;
		at: 28 put: #left;
		at: 29 put: #right;
		at: 30 put: #up;
		at: 31 put: #down;
		at: 32 put: #space;
		at: 48 put: #num0;
		at: 49 put: #num1;
		at: 50 put: #num2;
		at: 51 put: #num3;
		at: 52 put: #num4;
		at: 53 put: #num5;
		at: 54 put: #num6;
		at: 55 put: #num7;
		at: 56 put: #num8;
		at: 57 put: #num9;
		at: 65 put: #a;
		at: 66 put: #b;
		at: 67 put: #c;
		at: 68 put: #d;
		at: 69 put: #e;
		at: 70 put: #f;
		at: 71 put: #g;
		at: 72 put: #h;
		at: 73 put: #i;
		at: 74 put: #j;
		at: 75 put: #k;
		at: 76 put: #l;	
		at: 77 put: #m;
		at: 78 put: #n;
		at: 79 put: #o;
		at: 80 put: #p;
		at: 81 put: #q;
		at: 82 put: #r;
		at: 83 put: #s;
		at: 84 put: #t;
		at: 85 put: #u;
		at: 86 put: #v;
		at: 87 put: #w;
		at: 88 put: #x;
		at: 89 put: #y;
		at: 90 put: #z;
		at: 240 put: #dot;
		at: 222 put: #comma;
		yourself
]

{ #category : #accessing }
TOMUserInputHandler >> activeCommands [
	^activeCommands
]

{ #category : #accessing }
TOMUserInputHandler >> activeKeys [
	^activeKeys
]

{ #category : #controller }
TOMUserInputHandler >> advancedControllerSupport [
	" answer whether advanced controller support (trigger axis values, more buttons) is available "
	^advancedControllerSupport
]

{ #category : #private }
TOMUserInputHandler >> apiControllerInit [
	"void controllerInit();"
	<apicall: void 'controllerInit' () module: 'libcontroller.so'>
	
	advancedControllerSupport := false
]

{ #category : #private }
TOMUserInputHandler >> apiControllerNextEvent [
	"uint16_t controllerNextEvent();"
	<apicall: ushort 'controllerNextEvent' () module: 'libcontroller.so'>
	^self externalCallFailed
]

{ #category : #private }
TOMUserInputHandler >> apiControllerOn: anIndex [
	"int controllerOn(int index);"
	<apicall: bool 'controllerOn' (long) module: 'libcontroller.so'>
	^self externalCallFailed
]

{ #category : #private }
TOMUserInputHandler >> apiControllerState: anIndex [
	"state controllerState(int index);"
	<apicall: TOMControllerState 'controllerState' (long) module: 'libcontroller.so'>
	^self externalCallFailed
]

{ #category : #private }
TOMUserInputHandler >> apiControllerUpdate [
	"void controllerUpdate();"
	<apicall: void 'controllerUpdate' () module: 'libcontroller.so'>
	^self externalCallFailed
]

{ #category : #'input handling' }
TOMUserInputHandler >> bindCommandMapping: anAssociation [
	commandMappings add: anAssociation
]

{ #category : #accessing }
TOMUserInputHandler >> commandMappings [
	" access to the OrderedDictionary of key->command mappings "
	^commandMappings
]

{ #category : #controller }
TOMUserInputHandler >> controller: controllerIndex [
	" returns the state of the controller at index "
	^self advancedControllerSupport
		ifTrue: [ self apiControllerState: controllerIndex ]
		ifFalse: [ nil ]
]

{ #category : #controller }
TOMUserInputHandler >> controller: controllerIndex axisAngleAt: anAxis [
	" axis is either one of #left or #right "
	^self controller: controllerIndex axisAngleAt: anAxis threshold: 0
]

{ #category : #controller }
TOMUserInputHandler >> controller: controllerIndex axisAngleAt: anAxis threshold: aNumber [
	" axis position is either one of #left or #right. Threshold defines the percentage that
	  the controller handle has to be moved at least in order to return a non nil value "
	| position |
	position := self controller: controllerIndex axisPositionAt: anAxis.
	(position squaredDistanceTo: 0 @ 0) > (self controllerMaxAxisValue squared * aNumber)
		ifFalse: [^nil].
	
	^TOMUtils normalizeAngle: (TOMUtils angleForVector: position) - Float halfPi
]

{ #category : #controller }
TOMUserInputHandler >> controller: controllerIndex axisPositionAt: anAxis [
	" axis position is either one of #left or #right "
	self advancedControllerSupport
		ifTrue: [
			| state |
			state := self apiControllerState: controllerIndex.
			anAxis = #left ifTrue: [ ^state leftxAxis @ state leftyAxis ].
			anAxis = #right ifTrue: [ ^state rightyAxis @ state rightyAxis ]]
		ifFalse: [
			^Sensor joystickXY: controllerIndex ]
]

{ #category : #controller }
TOMUserInputHandler >> controller: controllerIndex buttonActive: aButton [
	" button is either one of a, b, x, y (squeak and controller module), leftshoulder, rightshoulder, leftstick, rightstick, start, back, guide (controller module only) "
	
	| state |
	
	self advancedControllerSupport
		ifFalse: [
			state := Sensor joystickButtons: controllerIndex.
			aButton caseOf: {
				[#a] -> [ ^(state bitAnd: 1) ~= 0 ].
				[#b] -> [ ^(state bitAnd: 2) ~= 0 ].
				[#x] -> [ ^(state bitAnd: 4) ~= 0 ].
				[#y] -> [ ^(state bitAnd: 8) ~= 0 ]
			}]
		ifTrue: [
			state := self apiControllerState: controllerIndex.
			aButton caseOf: {
				[#a] -> [ ^state aButton ~= 0 ].
				[#b] -> [ ^state bButton ~= 0 ].
				[#x] -> [ ^state xButton ~= 0 ].
				[#y] -> [ ^state yButton ~= 0 ].
				[#leftshoulder] -> [ ^state leftShoulderButton ~= 0 ].
				[#rightshoulder] -> [ ^state rightShoulderButton ~= 0 ].
				[#leftstick] -> [ ^state leftStickButton ~= 0 ].
				[#rightstick] -> [ ^state rightStickButton ~= 0 ].
				[#start] -> [ ^state startButton ~= 0 ].
				[#back] -> [ ^state backButton ~= 0 ].
				[#guide] -> [ ^state guideButton ~= 0 ].
			}].
	
	^false
]

{ #category : #controller }
TOMUserInputHandler >> controller: controllerIndex triggerAt: aPosition [	
	" aPosition is either one of #left or #right (no support in squeak) "
	| state |
	self advancedControllerSupport ifFalse: [ ^0 ].
	
	state := self apiControllerState: controllerIndex.
	
	aPosition = #left ifTrue: [ ^state leftTriggerAxis ].
	aPosition = #right ifTrue: [ ^state rightTriggerAxis ].
	
	^0
]

{ #category : #controller }
TOMUserInputHandler >> controllerAtIndex: anIndex [
	^self advancedControllerSupport
		ifTrue: [ (self apiControllerOn: anIndex) ~= 0 ]
		ifFalse: [ Sensor joystickOn: anIndex ]
]

{ #category : #controller }
TOMUserInputHandler >> controllerMaxAxisValue [
	^self advancedControllerSupport
		ifTrue: [ 32768 ]
		ifFalse: [ 1100 " seems to be about right from testing " ]
]

{ #category : #accessing }
TOMUserInputHandler >> cursorPosition [
	^cursorPosition / TOMGame scale
]

{ #category : #private }
TOMUserInputHandler >> getEventTime: event [
	| time |
	time := event second.
	time = 0 ifTrue: [ time := Time millisecondClockValue ].
	
	^time
]

{ #category : #'initialize-release' }
TOMUserInputHandler >> initialize [ 
	super initialize.
	
	lastEvent := {1. 0. 0. 0. 0. 0. nil. nil}.
	cursorPosition := 0 asPoint.
	activeKeys := Set new.
	activeCommands := Set new.
	commandMappings := OrderedDictionary new.
	
	" apiControllerInit will set controllerSupport to false if it fails "
	advancedControllerSupport := true.
	
	self
		apiControllerInit;
		initializeValueToKeyMapping
]

{ #category : #'initialize-release' }
TOMUserInputHandler >> initializeValueToKeyMapping [
	valueToKeyMapping := Smalltalk platformName = 'Win32'
		ifTrue: [ self class keyCodeMappingWin32 ]
		ifFalse: [ self class keyCodeMappingUnix ]
]

{ #category : #private }
TOMUserInputHandler >> keyCodeToKeySymbol: aKeyCode [
	^valueToKeyMapping at: aKeyCode ifAbsent: [nil]
]

{ #category : #private }
TOMUserInputHandler >> keyFor: aCommand ofPlayer: aNumber [
	^self keyForCommand: aCommand, '_', aNumber
]

{ #category : #private }
TOMUserInputHandler >> keyForCommand: aCommand [

	^ commandMappings at: aCommand
]

{ #category : #private }
TOMUserInputHandler >> processControllerEvents [
	| event active button controllerIndex |
	
	self apiControllerUpdate.
	
	[(event := self apiControllerNextEvent) ~= 0] whileTrue: [
		"1 bit   : valid event
		 10 bits : button_index
		 4 bits  : controller_index
		 1 bit   : active"
		active := (event bitAnd: 1) ~= 0.
		controllerIndex := (event bitAnd: 2r11110) bitShift: -1.
		button := (event bitAnd: (2r0111111111100000)) bitShift: -5.
		
		self triggerEvent: #controllerEvent with: (TOMControllerEvent new
			active: active;
			controllerIndex: controllerIndex + 1;
			button: (self class controllerButtonIndexToSymbol: button + 1);
			yourself) ]
]

{ #category : #'input handling' }
TOMUserInputHandler >> processEvents [
	| event |
	advancedControllerSupport ifTrue: [ self processControllerEvents ].
	
	event := nil.
	[event := Sensor nextEvent] whileNotNil: [
		event first = EventTypeMouse ifTrue: [ self processMouseEvent: event ].
		event first = EventTypeKeyboard ifTrue: [ self processKeyboardEvent: event ].
		lastEvent := event ]
]

{ #category : #private }
TOMUserInputHandler >> processKeyboardEvent: event [
	" deeply inspired by HandMorph's handling "
	| keyValue stateType command key |
	stateType := event fourth.
	
	" we only report up and down events "
	stateType = EventKeyChar ifTrue: [^self].
	
	keyValue := event third.
	key := self keyCodeToKeySymbol: keyValue.
	command := self translateKeyToCommand: key.
	
	stateType = EventKeyDown
		ifTrue: [
			activeKeys add: key.
			command ifNotNil: [
				activeCommands add: command ]]
		ifFalse: [
			activeKeys remove: key ifAbsent: [].
			command ifNotNil: [
				activeCommands remove: command ifAbsent: [].
				self triggerEvent: #commandEvent with: command ]].
	
	self
		triggerEvent: #keyboardEvent
		with: (TOMKeyboardEvent new
			timestamp: (self getEventTime: event);
			eventType: (stateType = EventKeyDown ifTrue: [#down] ifFalse: [#up]);
			key: key;
			yourself)
]

{ #category : #private }
TOMUserInputHandler >> processMouseEvent: event [
	" deeply inspired by HandMorph's handling "
	| position currentButtons lastButtons mouseActionType |
	lastButtons := lastEvent fifth.
	currentButtons := event fifth.
	
	position := event third @ event fourth.
	
	mouseActionType := currentButtons = 0
		ifTrue: [
			lastButtons = 0
				ifTrue: [ #move ] " buttons didn't change "
				ifFalse: [ #up ]] " previously there were buttons "
		ifFalse: [
			currentButtons = lastButtons
				ifTrue: [ #move ] " no change "
				ifFalse: [
					currentButtons > lastButtons
						ifTrue: [ #down ] " previously less buttons "
						ifFalse: [ #up ]]]. " previously more buttons "
	
	mouseActionType = #move ifTrue: [
		cursorPosition := position ].
	
	self
		triggerEvent: #mouseEvent
		with: (TOMMouseEvent new
			timestamp: (self getEventTime: event);
			position: position;
			eventType: mouseActionType;
			button: currentButtons;
			yourself)
]

{ #category : #'input handling' }
TOMUserInputHandler >> rebindCommand: aCommand to: aKey [
	self unbindCommandAt: aKey.
	commandMappings at: aCommand put: aKey.
	self triggerEvent: #updatedInputs
]

{ #category : #'input handling' }
TOMUserInputHandler >> translateCommandToKey: command [
	^commandMappings at: command ifAbsent: [nil].
]

{ #category : #'input handling' }
TOMUserInputHandler >> translateKeyToCommand: key [
	^commandMappings keyAtValue: key ifAbsent: [nil]
]

{ #category : #'input handling' }
TOMUserInputHandler >> unbindCommandAt: aKey [
	"needed to unbind keys that are being bound for another command"
	| unboundCommand |
	
	unboundCommand := commandMappings keyAtValue: aKey ifAbsent: [].
	unboundCommand notNil ifTrue: [ commandMappings at: unboundCommand put: #unbound].
	activeCommands remove: unboundCommand ifAbsent: [].
	self triggerEvent: #updatedInputs
]
