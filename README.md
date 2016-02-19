# TOMSpaceshooter Auxiliary Files

This repo contains the external resources for the TOMSpaceshooter and the external libraries that are invoked in squeak via FFI.

## libspriterenderer

This is a small library wrapping modern OpenGL calls to draw rectangle sprites in a simple interface. It's current usage benefits are small, but it provides great potential, such as custom shader code. Compiling was tested on Ubuntu 14.04.

## libfmod

To provide 3D (or in our case 2D) spatial sound, a downloaded version of [fmod](http://www.fmod.org/) can be placed here. The install routine looks for a `fmodstudioapi10706linux` folder that can be found in the downloadable package on the fmod website.

## libcontroller

This code provides a highly extended interface to joysticks and controllers and an easy way to query their inputs from squeak's side (linux only). The interface is inspired by the interface used by the EventSensor squeak class. Good portions of the code come from the SDL project. For plug'n'play, the udev library is required.

## sprites

This folder contains all image assets used in the game.

## sounds

This folder contains all sound assets used in the game.
