empty
include 3dpack/3dpack.f
480 240 resolution

depend sample/tools.f
depend sample/events.f
depend sample/3d2019/tools.f
depend ramen/lib/tweening.f
depend afkit/ans/param-enclosures.f

s" sample/3d2019/data/chr001.png" image: chr001.png   
s" sample/3d2019/data/chr002.png" image: chr002.png
s" sample/3d2019/data/chr003.png" image: chr003.png
s" sample/3d2019/data/2019.png" image: 2019.png
s" sample/3d2019/data/star.png" image: star.png

depend sample/3d2019/quad.f
depend sample/3d2019/tools.f

extend: _actor
    var chr                                         \ ascii code (fixedp)
    var lifetime                                    \ counter
;class

( letter )
\ : tmodel  tint 3@ rgb mdl @ veach> !vcolor model ;  \ this is wrong but it looks awesome (uncomment to see it)
: !chrcoords                                        \ set up texture coords
    chr @ 16 /mod 8 16 2* 1 1 2- locals| v u |
    u v 16 +     0 uv!                                  
    u v          1 uv!
    u 8 + v      2 uv!
    u 8 + v 16 + 3 uv!
;
: adv  200 0 0 +at3 ;                               \ move pen to next letter's position
: ?bl  dup bl = if drop adv r> drop ;then ;         \ skip blanks (spaces)
: *letter   ( #char - )                             \ create a letter
    quad.mdl *model  ( #char ) ?bl [char] A - 1p  chr !  \ create quad, set ascii character,
    100 200 100 scl 3!  adv                         \ scale it (100,200,100) and advance the pen
    draw>  
        chr001.png tex !                            \ assign texture to inner part
        !chrcoords
        0.66 5 1( pos >x @ 1000 + 5 / ) tint lch!   \ color depends on position
        tmodel                                      \ draw textured model
        chr002.png tex !                            \ assing texture to outer part
        1( roll @ 360 + 175 + 180 mod 180 / 1 swap - tri 2 * ) 1 90 tint lch!  \ fake gold effect
        tmodel                                      \ draw it again with different texture and color
;
: bouncybounce
    0 12 timespan    pos >y 0 100 quadratic out tween
    12 12 timespan   pos >y 100 0 quadratic in tween
    24 8  timespan   pos >y 0 30 quadratic out tween
    32 8  timespan   pos >y 30 0 quadratic in tween
;
: spinnyspin
    180 90 timespan  roll -360 0 overshoot inout tween
;
: flyon
    0 240 timespan
    pos >z 0 -1200  sine out tween
    pos >y 1500 0   sine out tween
    roll 360 4 * 0  sine out tween
    pan -360 2 * 0  sine out tween
;    
: spin+bounce
    ['] spinnyspin 360 every    
    ['] bouncybounce 360 every
;
: /dance  flyon ['] spin+bounce 360 after ;

( stars )
: /outward  act>  5 ang +!  vx 2@ 0.97 dup 2* vx 2! ;                       \ spin and decelerate outward
: *star  star.png *csprite /outward  2 2 sx 2!  1 0.5 0.5 tint 3! ;         \ create a start, scale (2,2), pink color
: burst   centered 200 for *star 360 rnd 5 45 between vec vx 2! loop ;      \ create a bunch of stars,
                                                                            \ setting angle to random value and
                                                                            \ velocity to random value between 5 and 45

( 2019 )
: pulse  4.5 lifetime +!  1( 7 lifetime @ sin 1.6 * + ) dup sx 2! ;         \ apply sine formula to scale
: wobble lifetime @ 0.48 * sin 30 * ang ! ;                                 \ apply sine formula to angle
: *2019  yellow 2019.png *csprite act> pulse wobble ;                       \ create the 2019 sprite, anchored to its center
                                                                            \ and make it pulse and wobble.

( message )
create message ," HAPPY NEW YEAR"
: nextchar  dup c@ { *letter /dance } #1 + ;                                \ takes an address and returns it, inc. by #1

( demo )
: demo 
    ['] burst 260 after
    ['] *2019 260 after
    *task 0 perform>   \ create a task and assign it the following code
        -1350 0 0 at3  \ starting position for first letter
        \ go through and create letters, staggering them in time,
        \ and then END the task (deleting it):
        message count 1p for nextchar 5 pauses loop end                     
;
demo
