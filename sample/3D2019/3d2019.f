depend sample/3d2019/tools.f
depend ramen/lib/upscale.f

s" sample/3d2019/data/chr001.png" image: chr001.png   
s" sample/3d2019/data/chr002.png" image: chr002.png
s" sample/3d2019/data/chr003.png" image: chr003.png

variable orbita  
variable orbith
180 orbita ! 
50 orbith !


( Camera )
:slang look-at-subject  ( subject - )
    locals| m |
    m 's pos >y @ orbith @ + pos >y !
    m orbita @  m 's pan @ +   200  orbitted  pos >z !  pos >x ! \ situate
    m pan-towards pan ! \ toward
    m 200 tilt-towards tilt !
    camera-transform
;
: update-cam  ( subject camera -- )  dup to cam  >{ look-at-subject } ;

( quad model )
create quad.mdl TRIANGLE_STRIP modeldata
quad.mdl vertices:
    white 
    -1 -1 0 0 1 v,  \ btm left
    -1  1 0 0 0 v,  \ top left
     1  1 0 1 0 v,  \ top right
     1 -1 0 1 1 v,  \ btm right
;vertices
quad.mdl indices:
    0 , 1 , 2 ,
    0 , 2 , 3 , 
;indices

var chr

: !vcolor  ( ALLEGRO_VERTEX - ) >r fore 4@ r> ALLEGRO_VERTEX.r 4! ;
: tinted  mdl @ veach> !vcolor ;


: uv!  ( u v n - )  >r 2af r> mdl @ v[] ALLEGRO_VERTEX.u 2! ;
: !chrcoords
    chr @ 16 /mod 8 16 2* 1 1 2- locals| v u |
    u v 16 + 0 uv!
    u v 1 uv!
    u 8 + v 2 uv!
    u 8 + v 16 + 3 uv!
;
: !3pos  at3@ pos 3! ;
: /spinning
    act>
\    -4 pan +!
    1 tilt +!
\    1 roll +!
; 

var lifetime

-1400 0 0 at3
: *letter ( #char - )
    dup bl = if drop 200 0 0 +at3 ;then
    [char] A - 1p
    stage one  !3pos  chr !  quad.mdl mdl !
    200 0 0 +at3
    100 200 100 scl 3!
    draw>
        chr001.png tex !
        !chrcoords
        white tinted model
        chr002.png tex !
        0.5 0.5 lifetime @ tint lch!
        3 lifetime +! 
        tint 3@ rgb tinted model
;


:now  show> ramenbg upscale> black backdrop 3d stage draws 2d ;
:now  step> think tasks multi physics stage sweep ;

: flyon
    100 pos >z !
    0 perform>
        180 for
            i 2 / sin -1500 * dup 1500 + pos >y ! pos >z !
            
            180 i - 2 / 90 + sin 0.25 + 1000 * tilt !
            
            pause
        loop 0 tilt ! ;
: spin ;
: flyaway ;



create message ," HAPPY NEW YEAR"
message value pointer

: nextchar  #1 +to pointer  pointer c@ { *letter flyon } ;

: present  *task pointer perform> c@ 1p for nextchar 15 pauses loop end ;


\ ui on
\ char H *letter
\ me value that
\ :now  stage one on-top draw> wipe that o. ;
\ that as

repl off wipe ' present 240 after

ALLEGRO_ALPHA_FUNCTION ALLEGRO_RENDER_GREATER al_set_render_state
ALLEGRO_ALPHA_TEST #1 al_set_render_state
ALLEGRO_ALPHA_TEST_VALUE 0 al_set_render_state

\ ALLEGRO_DEPTH_TEST 0 al_set_render_state
\ ALLEGRO_DEPTH_WRITE 0 al_set_render_state