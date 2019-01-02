\ ===================================================================================
\ Goals
\ 1. I don't want to have to create a function for every object
\ 2. I want to be able to define objects from within Ramen
\ 3. I want all objects to have enough common logic
\    to make simple games with no code
\ object type index...
\   types and/or flags should be common to objects AND tiles
\ ===================================================================================

#16 rolefield typename <cstring
rolevar gfxtype \ 0 = nothing, 1 = circle, 2 = box, 3 = sprite, 4 = animation
#32 rolefield imagepath <cstring
rolevar regiontablesize 
rolevar regiontable <adr
8 cells rolefield dropables
rolevar initial-bitmask
%rect sizeof rolefield initial-mhb \ map hitbox

var objtype
var quantity   1 defaults 's quantity ! 
var bitmask <hex        \ what the object should interact with
var flags   <hex        \ what attributes the object has
%rect sizeof field ihb \ interaction hitbox
var hp
var maxhp
var atk
var hp  2 defaults 's hp !
var maxhp  2 defaults 's maxhp !
var damaged  \ stores the attack power of the last call to -HP
var startx  var starty

action setup ( - )
action start ( - )
action die ( - )
    basis :to die ( - ) end ;

( object and tile flags )
#1
bit #directional
bit #gfxclip
bit #important
bit #solid
bit #collider
bit #inair
\ bit #entrance
\ bit #ground
\ bit #fire
\ bit #water
bit #npc
bit #item
bit #enemy
value nextflag

( definition role array )
create objdefs 255 array,
: def  1 - objdefs [] @ ;

( flags )
: flag?  flags @ and 0<> ;
: +flag  flags or! ;
: -flag  flags not! ;
: important? #important flag? ;

( graphics )
: (clip)  clipx 2@ cx 2@ 2- 16 16 ;
: obj-sprite #gfxclip flag? if (clip) clip> then spr @ nsprite ;
: obj-animate  #gfxclip flag? if (clip) clip> then sprite+ ;

: gfx-sprite draw> obj-sprite ;
: gfx-animation draw> obj-animate ;
: ?flash  if rndcolor then ;
: gfx-circle draw> 8 8 +at  tint 4@ rgba damaged @ ?flash 8 circf ;
: gfx-box draw> tint 4@ rgba damaged @ ?flash 16 16 rectf ;

0
enum #none
enum #circle
enum #box
enum #sprite
enum #animation
drop
#sprite basis 's gfxtype !  \ default for all objects is simple sprite
create graphics-types
	' noop ,
	' gfx-circle ,
	' gfx-box ,
	' gfx-sprite ,
	' gfx-animation , 
: ?graphics graphics-types njump ;

( initialization and spawning )
: ?find  dup -exit find ;
: ?solid  #solid flag? -exit  physics> tilebuf collide-tilemap ;
: !dir  #directional flag? if spawner 's dir @ else 90 then dir ! ;
: /obj  ( objtype - )
	dup objtype ! def role !
	regiontable @ rgntbl !
	initial-mhb wh@ mbw 2!
	initial-bitmask @ bitmask !
	gfxtype @ ?graphics
    setup
	?solid
	!dir
	start
;
: *obj  ( objtype - ) stage one /obj ;

( making object definitions )
: (typeid)  s" #" 2swap strjoin ;
: create-spawner create , does> @ *obj ;
: create-initializer  create , does> @ /obj ;

: defobj ( - <name> )  \ name should be actually encased by '<' and '>'
	0 locals| typeid |
	>in @ create >in !
	bl parse #1 /string #1 - 2>r
		2r@ (typeid) evaluate to typeid 
		here lastrole !
		here basis /roledef move, typeid 1 - objdefs [] !
		typeid s" create-spawner *" 2r@ strjoin evaluate
		typeid s" create-initializer /" 2r@ strjoin evaluate
	2r> 2drop
;
\ creates multiple words:
\   <name>-role
\   *<name> ( - ) spawns the object
\   /<name> ( - ) 

( compile-time struct literal tools )
: field+  >body @ + ;
: := ( baseadr - <fieldname> <values...> baseadr )
    0 locals| n |
    dup >r ' field+ ( fieldadr )
        begin bl parse ?dup while
            evaluate over !
            cell+
        repeat
        ( fieldadr c-addr ) drop drop
    r>
;
: $= ( baseadr - <fieldname> <string> baseadr )
    dup ' field+ >r 0 parse r> place ;

( interactions )

: actiontable  ( #cells - <name> )  ( n - )
    0 ?unique drop  cells create-rolefield <adr
    does> field.offset @ role@ + swap cells + @ execute ;

32 actiontable collide  \ me = the one checking, you = the object collided with

: :on  ( attribute role - <actiontable> <code> ; )
	' >body field.offset @ + swap bit# cells + :noname swap ! ;

: :hit  ( attribute role - <code> ; )
	2dup 's initial-bitmask @ or over 's initial-bitmask !
	s" :on collide " evaluate ;

: collide?  ( attributes - flag )  \ usage: <subject> as with ... <object> as <bitmask> hit?
    me you = if drop 0 ;then
    bitmask @ you 's flags @ and 0= if 0 ;then
    ibox you >{ ibox } overlap? ;

: interact  ( - )
    stage each> as  en @ -exit
        bitmask @ -exit
		stage each> to you collide? if
			\ ." hit "
			bitmask @ you 's flags @ and 32 for
				dup #1 and if
					\ ." collide "
					i collide 
				then 1 >>
			loop drop
		then 
;

( misc )
: sf@+  dup sf@ cell+ ;
: tinted   fore sf@+ f>p swap sf@+ f>p swap sf@+ f>p swap sf@+ f>p nip tint 4! ;

( damage )
: -hp  ( n - )  dup negate hp +! damaged ! hp @ ?exit die ;
: undamage  damaged off ;
: damage  ( n obj - )
    >{ damaged @ if drop } ;then -hp ['] undamage 60 after } ;
