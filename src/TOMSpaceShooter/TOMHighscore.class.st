"
A TOMHighscore is the base class for implementations of highscore recording backends.
"
Class {
	#name : #TOMHighscore,
	#superclass : #Object,
	#category : #TOMSpaceShooter
}

{ #category : #'highscore-attributes' }
TOMHighscore class >> requiresName [
	^self subclassResponsibility
]

{ #category : #scores }
TOMHighscore >> reportScore: aScore [
	^self subclassResponsibility
]

{ #category : #scores }
TOMHighscore >> scores [
	^self subclassResponsibility
]
