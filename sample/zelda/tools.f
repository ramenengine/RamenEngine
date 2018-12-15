( variables )
variable lastkeydir

( misc )
: /sprite  draw> at@ 2pfloor at sprite+ ;
: ztype zcount type ;
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
: near-grid?
    x @ 4 + 8 mod 4 - abs 2 < 
    y @ 4 + 8 mod 4 - abs 2 <  and
;
: dir-anim-table  ( - )
    does> dir @ 90 / cells + @ execute ;


( collision tools )
: cbox  x 2@ mbw 2@ area 1 1 2- ;
0 value you
: with  me to you ;
: hit?  me you = if 0 exit then   cbox you >{ cbox } overlap? ;


( extend loop )
var 'physics  \ code
: physics>  r> 'physics ! ;
: ?physics  'physics @ ?dup if >r then ;
:slang think  ( - ) stage acts stage multi ;
:slang physics ( - ) stage each> as ?physics vx 2@ x 2+! ;
: default-step ( - ) step> think physics ;
default-step


( tilemap collision stuff )
create tileprops  s" sample/zelda/data/tileprops.dat" file,
:is tileprops@  >gid dup if 2 - 1i tileprops + c@ then ;
:is on-tilemap-collide  onhitmap @ >r ; 
: /solid   16 16 mbw 2! physics> tilebuf collide-tilemap ;

( event system - note this version is not re-entrant. )
create listeners 100 stack,
create args 8 stack,

: :listen  ( - <code> ; ) ( me=source event c - )
    :noname listeners push ; 

: fetcheach  each> noop ;

: (dispatch)  ( event c xt - event c )
    -rot 2dup 2>r rot { execute } 2r> ;

: occur ( ... #params event c - )
    2>r args vacate args pushes 2r> ['] (dispatch) listeners each 2drop ;

: occured  ( event c event c - ... true | false )
    compare 0= if args fetcheach true else 0 then ;