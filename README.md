# Totally Obsolete Mission

A rogue-like spaceshooter of a spaceship on an obsolete mission.

## Installation

> Note: sadly requires opensmalltalk VM builds with FloatArray fixes that are not currently available to download easily.

```smalltalk
Metacello new
  baseline: 'TOMSpaceShooter';
  repository: 'github://tom95/TOMSpaceshooter';
  load.
```

## Play

```
TOMGame start.
```

Hit `<tab>` to just start the game. Move the spaceship with `ijkl`, shoot with `<space>`, and cycle through equipment via `1234`.
