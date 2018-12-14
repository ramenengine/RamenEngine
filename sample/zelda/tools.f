( misc )
: ztype zcount type ;
: /sprite  draw> sprite+ ;
: situated  's x 2@ 2+ x 2! ;
: -vel    0 0 vx 2! ;
: left?   <left> kstate ;
: right?  <right> kstate ;
: up?     <up> kstate ;
: down?   <down> kstate ;
: pleft?   <left> pressed ;
: pright?  <right> pressed ;
: pup?     <up> pressed ;
: pdown?   <down> pressed ;
: dirkeys?  left? right? or up? or down? or ;
: dirkeysup?  <left> released  <right> released or  <up> released or  <down> released or ;

( common actor stuff )
action start
action idle
action walk
action turn ( angle )
var dir \ angle
: !pdir ( -- )  \ detects presses, no diagonals, no velocity stuff
        pleft? if 180 dir ! exit then
        pright? if 0 dir ! exit then
        pup? if 90 dir ! exit then
        pdown? if 270 dir ! exit then ;
: !dir ( -- )  \ detects state, no diagonals, no velocity stuff
        left? if 180 dir ! exit then
        right? if 0 dir ! exit then
        up? if 90 dir ! exit then
        down? if 270 dir ! exit then ;

( collision tools )
: cbox  x 2@ mbw 2@ area 1 1 2- ;
0 value you
: with  me to you ;
: hit?  me you = if 0 exit then   cbox you >{ cbox } overlap? ;
