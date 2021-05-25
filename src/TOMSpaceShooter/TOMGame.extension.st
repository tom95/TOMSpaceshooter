Extension { #name : #TOMGame }

{ #category : #'*TOMSpaceshooter-start' }
TOMGame class >> start [
	TOMGame clearLog.
	
	^TOMSpaceshooterGame new
]
