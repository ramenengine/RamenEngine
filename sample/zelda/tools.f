( variables )
variable lastkeydir

( misc )
: ztype zcount type ;
: /sprite  draw> at@ 2pfloor at sprite+ ;
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
: rdirkeys?  <left> released  <right> released or  <up> released or  <down> released or ;
: pdirkeys?  <left> pressed <right> pressed or <up> pressed or <down> pressed or ;
: keydir ( -- n )  
    left? if 180 exit then
    right? if 0 exit then
    up? if 90 exit then
    down? if 270 exit then
    -1 ;
: pkeydir ( -- n )  
    pleft? if 180 exit then
    pright? if 0 exit then
    pup? if 90 exit then
    pdown? if 270 exit then
    -1 ;
: !dirkey
    pdirkeys? if pkeydir lastkeydir ! exit then
    rdirkeys? if keydir lastkeydir ! exit then ;
also ideing
: (debug)
    get-xy
        black 0 alpha
        0 0 at  write-src blend> output @ onto> displayw 4 rows rectf
        0 0 at-xy .me
    at-xy ;
previous


( common actor stuff )
action start
action idle
action walk
action turn ( angle )
var dir \ angle
: will-cross-grid?
    x @ dup vx @ + 8 8 2/ 2i <>
    y @ dup vy @ + 8 8 2/ 2i <>
    or  
;
var spd
: near-grid?
    x @ 4 + 8 mod 4 - abs 3 < 
    y @ 4 + 8 mod 4 - abs 3 <  and
;

( collision tools )
: cbox  x 2@ mbw 2@ area 1 1 2- ;
0 value you
: with  me to you ;
: hit?  me you = if 0 exit then   cbox you >{ cbox } overlap? ;
