# helper makefile to build fmod reverb testing suite

fmod-reverb: libfmod.c
	gcc fmod-reverb.c -o fmod-reverb \
		`pkg-config --libs --cflags gtk+-3.0` \
		-lfmodL \
		-L./fmodstudioapi10706linux/api/lowlevel/lib/x86_64 \
		-I./fmodstudioapi10706linux/api/lowlevel/inc

run:
	env LD_LIBRARY_PATH="$LD_LIBRARY_PATH:./fmodstudioapi10706linux/api/lowlevel/lib/x86_64/" ./fmod-reverb

.PHONY: run
