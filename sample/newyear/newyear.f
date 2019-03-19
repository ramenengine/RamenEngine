\ here's a little demo i made to bring in the new year.
\ it demonstrates use of 3dpack and tweens.

include ramen/ramen.f                   \ goes first
project: sample/newyear                 \ sets the project's root folder so that LD knows where to look
                                       
empty                                   \ close any already loaded project
include 3dpack/3dpack.f                 \ load the 3d packet
nativewh 4 4 2/ resolution              \ set the virtual screen resolution (depends on display)
\ 320 240 resolution                      \ fixed resolution


depend sample/tools.f                   \ common toolkit for the samples
depend sample/events.f                  \ event system
depend ramen/lib/tweening.f             \ tweening support
depend afkit/ans/param-enclosures.f

ld tools                                \ 3d2019-specific tools
ld quad                                 \ quad model data

( declare and load our images )
s" chr001.png" >data image: chr001.png  \ >DATA prepends the project's data path
s" chr002.png" >data image: chr002.png
s" chr003.png" >data image: chr003.png
s" 2019.png"   >data image: 2019.png
s" star.png"   >data image: star.png

( extend the _actor class )
extend: _actor
    var chr                                         \ ascii code (fixedp)
    var lifetime                                    \ counter
;class

( individual letters )
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

( star background )
: /outward  act>  5 ang +!  vx 2@ 0.97 dup 2* vx 2! ;                       \ spin and decelerate outward
: *star  star.png *csprite /outward  2 2 sx 2!  1 0.5 0.5 tint 3! ;         \ create a start, scale (2,2), pink color
: burst   0 0 at  300 for *star 360 rnd 5 45 between vec vx 2! loop ;      \ create a bunch of stars,
                                                                            \ setting angle to random value and
                                                                            \ velocity to random value between 5 and 45

( big 2019 )
: pulse  4.5 lifetime +!  1( 7 lifetime @ sin 1.6 * + ) dup sx 2! ;         \ apply sine formula to scale
: wobble lifetime @ 0.48 * sin 30 * ang ! ;                                 \ apply sine formula to angle
: *2019  yellow 2019.png  0 0 at  *csprite act> pulse wobble ;              \ create the 2019 sprite
                                                                            \ and make it pulse and wobble.

( displaying the message )
create message ," HAPPY NEW YEAR"
: nextchar  dup c@ { *letter /dance } #1 + ;                                \ takes an address and returns it, inc. by #1

( kickoff the demo )
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
