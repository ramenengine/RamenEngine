# Sprites

Robust animated sprite extension for game objects.

The sprite system is designed for ease and flexibility.  You can:

* Rotate, scale, tint, and flip sprites
* Animate sprites using subimages \(a.k.a sprite strips\) or specially defined regions \(a.k.a. sprite sheets\)
* Define animations with predetermined source image, region table, and speed
* Define animation tables
* Change the source image, region table, and animation speed at any time

## Guide to Sprites

To follow along with the examples, download the [LinkGoesForth](https://github.com/rogerLevy/linkgoesforth) project and load session.f.  You can copy and paste the code into source files and `ld` them from the prompt.  Don't forget you can issue any phrase interactively to see the effect immediately.

### Plain Sprites

The most basic kind of sprite is just an image.  Refer to the following example:

```text
include ramen/ramen.f
depend ramen/stdpack.f
stop                                   \ reset the engine

s" data/dinobaby.png" image: myimage   \ declare the image

500 300 at
stage object: myobj  \ create a static object at 500,300

myimage img !        \ set the object's image
10 10 sx 2!          \ scale it 10X
45 ang !             \ rotate it 45 degrees
12 12 cx 2!          \ set the center of rotation to 12,12

:now  draw> sprite+ ;  \ this activates sprite rendering for the object

\ get extra fancy; make it spin!
:now  draw> sprite+  1 ang +! ;
```

### Sprite Strips

If your image is a sprite strip, `subdivide ( image w h - )` it first.  You can draw a subimage this way:

```text
depend ramen/stdpack.f  \ load the standard packet

s" data/samurai.png" image: myimage   \ declare the image
myimage 16 16 subdivide  \ tell Ramen the subimages are 16x16

500 300 at
stage object: myobj  \ create a static object at 500,300

myimage img !    \ set the object's image

:now  draw> sprite+ ;  \ this activates sprite rendering for the object
```

When no animation is specified, by default the first subimage is drawn.

Of course you can directly control which subimage is drawn.  For that there is the word `subsprite ( n flip -- )`. Example:

```text
:now  draw> 1 #1 subsprite ;  \ draws the 3rd subimage in the strip, 
                              \ flipped horizontally.
```

### Defining Animations

You can define animations that, when called, will play themselves and set the object displaying frames in sequence.  When an animation reaches its end it will loop to beginning by default.  A frame can be a subimage or a region.  First we'll demonstrate with subimages.

```text
anim: ( 0|regiontable image speed -- <name> )
```

```text
:now  draw> sprite+ ;  \ go back to regular sprite drawing

0 myimage 1 8 / anim: a_test        \ plays at 15fps
  0 , 16 , 1 , 17 , 2 , 18 ,      \ the frames
;anim

a_test  \ play the animation
```

A word `range` compiles frame numbers for you - handy for long animations.

```text
0 myimage 1 8 / anim: a_first3  0 3 range,  ;anim
```

Another word `,,` compiles the same frame number multiple times, letting frames have different lengths.  In this version of `myanim`, frames 3 and 4 will go by twice as fast as frames 1 and 2.

```text
0 myimage 1 anim: a_test2
  0 8 ,,  16 8 ,,  1 4 ,,  17 4 ,,   
;anim
```

### Sprite Sheets

The frames in samurai.png are not all the same size; the image is a sprite sheet not a sprite strip.  To use the other frames you'll need a region table.  Regions are referenced from region tables.  A region is a rectangle plus an origin, which defines the point within the region to treat as where the object's X,Y should be.  \(For example 8,8 in a 16x16 region would be at its center.\)

First you define your region table:

```text
create myregions
64 , 0 , 32 , 32 , 0 , 8 ,  \ region #0 is at (64,0), 32x32, origin=(0,8)
96 , 0 , 32 , 32 , 0 , 8 ,  \ region #0 is at (96,0), 32x32, origin=(0,8)
128 , 0 , 32 , 32 , 0 , 8 ,  \ region #0 is at (128,0), 32x32, origin=(0,8)
160 , 0 , 32 , 32 , 0 , 8 ,  \ region #0 is at (160,0), 32x32, origin=(0,8)

```

Then you define your animation:

```text
myregions myimage 1 4 / anim: a_rswing  0 4 range,  3 4 ,,  ;anim
```

Then simply call `a_rswing` .

## Glossary

`/region` Size of a region.  
`/frame` Size of a frame. \(cell\)  
`sx sy ang cx cy tint` Object transformation fields: Scale x/y, angle, center x/y, tint\(color\)  
`img frm rgntbl anmspd anmctr` Animation fields: Image, frame pointer, region table pointer, animation speed \(1 = full speed, 0.5 = half speed\), animation counter  
`sprite` \( srcx srcy w h flip -- \) Draw a region of the current object's `img` , using the current object's transformation info.  
`subsprite` \( n flip -- \) Draw a subsprite of the current object's `img`.   
`framexywh` \( n regiontable -- srcx srcy w h \) Get parameters suitable to send to `sprite`.  
`curframe` \( -- srcx srcy w h \) Factor of `sprite+`.  
`curflip` \( -- n \)   
`defer` `animlooped`Define this in your app to do stuff every time an animation ends/loops.  
`sprite+` \( -- \) Draw sprite and step the animation forward based on the animation fields.

`animate` \( anim -- \) Play an animation from the beginning.  
`anim:` \( regiontable\|0 image speed -- loopaddr \) \( -- \) create self-playing animation  
`,,` \( val n -- \) Comma \(compile\) `val` multiple times.  
`loop:` \( loopaddr -- loopaddr \) Change the loop address to something other than the first frame.  
`;anim` \( loopaddr -- \) End animation definition.  
`range,` \( start len -- \) Compile contiguous frames in a sequence.  
 `+anim:` \( stack -- stack loopaddr \) Animation table helper.  Creates an unnamed animation and pushes it onto the given stack.  Terminated with `;anim`.  
`h,` `v,` `hv,` \( n -- \) Applies horizontal/vertical flipping to the given frame index and compiles it.  
  


