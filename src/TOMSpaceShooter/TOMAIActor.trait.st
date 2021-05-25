"
The TOMAIActor may be added to any class that wishes to communicate with other AIs around it. The class is required to implement an ""actor"" message that replies its in-game sprite representing the actual AI as a living being.
"
Trait {
	#name : #TOMAIActor,
	#category : #TOMSpaceShooter
}

{ #category : #alliances }
TOMAIActor >> allyInformRadius [
	^8000
]

{ #category : #alliances }
TOMAIActor >> informAllies [
	(self actor isNil or: [self actor alive not]) ifTrue: [^self].
	
	(self actor scene spatialHash
		objectsAt: self actor position
		radius: self allyInformRadius
		select: [ :sprite | sprite fraction = self actor fraction ]) do: [ :sprite |
			sprite requestTarget: self target ]
]
