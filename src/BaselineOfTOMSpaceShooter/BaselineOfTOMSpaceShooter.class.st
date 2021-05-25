Class {
	#name : #BaselineOfTOMSpaceShooter,
	#superclass : #BaselineOf,
	#category : #BaselineOfTOMSpaceShooter
}

{ #category : #baseline }
BaselineOfTOMSpaceShooter >> baseline: spec [
	<baseline>

	spec for: #common do: [
		spec
			baseline: 'OpenGLObjects' with: [
				spec repository: 'github://hpi-swa-lab/squeak-graphics-opengl:main/OpenGLObjects/src/'];
		
			package: 'TOMGameEngine' with: [spec requires: #('OpenGLObjects')];
			package: 'TOMSpaceShooter' with: [spec requires: #('TOMGameEngine')].
		
		spec
			group: 'default' with: #('all');
			group: 'all' with: #('TOMSpaceShooter')]
]

{ #category : #baseline }
BaselineOfTOMSpaceShooter >> projectClass [

	^ self environment
		at: #MetacelloCypressBaselineProject
		ifAbsent: [super projectClass]
]
