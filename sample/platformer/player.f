( player )
: aligned  at@ 2dup 16 16 2mod 2- at ; 
: ?dig
    dir @ 0 = if  x 2@ 22 u+ tile@ 1 = if  me 22 0 from aligned 0 at@ tile! me { break }  then  then
    dir @ 180 = if  x 2@ -8 u+ tile@ 1 = if  me -8 0 from aligned 0 at@ tile! me { break }  then  then
;
: ?jump
    onground @ -exit
    <space> pressed -exit                     \ if on the ground, then check if player jumps
        -2 vy !                               \ initial y velocity
        \ allow player to propel upward for up to 23 frames: 
        23 for  <space> kstate if -0.17 vy +! else unloop ;then pause loop   
;
: /jumping  0 perform> begin ?jump pause again ;
: /controls
    /jumping
    act>
    0 
    <left> kstate if drop 180 dir ! -1.25 then
    <right> kstate if drop 0 dir !   1.25 then
    vx !
    <z> pressed if ?dig then    
    hitceiling @ if /jumping then    \ reset the jumping task if we hit the ceiling
;
\ draw a box, offset by the background's scroll coords.  TINTED sets TINT according to FORE (set by RED)
: /box  tinted draw>  cam 's x 2@ 2pfloor 2negate +at  tint 4@ rgba 14 14 rectf ;

guy as
red /box /solid                      \ /SOLID enables tilemap collision
/controls                            \ and enable the controls
startxy 2@ x 2!                      \ and put him at the starting position
