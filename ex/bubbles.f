include ramen/ramen.f
empty
depend ramen/basic.f

_actor fields:  var radius
_actor >prototype { 16 radius ! }

: sf@+  dup sf@ cell+ ;
: tinted   fore sf@+ f>p swap sf@+ f>p swap sf@+ f>p swap sf@+ f>p nip tint 4! ;
: view/  globalscale dup 2/ ;
: mousexy  mouse 2@ view/ ;
: mdelta   mouse 2@ mickey 2@ 2- view/ ;

( beat counter )
0 value beat
stage *actor as
:now act>	beat 1 + 24 mod to beat ;

( draw bubble and line connecting to previous )
role: [bubble]
: prev  me node.previous ;
: rope  prev @ @ -exit  prev @ { role @ [bubble] = if x 2@ line then } ;

( wiggling and rising motion )
: /rise
    act>
	y @ -1000 < if me dismiss ;then
	radius @ 0.5 - 3 max radius !
	beat 0= 4 rnd 1 < and if radius @ 10 max radius ! then
    vx @ 0 > if -1 vx +! then
	vx @ 0 < if 1 vx +! then
	vy @ -2 > if -2 vy +! then
;

: /bubble  /rise tinted  [bubble] role !
    draw>  tint 4@ rgba  rope  radius @ circlef ;

: *bubble ( -- actor )
    stage *actor {
        /bubble
    me }
;

( bubble generator - controlled with mouse )
stage *actor as
: 2abs  abs swap abs swap ;
: propel  ( vx vy ) 2 2 2/ vx 2! ;
: inflate ( vx vy ) 2abs + 2 / 3 + radius ! ;
: spurt  me 0 0 from vx 2@ 1 rnd 1 rnd 1 rnd rgb *bubble { 2dup propel inflate } ;
: control  mousexy x 2@ 2- vx 2! ;
: /spurt  act> control spurt ;
: /gen    /spurt draw> 5 ang +! transform> -5 -5 +at white 10 10 rect ;

create gen  stage actor,  /gen  
