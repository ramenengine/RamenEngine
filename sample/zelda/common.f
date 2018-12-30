\ ===================================================================================
\ Goals
\ 1. I don't want to have to create a function for every object
\ 2. I want to be able to define objects from within Ramen
\ 3. I want all objects to have enough common logic
\    to make simple games with no code

\ maybe don't store in a binary file
\  a human-readable format (maybe a custom one, using Forth) would be more futureproof.

\ first allocate the space for the datatable
\ load stuff into the datatable
\ then load all the code, making connections to it

\ object type index...
\   types and/or flags should be common to objects AND tiles
\ ===================================================================================



struct %def
    %def #16 sfield def>basename <cstring
    %def svar def.gfxtype   \ 0 = nothing, 1 = circle, 2 = box, 3 = sprite, 4 = animation
    %def #32 sfield def>imagepath <cstring
    %def svar def.regiontablesize
    %def svar def.regiontable <adr
    %def %rect sizeof sfield def>mhb \ map hitbox
    %def 8 cells sfield def>drops
    %def var def.role <adr
    %def object-maxsize sfield def>template
        var objtype
        var quantity    
        var bitmask <hex        \ what the object should interact with
        var flags   <hex        \ what attributes the object has
        %rect sizeof field ihb \ interaction hitbox
        var hp
        var maxhp
        var atk

action start

create objdefs %def sizeof 255 * /allot 

: def  1 - [ %def sizeof ]# * objdefs + ;
: field+  >body @ + ;
: := ( baseadr - <fieldname> <values...> baseadr )
    0 locals| n |
    dup >r ' field+ ( fieldadr )
        begin bl parse ?dup while
            evaluate over !
            cell+
        repeat
        ( fieldadr c-addr ) drop drop
    r>
;
: $= ( baseadr - <fieldname> <string> baseadr )
    dup ' field+ >r 0 parse r> place ;
: drop  drop ;


\            notes
\ *<type>    early version: #<type> *obj
\ /<type>    early version: #<type> /obj
\ #<type>    created from the datatable
\ 

: >def  's objtype @ def ;
: template  objdef def>template ;

: (clip)  clipx 2@ cx 2@ 2- 16 16 ;
: obj-sprite #gfxclip flag? if (clip) clip> then spr @ nsprite ;
: obj-animate  #gfxclip flag? if (clip) clip> then sprite+ ;

: gfx-sprite draw> obj-sprite ;
: gfx-animation draw> obj-animate ;
: ?flash  if rndcolor then ;
: gfx-circle draw> 8 8 +at  blue damaged @ ?flash 8 circf ;
: gfx-box draw> blue damaged @ ?flash 16 16 rectf ;

create graphics-types
    ' noop ,
    ' gfx-circle ,
    ' gfx-box ,
    ' gfx-sprite ,
    ' gfx-animation , 
: ?graphics graphics-types njump ;

: ?find  dup -exit find ;

\ the slow way.  will speed up later
: @template  /objhead + me /objhead + object-maxsize /objhead - move ;


( object and tile flags )
#1
bit #directional
bit #gfxclip
bit #important
bit #solid
bit #collider
bit #inair
bit #ground
bit #fire
bit #water
bit #human
bit #item
bit #entrance
bit #enemy
value nextflag

: ?solid  #solid flag? -exit  physics> tilebuf collide-tilemap ;

: /obj  ( objtype - )
    objtype !
    me >def locals| d |
    d def>template @template
    d def>imagepath ?find if execute else drop 0 then img !
    d def.regiontable @ rgntbl !
    d def.gfxtype @ ?graphics
    d def>mhb wh@ mbw 2!
    d def.role @ ?dup if role ! then
    ?solid
    start
;


: *obj  ( objtype - )
    dir @
        stage one swap /obj
        #directional flag? if dir ! else drop then 
;

previous