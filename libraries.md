# Library Reference

These are the optional modules (some of which make up the standard configuration.)  They are located in `lib/`.

## 2D Arrays []() - array2d.f

2D Arrays are either statically allocated, or, exist as "header" information about an arbitrary block of memory.

You could use a 2D array header to perform operations on a section of a static 2d array, or allocate a 2d array dynamically, which is what `buffer2d.f` does.


## 2D Buffers []() - buffer2d.f

The dictionary size in most Forth systems is quite limited, and it's wasteful to statically allocate large arrays since they can affect the size of published executables.

2D buffers are 2D arrays that are allocated from the system heap, so they can be as large as the OS allows and won't affect executable size.  The tradeoff is no predefined data.  You have to load it at runtime (either by defining a new kind of asset or using a load trigger.)

## Audio []() - audio1.f

Very basic audio support.  You can play sample assets and stream audio files.  Samples and streaming files can be played once and stop, looped, or ping-pong looped.  You can stream only one file at a time.

The audio files supported are the same as the ones supported by Allegro.  (WAV, AIFF, OGG, MP3, MOD, S3M, IT, XM, possibly more).

## Collision Grid []() - cgrid.f

There are genres of games that require a large number of collision checks - shootemups, simulations, and games with large open worlds.  With the Collision Grid module you can do fast checks between rectangles that have been "binned".  You can bin non-moving objects into a grid just once (when you load your map) or you can clear and repopulate a grid once per frame in the case of moving objects.  You can have as many grids as you want and they can be as big as you want.

Note: As shipped, binned rectangles can't be bigger than 512x512 pixels.

## Draw []() - draw.f

A convenient wordset for drawing things on the screen.

## Nodes []() - node.f

This module extends ramen objects with the ability to be arranged in a tree heirearchy, in line with what's conventional in many other game engines.  You can use this to arrange game objects or anything else that you'd like to put in a tree heirearchy, so long as they are ramen objects.

It is not used by the default configuration.

## Numeric Range Tools []() - rangetools.f

Tools for working with 1D and 2D ranges.

## Rectangles []() - rect.f

Generic data structure representing a rectangle.

## Radix Sort []() - rsort.f

Fast radix sort routine.  The algorithm is specially tailored for sorting fixed point integers from 0 to 65535.  Used by `zsort.f`.

## Sprites []() - sprites.f

Robust animated sprite extension for game objects.

## Stage []() - stage.f

Simple scrolling 2D game framework.  Use as-is, or as a template to copy and customize.

Features:

- Predefined game object list
- Camera object
- Camera can be set to follow an object
- Camera "flyby" mode

Note: When using tilemap scrolling, you need to compensate for the camera position,  Otherwise set the tilemap's width and height to the size of the entire source map and don't use `scrollx` and `scrolly`.

## Round-robin Multitasking []() - task.f

Extension that empowers you to easily program objects to perform complex behaviors over time.  (This is analogous to the "coroutine" functionality available in several general game engines, but more powerful.)

In games you will often want to have your characters do different actions in sequence or in response to things.  The approach often used to do this is classically referred to as a "state machine", which is what all of RAMEN's objects are.  Some examples of where this technique is indispensible is platforming games, cutscenes, enemy attack patterns, boss fights, and A.I.  Put simply if you want to make a game that's anything but the most basic thing, you need to be constantly changing the state of objects over time.

In the days of yore, programming objects to do different things over time wasn't trivial.  You had to use counters and state checks and flags and the code would be difficult to write and end up fairly bloated.

...

## 2D Vectors []() - v2d.f

Generic data structure representing a 2D vector in space and accompanying storage and math words.

## Depth-sorting []() - zsort.f

Extends game objects with a `zdepth` field and provides a routine for rendering an object list sorted by this value.