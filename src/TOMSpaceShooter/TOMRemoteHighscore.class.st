"
A TOMRemoteHighscore queries a given server via HTTP for a highscore list and can report back own player scores (it contains no anti-cheating mechanisms, honesty of the players is assumed).
"
Class {
	#name : #TOMRemoteHighscore,
	#superclass : #TOMHighscore,
	#category : #TOMSpaceShooter
}

{ #category : #'highscore-attributes' }
TOMRemoteHighscore class >> highscoreUrl [
	^'http://tombeckmann.de:4242/scores'
]

{ #category : #'highscore-attributes' }
TOMRemoteHighscore class >> requiresName [
	^true
]

{ #category : #scores }
TOMRemoteHighscore >> reportScore: aScore [
	| response |
	[
		response := WebClient
			httpPut: self class highscoreUrl
			content: TOMSpaceshooterGame nameInHighscore , ',' , aScore asString
			type: 'text/plain'.
	
		response isSuccess
			ifFalse: [ TOMGame log: 'Could not save highscore, do you have internet?' ]
			ifTrue: [ ^response content asInteger + 1 ]
	] on: Error do: [ TOMGame log: 'Couldn''t save highscore :(' ].
	
	^1
]

{ #category : #scores }
TOMRemoteHighscore >> scores [
	| scores stream response |
	scores := OrderedCollection new.
	[
		response := WebClient httpGet: self class highscoreUrl.
		
		response isSuccess
			ifFalse: [ TOMGame log: 'Highscore could not be loaded, do you have internet?' ]
			ifTrue: [
				stream := ReadStream on: response content.
				[stream atEnd] whileFalse: [
					scores add: stream nextLine ]].
	] on: Error do: [ TOMGame log: 'Couldn''t fetch highscores :(' ].

	^scores
]
