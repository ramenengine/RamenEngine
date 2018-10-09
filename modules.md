# Module References

## Structs - struct.f

Ramen uses a simple data structure facility. Provisions for type information are there but aren't currently being used.

| word | stack diagram | description |
| :--- | :--- | :--- |
| struct | \( --  \) | Declare a struct |
| sfield | \( struct bytes valtype --  \)  \( adr -- adr+n \) | Declare a struct field |
| svar | \( struct valtype -- \ | Short for `cell <type> sfield <name>` |

The naming convention for fields is `<struct>.<fieldname>`. This will help with readability and avoiding name collisions. It will be good to give your structs short and simple names.

Example:

```text
struct color
    color 0 svar color.r
    color 0 svar color.g
    color 0 svar color.b
    color 0 svar color.a
```

## Fixed-point operators - fixops.f

See [Fixed-Point Numbers](https://rogerlevy.github.io/afkit/fixedp.html) on AllegroForthKit's documentation for more info.

These are low-level words for working with fixed-point numbers.

Fixed-point numbers in Ramen have a 20-bit integer part and a 12-bit fractional part. They're meant to enable sub-pixel motion of objects and rough geometrical calculations. If you need more mathematical precision, use floats and convert, bit shifting, or fractions \(e.g. `*/`.\)

The need to work with integers is infrequent, so many Forth words are redefined to use fixed-point numbers. This, combined with fixed-point literal support, makes working with fixed-point in Ramen almost transparent. An easy way to remember if you need a fixed-point word or an integer word is if the number is a quantity of bytes or not.

These words are really important for you to learn as they're used _everywhere_ in Ramen.

### Conversion

| word | stack diagram | description |
| :--- | :--- | :--- |
| 1p | \( i -- n \) | Convert int to fixed |
| 2p | \( i i -- n n \) | Convert 2 int\(s\) to fixed's |
| 3p | \( i i i -- n n n \) | Convert 3 int\(s\) to fixed's |
| 4p | \( i i i i -- n n n n \) | Convert 4 int\(s\) to fixed's |
| 1i | \( n -- i \) | Convert fixed to int |
| 2i | \( n n -- i i \) | Convert 2 fixed's to ints |
| 3i | \( n n n -- i i i \) | Convert 3 fixed's to ints |
| 4i | \( n n n n -- i i i i \) | Convert 4 fixed's to ints |
| 1f | \( n -- f: n \) | Convert fixed to float |
| 2f | \( n n -- f: n n \) | Convert 2 fixed's to floats |
| f&gt;p | \( f: n -- n \) | Convert float to fixedp |

### Math

| word | stack diagram | description |
| :--- | :--- | :--- |
| pfloor | \( n -- n \) | Round down |
| pceil | \( n -- n \) | Round up |
| 2pfloor | \( n n -- n n \) |  |
| 2pceil | \( n n -- n n \) |  |
| \* | \( n n -- n \) | Multiply |
| / | \( n n -- n \) | Divide |
| /mod | \( n n -- r q \) | Slash-mod \(returns remainder and quotient\) |

`-` and `+` work with integers and fixed-point numbers already so those are left alone.

### External library conversion

| word | stack diagram | description |
| :--- | :--- | :--- |
| 1af | \( n -- sf \) | Convert fixedp to float on data stack. |
| 2af | \( n n -- sf sf \) | Convert fixedp to float on data stack. |
| 3af | \( n n n -- sf sf sf \) | Convert fixedp to float on data stack. |
| 4af | \( n n n n -- sf sf sf sf \) | Convert fixedp to float on data stack. |

### Advanced Math

| word | stack diagram | description |
| :--- | :--- | :--- |
| cos | \( deg -- n \) | Cosine |
| sin | \( deg -- n \) | Sine |
| acos | \( n -- deg \) | Inverse Cosine |
| asin | \( n -- deg \) | Inverse Sine |
| lerp | \( src dest factor -- \) | Interpolate |
| sqrt | \( n -- n \) | Square root |
| atan | \( n -- n \) | Arctangent |
| atan2 | \( n n -- n \) |  |
| log2 | \( n -- n \) | Logarithm |
| &gt;rad | \( n -- n \) | Convert degrees to radians |
| rescale | \( n min1 max1 min2 max2 -- n \) | Rescale a number proportionally from one range to another |
| anglerp | \( src dest factor -- \) | Interpolate angles |

### Integers

| word | description |
| :--- | :--- |
| i\* | Integer multiply |
| i/ | Integer divide |

### Color unpacking

| word | stack diagram | description |
| :--- | :--- | :--- |
| &gt;rgba | \( val -- r g b a \) | Unpack hex RGBA to fixedp components \(0 ~ 1.0\) |
| &gt;rgb | \( val -- r g b \) | Unpack hex RGB to fixedp components \(0 ~ 1.0\) |

### On-stack vectors

| word | stack diagram | description |
| :--- | :--- | :--- |
| 2+ | \( x y x y -- x y \) | Two-Add |
| 2- | \( x y x y -- x y \) | Two-Sub |
| 2\* | \( x y x y -- x y \) | Two-Multiply |
| 2/ | \( x y x y -- x y \) | Two-Divide |
| 2mod | \( x y x y -- x y \) | Two-Mod \(modulus\) |

`2+` and `2-` are redefined in AFKIT in `roger.f`. \(The standard's versions aren't useful in the engine's program domain.\) Other double number words are provided in the standard.

### Modes

Generally you shouldn't be writing code that depends on the current base, but on occasion it's convenient, for instance when compiling standard Forth code into a Ramen project.

| word | description |
| :--- | :--- |
| fixed | Switch to fixed point mode. |
| decimal | Switch to decimal mode. |

## Fixed-point literals - fixedp.f

This file is actually packaged with AllegroForthKit.

Fixed-point literal support is required by Ramen. At the moment Forth systems must have a mechanism for extending the interpreter for Ramen to compile.

All numbers that aren't qualified by a base prefix such as `$` are interpreted as fixed point. To force integer, prefix numbers with `#`.

The theory behind this is that you can write literals naturally, with no requirement to use a decimal point, making fixed-point number use almost transparent.

The quickest way to understand is to try it. After loading Ramen into Forth, type `1.5 3 + .` and press `<enter>`. Notice that the decimal point is optional.

## Assets - assets.f

The asset system lets you declare assets in your code which will get automatically loaded when your game starts. It also lets you add new asset types which know how to load themselves on initial game executable start.

All assets have the following fields:

| field | type | description |
| :--- | :--- | :--- |
| srcfile | cstring | Path of source file |
| \ | xt | "Reloader" XT |

The reloader is a unnamed field. You can, however, directly `reload ( asset -- )` an asset.

Additional asset-related words:

| word | stack diagram | description |
| :--- | :--- | :--- |
| assets&gt; | \( --  \) \( asset -- \) | Execute remainder of colon definition on each asset in the order they were declared. |
| \#assets | \( -- n \) | Total number of declared assets. |
| .asset | \( asset -- \) | Print some info about an asset |
| .assets | \( -- \) | List all assets |

`findfile ( path c -- path c )` Search for an asset's file first in these locations, in this order:

* Relative to the current working directory
* Relative to the current source file being compiled.
* Relative to `<project folder>/src/`.

  If not found, abort and throw an error message.

### Defining an asset type

An asset type is a struct that extends the header described above. Defining an asset type is largely the same as defining a struct.

You will also need to define the asset loader and asset declaration word.

See the asset definition source files for examples.

| word | stack diagram | description |
| :--- | :--- | :--- |
| assetdef | \( --  \) | Define an asset type \(or "asset definition"\) |
| register | \( reloader-xt asset -- \) | Add asset to the preload list and assign its reloader. |

### The preloader

## Images - image.f

Asset that stores info about an Allegro bitmap, as well as information necessary to address "subimages" in the bitmap - that is, to treat it as an image strip, commonly used in games.

All of the fields are public.

| field | type | description |
| :--- | :--- | :--- |
| image.bmp | ALLEGRO\_BITMAP address | Bitmap pointed to by the image |
| image.subw | fixedp | Subimage width |
| image.subh | fixedp | Subimage height |
| image.fsubw | float | Same as `subw` |
| image.fsubh | float | Same as `subh` |
| image.subcols | fixedp | Number of subimage columns |
| image.subrows | fixedp | Number of subimage rows |
| image.subcount | fixedp | Total number of subimages |
| image.orgx | fixedp | Origin X \(to be treated by a game as the center of rotation and scaling\) |
| image.orgy | fixedp | Origin Y |

### Image management

| word | stack diagram | description |
| :--- | :--- | :--- |
| imagew | \( -- \) | Get image width |
| imageh | \( -- \) | Get image height |
| imagewh | \( -- \) | Get image dimensions |
| /origin | \( -- \) | Set image's origin to its center. |
| reload-image | \( image -- \) | Load bitmap from its stored path and initialize the origin. |
| init-image | \( path c image -- \) | Initialize image \(calling `reload-image`.\) |
| image: | \( path count --  \) | Declare an image, loading it at compile-time. |
| &gt;bmp | \( image -- bitmap \) | Get Allegro bitmap |
| load-image | \( path count image -- \) | Load a new bitmap into an image and change its path.  The old bitmap is not destroyed. |
| free-image | \( image -- \) | The bitmap is destroyed. Note that the pointer is not cleared. |

### Subimages

| word | stack diagram | description |
| :--- | :--- | :--- |
| subdivide | \( tilew tileh image -- \) | Initialize the subimage fields. |
| &gt;subxy | \( n image -- x y \) | Get the coordinates of the top left of a subimage. |
| &gt;subxywh | \( n image -- x y w h \) | Get the top-left coordinates, and the dimensions of a subimage. |
| afsubimg | \( n image -- ALLEGRO\_BITMAP fx fy fw fh \) | Get the bitmap and the rectangle values as floats of a subimage.  \(Useful for passing to the Allegro library.\) |
| imgsubbmp | \( n image -- subbitmap \) | Create an ALLEGRO\_SUBBITMAP that stores info about a subimage. |

## Fonts - font.f

## Buffers - buffer.f

## Samples - sample.f

## Color - color.f

## Objects - obj.f

Ramen's special data structure for game objects. See [Objects](objects.md)

## Cellstacks  - cellstack.f

## Publish - publish.f

See [Publishing](publish.md)

## Tiled - tiled.f

See [Tiled](tiled.md)
