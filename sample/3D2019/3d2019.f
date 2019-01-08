empty
[undefined] 3d [if]
    include 3dpack/3dpack.f
    gild
[then]

depend sample/3d2019/tools.f
depend ramen/lib/upscale.f
depend ramen/lib/tweening.f
depend afkit/ans/param-enclosures.f

objlist models

s" sample/3d2019/data/chr001.png" image: chr001.png   
s" sample/3d2019/data/chr002.png" image: chr002.png
s" sample/3d2019/data/chr003.png" image: chr003.png
s" sample/3d2019/data/2018.png" image: 2018.png
s" sample/3d2019/data/2019.png" image: 2019.png
s" sample/3d2019/data/star.png" image: star.png

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

var lifetime

: tri  2 * 1 - abs 1 swap - ;

-1350 0 0 at3
: *letter ( #char - )
    dup bl = if drop 200 0 0 +at3 ;then
    [char] A - 1p
    models one  !3pos  chr !  quad.mdl mdl !
    200 0 0 +at3
    100 200 100 scl 3!
    draw>  
        chr001.png tex !
        !chrcoords
        0.66 5 1( pos >x @ 1000 + 5 / ) tint lch!
        tint 3@ rgb tinted model
        chr002.png tex !
        1( roll @ 360 + 175 + 180 mod 180 / 1 swap - tri 2 * ) 1 90 tint lch!  \ fake lighting
        tint 3@ rgb tinted model
;

: bouncybounce
    0 12 timespan    pos >y 0 100 quadratic out ease
    12 12 timespan   pos >y 100 0 quadratic in ease
    24 8  timespan   pos >y 0 30 quadratic out ease
    32 8  timespan   pos >y 30 0 quadratic in ease
;
: spinnyspin
    180 90 timespan  roll -360 0 overshoot inout ease
;

: flyon
    0 240 timespan
    pos >z 0 -1200  sine out ease
    pos >y 1500 0   sine out ease
    roll 360 4 * 0  sine out ease
    pan -360 2 * 0  sine out ease
;    
: dance
    ['] spinnyspin 360 every    
    ['] bouncybounce 360 every
;

: *image   stage one img !  ;
: csprite  img @ imagewh 0.5 0.5 2* cx 2!  sprite ;


: *star
    star.png *image 2 2 sx 2!
    1 0.5 0.5 tint 3!
    draw> csprite 5 ang +! vx 2@ 0.97 dup 2* vx 2!
;

0 value time
: pulse  4.5 +to time  1( 7 time sin 1.6 * + ) dup ;
: wobble time 0.48 * sin 30 * >rad ;

: (2019)  displaywh 2 2 2/ at  yellow  2019.png >bmp pulse wobble 0 xblit ;

: *2019  stage one draw> (2019) ;  


: burst
    displaywh 0.5 0.5 2* at
    200 for *star 360 rnd 5 45 between vec vx 2! loop ;


: anim  flyon 0 perform> 360 pauses dance end ;


create message ," HAPPY NEW YEAR"
message value pointer

: nextchar  #1 +to pointer  pointer c@ ?dup if { *letter anim } 5 pauses then ;

: present
    ['] burst 260 after
    ['] *2019 260 after
    *task pointer perform> c@ 1p for nextchar loop end
;

: think  tasks multi  stage acts  models acts  stage multi  models multi ;

: +alphatex
    ALLEGRO_ALPHA_FUNCTION ALLEGRO_RENDER_GREATER al_set_render_state
    ALLEGRO_ALPHA_TEST #1 al_set_render_state
    ALLEGRO_ALPHA_TEST_VALUE 0 al_set_render_state
;
: -alphatex
    ALLEGRO_ALPHA_TEST #0 al_set_render_state
;

: render  +alphatex 3d ['] draws catch -alphatex 2d throw ;

:now  show> ramenbg 0 0 at upscale> stage draws  models render ;
:now  step> think physics +tweens stage sweep ;
present
