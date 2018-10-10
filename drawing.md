# Drawing

A convenient wordset for drawing things on the screen.  

ALLEGRO\_BITMAP's are referred to as "bmp" for short.

The Pen determines the "starting position" of every drawing operation.  In the case of bitmaps, unless otherwise specified, the position represents the top-left corner.

### Dest XY and Current Color

`destxy` \( -- x y \)  Destination x,y for drawing \(for creating your own drawing words.\)  
`fore` \( -- color \) Current drawing color.  
`rgb` \( r g b -- \) Set drawing color.  
`alpha` \( a -- \) Set drawing color alpha.  
`rgba` \( r g b a -- \)

### Bitmap utilities

`onto>` \( bitmap -- &lt;code&gt; \) Set the drawing surface.  
`movebmp` \( src srcx srcy w h -- \) Blit part of a bitmap with no alpha-blending.  
`*bmp` \( w h -- bmp \) Create a bitmap.  
`clearbmp` \( r g b a bmp -- \) Clear a bitmap.  
`backbuf` \( -- bmp \)

### Named colors

`createcolor` \( r\# g\# b\# -- &lt;name&gt; \) \( -- \) Define a named color, that when executed changes the current drawing color.  R, G, and B are given in integers from 0-255.

### Clearing the screen

`backdrop` \( -- \) Clear the drawing surface with the current color

### Bitmaps

`blitf`\( bmp flip \) Draw a bitmap.  Flip is a bitmask: $1 = horizontal, $2 = vertical  
`tblitf` \( bmp flip \) Like `blitf` but it tints the bitmap with the current color.  
`sblitf` \( bmp destw desth flip \) Scale a bitmap.  The destination width and height are in pixels.  
`csrblitf` \( bmp scalex scaley ang flip \) Scale and rotate a bitmap.  The pivot point will be the center of the bitmap.  
`blit` \( bmp \) Same as `0 blitf`  
`tblit` \( bmp \) Same as `0 tblitf`  
`blitrgnf` \(  bmp x y w h flip \) Blit a region of a bitmap.

### Text

`variable fnt` Holds the current font asset. \(Not the ALLEGRO\_FONT.\)  
`variable lmargin` Determines the left margin in pixels.    
  
`chrw` \( font -- w \)   
`chrh`\( font -- h \)  
`strw` \( adr c -- w \)  
`strwh` \( adr c -- w h \)  
`fontw` \( -- w \) Gets the width of the current font.  
`fonth` \( -- h \) Gets the height of the current font.  
`print` \( adr c -- \) Draw a string of text with the current font  
`printr`\( adr c -- \) Same as `print` but right justified.  
`printc` \( adr c -- \) Same as `print` but centered.  
`print+` \( adr c -- \) Same as `print` but the pen will be advanced to just after the drawn text.  
`newline` \( -- \) Moves the pen to the next "row" \(respecting `lmargin`\)

### Primitives

`line` \( destx desty -- \) Draws a line to the given endpoint.  
`+line` \( ofsx ofsy -- \) Draws a line where the endpoint is relative to the pen.  
`line+` \( ofsx ofsy -- \) Same as `+line` but the pen is moved to the endpoint.  
`pixel` \( -- \) Draws a single pixel.  
`rect` \( w h \) Draws a rectangle.  
`rectf` \( w h \) Draws a filled rectangle.  
`rrect` \( w h radiusx radiusy \) Draws a rounded rectangle.  
`rrectf` \( w h radiusx radiusy \) Draws a rounded filled rectangle.  
`oval` \( radiusx radiusy \) Draws an oval \(ellipse\).  
`ovalf` \( radiusx radiusy \) Draws a filled oval \(ellipse\).  
`circ` \( radius \) Draws a circle.  
`circf` \( radius \) Draws a filled circle.

### Misc.

`2transform` \( x y transform -- x y \)  Transform coordinates  
`2screen` \( x y -- x y \) Convert coordinates into screen space.  
`clip>` \( x y w h -- &lt;code&gt; \) Set the clipping rectangle.  It will be restored to the previous one after the code body executes.

