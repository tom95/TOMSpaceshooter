"
A TOMLocalHighscore keeps the scores in a file in the local filesystem. It only keeps track of the 10 new best.
"
Class {
	#name : #TOMLocalHighscore,
	#superclass : #TOMHighscore,
	#instVars : [
		'scores'
	],
	#category : #TOMSpaceShooter
}

{ #category : #'highscore-attributes' }
TOMLocalHighscore class >> highscoreFilepath [
	^'tomspaceshooter-highscores.txt'
]

{ #category : #'highscore-attributes' }
TOMLocalHighscore class >> maxHighscoreEntries [
	^10
]

{ #category : #'highscore-attributes' }
TOMLocalHighscore class >> requiresName [
	^false
]

{ #category : #'initialize-release' }
TOMLocalHighscore >> initialize [
	| path |
	path := (FileDirectory default / self class highscoreFilepath) fullName.
	
	(FileDirectory default fileExists: self class highscoreFilepath)
		ifFalse: [ scores := SortedCollection new ]
		ifTrue: [
			FileDirectory default oldFileNamed: path do: [ :stream |
				self parseHighScoreData: stream ]]
]

{ #category : #private }
TOMLocalHighscore >> parseHighScoreData: aStream [
	scores := SortedCollection new.
	
	[aStream atEnd] whileFalse: [
		scores add: aStream nextLine asInteger ].
	
	(scores includes: nil) ifTrue: [
		TOMGame log: 'Invalid highscore file - resetting!'.
		scores := SortedCollection new ]
]

{ #category : #scores }
TOMLocalHighscore >> reportScore: aScore [
	" add score value to collection and return index of the score entry "
	scores add: aScore.
	
	scores size > self class maxHighscoreEntries ifTrue: [
		scores removeFirst ].
	
	self save.
	
	^scores size - (scores
		lastIndexOf: aScore
		ifAbsent: [self class maxHighscoreEntries  + 1]) + 1
]

{ #category : #private }
TOMLocalHighscore >> save [
	| path |
	path := (FileDirectory default / self class highscoreFilepath) fullName.
	
	FileDirectory default forceNewFileNamed: path do: [ :stream |
		scores printOn: stream delimiter: Character cr asString ]
]

{ #category : #scores }
TOMLocalHighscore >> scores [
	^scores reverse
]
