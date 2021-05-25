"
A TOMMeteorDebris are small meteor parts with no special behavior except for lower damage than their big counterparts.
"
Class {
	#name : #TOMMeteorDebris,
	#superclass : #TOMMeteor,
	#category : #TOMSpaceShooter
}

{ #category : #'initialize-release' }
TOMMeteorDebris >> damage [
	^10
]

{ #category : #'initialize-release' }
TOMMeteorDebris >> sprites [
	^#(#'Meteors/meteorBrown_small1'
	   #'Meteors/meteorBrown_small2'
	   #'Meteors/meteorBrown_tiny1'
	   #'Meteors/meteorBrown_tiny2')
]
