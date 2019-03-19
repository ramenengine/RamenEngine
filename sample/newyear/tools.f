extend: _actor
    %v3d sizeof field vel
;class

( misc )
: situate  at3@ pos 3! ;
: -vel    0 0 0 vel 3! ;

( cuboid struct )
struct %cuboid
    %cuboid %rect sizeof sfield cuboid>rect
    %cuboid svar cuboid.z
    %cuboid svar cuboid.d

: cz@    cuboid.z @ ;              : cz!    cuboid.z ! ;
: d@    cuboid.d @ ;              : d!    cuboid.d ! ;
: cz2@    dup cz@ swap d@ + ;
: cz2!    dup cz@ rot - swap d! ;
: xyz@   dup xy@ rot cz@ ;
: xyz!   dup >r cz! r> xy! ;
: whd@   dup wh@ rot d@  ;
: whd!   dup >r d! r> wh! ;
: xyzwhd@  dup >r xyz@ r> whd@ ;
: xyzwhd!  dup >r whd! r> xyz! ;
: xyz2@   dup xy2@ rot cz2@ ;
: xyz2!   dup >r cz2! r> xy! ;

( 3D actors )
extend: _role
    action start ( - )
    action idle ( - )
    action walk ( - )
    action turn ( angle )
;class

extend: _actor
    var dir \ angle
    var clipx  var clipy
    var flags <hex
    3 cells field startpos
    %cuboid sizeof field ihb  \ interaction hitbox; relative to position
;class

0 0 0 16 16 16 _actor prototype 's ihb xyzwhd!

\ : ipos     pos 3@ ihb xyz@ 3+ ;
\ : toward   ( obj - x y )  >{ ipos } ipos 2- angle uvec ;
: !startpos pos 3@ startpos 3! ;


( 3D actor collisions )
0 value you

: ibox  ( - x y x y )  pos 2@ ihb xy@ 2+ ihb wh@ aabb ;
: ibreadth  ( - z z )  pos z@ ihb cz@ + ihb d@ over + ;
: cross?  ( lo hi lo hi - flag )  rot >= >r swap <= r> or ;
: with  ( - ) me to you ;
: hit?  ( attributes - flag )  \ usage: <subject> as with ... <object> as <bitmask> hit?
    flags @ and 0= if 0 ;then
    me you = if 0 ;then
    ibreadth you >{ ibreadth } cross? dup -exit drop
    ibox you >{ ibox } overlap? ;

\ : draw-ibox  cbox 2over 2- 2swap 2pfloor at red 1 1 2+ rect ;
: on-top  act> me stage push ;
\ : show-iboxes  stage one  on-top  draw> stage each> as draw-ibox ;


( misc 3d stuff )
objlist: models
: 3from  ( x y z obj - )  's pos 3@ 3+ at3 ;
: !vcolor  ( ALLEGRO_VERTEX - ) >r fore 4@ r> ALLEGRO_VERTEX.r 4! ;
: tmodel  tint 3@ rgb ['] !vcolor mdl @ veach model ;
: uv!  ( u v n - )  >r 2af r> mdl @ v[] ALLEGRO_VERTEX.u 2! ;
: !3pos  at3@ pos 3! ;
: *model  ( model - )  models one mdl ! !3pos ;
: tri  2 * 1 - abs 1 swap - ;
: +alphatex
    ALLEGRO_ALPHA_FUNCTION ALLEGRO_RENDER_GREATER al_set_render_state
    ALLEGRO_ALPHA_TEST #1 al_set_render_state
    ALLEGRO_ALPHA_TEST_VALUE 0 al_set_render_state
;
: -alphatex
    ALLEGRO_ALPHA_TEST #0 al_set_render_state
;


( lowres 3d loop )
depend ramen/lib/tweening.f
depend ramen/lib/upscale.f
: think  tasks multi  stage acts  models acts  stage multi  models multi ;
: render  +alphatex 3d ['] draws catch -alphatex 2d throw ;
: scaledwh  viewwh globalscale dup 2* ;
: cdraws  scaledwh 2halve translate tpush draws tpop ;
:now  show> ramenbg 0 0 at upscale> 2d stage cdraws  models render ;
:now  step>  think physics  +tweens  sweep ;
