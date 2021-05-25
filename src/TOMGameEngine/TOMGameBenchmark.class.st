"
A TOMGameBenchmark is a collector for various per frame time values. It has functions to display those in a helpful way.
"
Class {
	#name : #TOMGameBenchmark,
	#superclass : #Object,
	#instVars : [
		'fps',
		'lastTimeFrame',
		'fpsAccumulated',
		'activeObjects',
		'timeMeasurements',
		'timeMeasurementsAccumulated',
		'accumulator'
	],
	#category : #TOMGameEngine
}

{ #category : #accessing }
TOMGameBenchmark >> activeObjects: aNumber [
	activeObjects := aNumber
]

{ #category : #drawing }
TOMGameBenchmark >> draw: spriteRenderer in: viewSize [
	| x y |
	x := viewSize x - self maxWidth.
	y := self startY.
	
	spriteRenderer renderText: 'FPS: ', fps at: x @ y size: self fontSize.
	y := y + self fontSize.
	
	timeMeasurements keysAndValuesDo: [ :measurement :time |
		spriteRenderer renderText: measurement asString, ': ', time at: x @ y size: self fontSize.
		y := y + self fontSize ].
	
	spriteRenderer renderText: 'Objects: ',activeObjects at: x @ y size: self fontSize.
]

{ #category : #drawing }
TOMGameBenchmark >> fontSize [
	^22
]

{ #category : #updating }
TOMGameBenchmark >> framesPerAverageRecalc [
	^20
]

{ #category : #'initialize-release' }
TOMGameBenchmark >> initialize [ 
	super initialize.
	lastTimeFrame := 0.
	
	accumulator := 0.
	
	fps := 0.
	fpsAccumulated := 0.
	activeObjects := 0.
	
	timeMeasurements := Dictionary new.
	timeMeasurementsAccumulated := Dictionary new
]

{ #category : #drawing }
TOMGameBenchmark >> maxWidth [
	^300
]

{ #category : #updating }
TOMGameBenchmark >> report: aMeasurementPoint time: aMilliSecondTimeValue [
	timeMeasurementsAccumulated at: aMeasurementPoint
		ifPresent: [ :currentTime |
			timeMeasurementsAccumulated at: aMeasurementPoint put: currentTime + aMilliSecondTimeValue ]
		ifAbsent: [
			timeMeasurementsAccumulated at: aMeasurementPoint put: aMilliSecondTimeValue ]
]

{ #category : #updating }
TOMGameBenchmark >> reportFrameEnd [
	| now |
	now := Time millisecondClockValue.
	fpsAccumulated := fpsAccumulated + (now - lastTimeFrame clampLow: 1).
	lastTimeFrame := now.
	
	accumulator := accumulator + 1.
	accumulator >= self framesPerAverageRecalc ifTrue: [ self updateDisplayValues ]
]

{ #category : #drawing }
TOMGameBenchmark >> startY [
	^64
]

{ #category : #updating }
TOMGameBenchmark >> updateDisplayValues [
	fps := (1000.0 / (fpsAccumulated asFloat / accumulator)) truncated printString.
	
	timeMeasurementsAccumulated keysAndValuesDo: [ :measurement :time |
		timeMeasurementsAccumulated at: measurement put: 0.
		timeMeasurements at: measurement put: (time asFloat / accumulator) truncated asString ,
			' - ' , (time / fpsAccumulated * 100) truncated asString , '%' ].
		
	fpsAccumulated := 0.
	accumulator := 0
]
