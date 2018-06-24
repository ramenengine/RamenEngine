# Module References

RAMEN is divided into core modules and optional libraries.

## Core Modules

### Structs (struct.f)

Simple data structure support.  Provisions for type information are there but aren't currently actually used.

|struct|( -- \<name\> )|Declare a struct
|sfield|( struct bytes valtype -- \<name\> )  ( adr -- adr+n )|Declare a struct field
|svar|( struct valtype -- \<name\>|Short for `cell <type> sfield <name>`

The naming convention for fields is `<struct>.<fieldname>`.  This will help with readability and avoiding name collisions.  It'll also encourage you to have short struct names.

Example:
```
struct color
    color 0 svar color.r
    color 0 svar color.g
    color 0 svar color.b
    color 0 svar color.a
```

### Fixed-point operators (fixops.f)

Low-level words for working with fixed-point numbers.

Fixed-point numbers in RAMEN have a 24-bit integer part and a 12-bit fractional part.  They're meant to enable sub-pixel motion of objects and rough geometrical calculations.  If you need more mathematical precision, use floats and convert, bit shifting, or fractions (e.g. `*/`.)

Many Forth words are redefined to use  fixed-point numbers.  This, combined with fixed-point literal support, makes things almost completely transparent.  The need to work with integers is less frequent. A simple way to remember if you need a fixed-point word or an integer word is if the number is a quantity of bytes or not.

These words are really important for you to learn as they're used *everywhere* in RAMEN.

#### Conversion

| 1p | ( i -- n ) | Convert int to fixed
| 2p | ( i i -- n n ) | Convert int(s) to fixed's
| 3p | ( i i i -- n n n ) | Convert int(s) to fixed's
| 4p | ( i i i i -- n n n n ) | Convert int(s) to fixed's
| 2i | ( n -- i ) | Convert fixed to int
| 1i | ( n n -- i i ) | Convert fixed's to ints
| 3i | ( n n n -- i i i ) | Convert fixed's to ints
| 4i | ( n n n n -- i i i i ) | Convert fixed's to ints
| 1f | ( n -- f: n ) | Convert fixed to float
| 2f | ( n n -- f: n n ) | Convert fixed's to floats
| 3f | ( n n n -- f: n n n ) | Convert fixed's to floats
| 4f | ( n n n n -- f: n n n n ) | Convert fixed's to floats
| f>p | ( f: n -- n ) | Convert float to fixedp

#### Math

| pfloor  | ( n -- n ) | Round down
| pceil   | ( n -- n ) | Round up
| 2pfloor | ( n n -- n n ) |
| 2pceil  | ( n n -- n n ) |
| *       | ( n n -- n )   | Multiply
| /       | ( n n -- n )   | Divide
| /mod    | ( n n -- r q ) | Slash-mod (returns remainder and quotient)

`-` and `+` work with integers and fixed-point numbers already so those are left alone.

#### External library conversion

| 1af | ( n -- sf )      | Convert fixedp to float on data stack.
| 2af | ( n n -- sf sf ) | Convert fixedp to float on data stack.
| 3af | ( n n n -- sf sf sf ) | Convert fixedp to float on data stack.
| 4af | ( n n n n -- sf sf sf sf ) | Convert fixedp to float on data stack.

#### Advanced Math

| cos   ( deg -- n )           | Cosine
| sin   ( deg -- n )           | Sine
| acos  ( n -- deg )           | Inverse Cosine
| asin  ( n -- deg )           | Inverse Sine
| lerp  ( src dest factor -- ) | Interpolate
| sqrt  ( n -- n )             | Square root
| atan  ( n -- n )             | Arctangent
| atan2 ( n n -- n )           |
| log2  ( n -- n )             | Logarithm
| \>rad  ( n -- n )            | Convert degrees to radians
| rescale | ( n min1 max1 min2 max2 -- n ) | Rescale a number proportionally from one range to another
| anglerp | ( src dest factor -- ) Interpolate angles

#### Integers

|i*|Integer multiply|
|i/|Integer divide|

#### Color unpacking

| : >rgba | ( val -- r g b a ) | Unpack hex RGBA to fixedp components (0 ~ 1.0)
| : >rgb  | ( val -- r g b )   | Unpack hex RGB to fixedp components (0 ~ 1.0)

#### On-stack vectors

`2+` and `2-` are defined in `roger.f`.  Other double number words are provided in the standard.

| 2*   | ( x y x y -- x y ) | Two-Multiply
| 2/   | ( x y x y -- x y ) | Two-Divide
| 2mod | ( x y x y -- x y ) | Two-Mod (modulus)

#### Modes

Generally you shouldn't be writing code that depends on the current base, but on occasion it's convenient, for instance when compiling  standard Forth code into a RAMEN project.

| fixed | Switch to fixed point mode.
| decimal | Switch to decimal mode.

### Fixed-point literals (fixedp.f)

This file is actually packaged with AllegroForthKit.

Fixed-point literal support is required by RAMEN.   At the moment Forth systems must have a mechanism for extending the interpreter for RAMEN to compile.

All numbers that aren't qualified by a base prefix such as `$` are interpreted as fixed point.  To force integer, prefix numbers with `#`.

The theory behind this is that you can write literals naturally, with no requirement to use a decimal point, making fixed-point number use almost transparent.

The quickest way to understand this is to try it.  After loading RAMEN into Forth, type `1.5 3 + .` and press `<enter>`.   Notice that the decimal point is optional.

### Assets (assets.f)

The asset system lets you declare assets in your code which will get automatically loaded when your game starts.

#### Images (image.f)

Stores info about an Allegro bitmap.

#### Fonts (font.f)

#### Buffers (buffer.f)

#### Samples (sample.f)

### Color (color.f)

### Objects (obj.f)

RAMEN's polymorphic data structure.  See [Objects](objects.md)

### Cellstacks (cellstack.f)

### Publish (publish.f)

See [Publishing Games](publish.md)

## Libraries