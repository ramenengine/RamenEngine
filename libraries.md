# Library Reference

These are the optional modules \(some of which make up the Standard Packet.\) They are located in `lib/`.  Some libraries depend on other libraries.

## 2D Arrays  \(array2d.f\)

2D Arrays are either statically allocated, or, exist as "header" information about an arbitrary block of memory.

You could use a 2D array header to perform operations on a section of a static 2d array, or allocate a 2d array dynamically, which is what `buffer2d.f` does.

```text
struct %array2d
    %array2d int svar array2d.cols
    %array2d int svar array2d.rows
    %array2d int svar array2d.pitch
    %array2d int svar array2d.data
```

`2move` \( src /pitch dest /pitch nrows /bytes -- \)  
`clip` \( col row ncols nrows ndestcols ndestrows -- col row ncols nrows \)  
`array2d-head,` \( cols rows -- \) create a 2d array header in dictionary  
`array2d` \( numcols numrows -- \) create a 2d array in dictionary  
`count2d` \( array2d -- addr \#cells \) get address and total number of all cells  
`dims@` \( array2d -- \#cols \#rows \) get array2d's dimensions  
`loc` \( col row array2d -- addr \) get address of cell at col, row  
`pitch@` \( array2d -- /pitch \) get array2d's pitch in bytes  
`addr-pitch` \( col row array2d -- addr /pitch \)   
`some2d` \( ... col row \#cols \#rows array2d XT -- ... \) \( ... addr \#cells -- ... \) iterate  
`some2d>` \( col row \#cols \#rows array2d --  \) \( addr \#cells -- \) iterate  
`fill2d` \( val col row \#cols \#rows array2d -- \) fill each cell of 2d array with value  


## 2D Buffers  \(buffer2d.f\)

2D buffers are 2D arrays that are allocated from the system heap. 

2D buffer declaration example:

```text
256 256 buffer2d: mytable
```

## Audio  \(audio1.f\)

Provides basic audio. 

`play` \( sample -- \) Play sample asset.  \(Not ALLEGRO\_SAMPLE structs.\)

`stream` \( addr c loopmode -- \) Stream audio file.  You can stream only one file at a time.

Loop modes: `once` `bidir` `looping`

The audio files supported are the same as the ones supported by Allegro. \(WAV, AIFF, OGG, MP3, MOD, S3M, IT, XM, possibly more\).

`variable strm` points to the current playing ALLEGRO\_AUDIO\_STREAM.

## Collision Grid  \(cgrid.f\)

Fast collisions suitable for shootemups, simulations, and large open worlds.  It works by giving each object a hitbox \(of type `cbox`\), breaking up the game world into a grid, and only checking the other objects in the same grid space.  

To use it, you first create a collision grid.  Then at some point you "bin" the objects you want to check an object against.  You can do this once, such as for background objects when you load a map, or every frame, in the case of moving objects.  \(Note that when you want to bin objects every frame, you must clear the grid first.\)  Finally you check an object against the grid, upon which a given XT will be executed upon any collisions.  

An object can be binned into only one cgrid at a time.

_Note: By default, the size of rectangles can't be bigger than 512x512 pixels. To get around this limitation you can break up larger rectangles using  `break2d`, found in stride2d.f_

Collision grid declaration example:

```text
256 256 cgrid: mycgrid
```

`ahb` \( -- cbox \) "absolute hitbox"   
`cbox!` \( x y w h cbox -- \)   
`cbox@` \( cbox -- x y w h \)  
`resetcgrid` \( cgrid -- \)  
`addcbox` \( cbox cgrid -- \)  
`checkcgrid` \( cbox1 xt cgrid -- \) check a cbox against  
`checkcbox` \( cbox1 xt cgrid -- \)  
`cgrid-size` \( cgrid -- w h \)

See [rectland.f ](https://github.com/RogerLevy/ramenExamples/blob/master/rectland.f)for a complete example.

## Draw  \(draw.f\)

See [Drawing](drawing.md).

## Numeric Range Tools  \(rangetools.f\)

Tools for working with 1D and 2D ranges.



## Rectangles  \(rect.f\)

Generic data structure representing a rectangle.

## Radix Sort  \(rsort.f\)

Fast radix sort routine. The algorithm is specially tailored for sorting fixed point integers from 0 to 65535. Used by `zsort.f`.

## Sprites  \(sprites.f\)

Robust animated sprite extension for game objects.

## Stage  \(stage.f\)

Simple scrolling 2D game framework. Use as-is, or as a template to copy and customize.

Features:

* Predefined game object list
* Camera object
* Camera can be set to follow an object
* Camera "flyby" mode

Note: When using tilemap scrolling, you need to compensate for the camera position, Otherwise set the tilemap's width and height to the size of the entire source map and don't use `scrollx` and `scrolly`.

## Round-robin Multitasking  \(task.f\)

In games you will often want to have your characters do different actions in sequence or in response to things. Some examples of where this technique is indispensible is platforming games, cutscenes, enemy attack patterns, boss fights, and A.I.

Programming objects to do different things over time in conventional engines isn't trivial. You have to use state machines, counters and state checks and flags or yield signals.

Ramen's approach makes it very easy, allowing you to use natural structured programming to define complex object behavior.

...

## Tiled  \(tiled.f\)

[Tiled](https://www.mapeditor.org/) map format support.  

See [Tiled Support](tiled.md)

## 2D Vectors  \(v2d.f\)

Generic data structure representing a 2D vector in space and accompanying storage and math words.

## Depth-sorting  \(zsort.f\)

Extends game objects with a `zdepth` field and provides a routine for rendering an object list sorted by this value.

