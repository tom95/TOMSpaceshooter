"
A TOMMeteorBig is a larger meteor that explodes into smaller TOMMeteorDebris parts when destroyed.
"
Class {
	#name : #TOMMeteorBig,
	#superclass : #TOMMeteor,
	#instVars : [
		'mapTile'
	],
	#category : #TOMSpaceShooter
}

{ #category : #'initialize-release' }
TOMMeteorBig >> damage [
	^120
]

{ #category : #'initialize-release' }
TOMMeteorBig >> die [
	" upon collision large meteors break into smaller ones "
	self scene ifNotNil: [
		self rectangle corners do: [ :corner |
			scene addPersistentGameObject:
				((TOMMeteorDebris newWith: self assetFactory)
					position: corner + ((self center - corner) * 0.7);
					impactSpeed: 500;
					yourself) ]].
	super die
]

{ #category : #'initialize-release' }
TOMMeteorBig >> miniMapColor [ 
	^Color r: 0.6 g: 0.3 b: 0
]

{ #category : #'initialize-release' }
TOMMeteorBig >> sprites [
	^#(#'Meteors/meteorBrown_big1'
		#'Meteors/meteorBrown_big2'
		#'Meteors/meteorBrown_big3'
		#'Meteors/meteorBrown_big4')
]
