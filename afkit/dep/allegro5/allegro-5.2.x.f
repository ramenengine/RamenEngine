decimal \ important

[undefined] #defined [if]
: #define  create  0 parse bl skip evaluate ,  does> @ ;
: #fdefine  create  0 parse bl skip evaluate sf,  does> sf@ ;
[then]

: cfield  create over , + does> @ + ;
: cvar  cell cfield ;
: fload   include ;
: ?constant  constant ;

\ intent: speeding up some often-used short routines
\ usage: macro:  <some code> ;  \ entire declaration must be a one-liner!
: macro:  ( - <code> ; )  \ define a macro; the given string will be evaluated when called
  create immediate
  [char] ; parse string,
  does> count evaluate ;

[undefined] ALLEGRO_VERSION_INT [if]
    [defined] linux [if] $5020401 [else] $5020300 [then]
    constant ALLEGRO_VERSION_INT
[then]

ALLEGRO_VERSION_INT $ffffff00 and $5020300 = [if] cd afkit/dep/allegro5/5.2.3 [then]
ALLEGRO_VERSION_INT $ffffff00 and $5020400 = [if] cd afkit/dep/allegro5/5.2.4 [then]

cr .( Loading Allegro ) ALLEGRO_VERSION_INT h. .( ... )

[defined] linux [if]
    create libcmd 256 allot
    : linux-library
        s" library " libcmd place
        0 parse libcmd append
        s" .so.5.2" libcmd append
        libcmd count evaluate
    ;
    linux-library liballegro
    linux-library liballegro_memfile
    linux-library liballegro_primitives
    linux-library liballegro_acodec
    linux-library liballegro_audio
    linux-library liballegro_color
    linux-library liballegro_font
    linux-library liballegro_image
    linux-library liballegro_font
[else]
    : linux-library  0 parse 2drop ;
        [defined] allegro-debug [if]
            library allegro_monolith-debug-5.2.dll
        [else]
            library allegro_monolith-5.2.dll
        [then]
    cd ../../../..
[then]

: void ;

: /* postpone \ ; immediate

    
: [COMPATIBLE]   ( ver subver rev -- )
   8 lshift swap 16 lshift rot 24 lshift or or  ALLEGRO_VERSION_INT $ffffff00 and  > if 0 parse 2drop then ;


\ ----------------------------- load files --------------------------------

include afkit/dep/allegro5/allegro5_01_general.f
include afkit/dep/allegro5/allegro5_02_events.f
include afkit/dep/allegro5/allegro5_03_keys.f
include afkit/dep/allegro5/allegro5_04_audio.f
include afkit/dep/allegro5/allegro5_05_graphics.f
include afkit/dep/allegro5/allegro5_06_fs.f
include afkit/dep/allegro5/allegro5_07_misc.f

\ =============================== END ==================================

.( Done )
