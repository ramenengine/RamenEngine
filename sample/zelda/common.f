\ note this code is specific to 2d games and needs modification for 3d

1 value nexttype

( role vars )
    rolevar gfxtype \ 0 = nothing, 1 = circle, 2 = box, 3 = sprite, 4 = animation
    rolevar regiontablesize 
    rolevar regiontable <adr
    rolevar initial-bitmask
    %rect sizeof rolefield initial-mhb \ map hitbox
    rolevar typeid

( object vars )
    var objtype
    var qty   1 defaults 's qty ! 
    var bitmask <hex        \ what the object should interact with
    var flags   <hex        \ what attributes the object has
    %rect sizeof field ihb \ interaction hitbox
    var damaged  \ stores the attack power of the last call to DAMAGE
    var startx  var starty

( actions )
    action setup ( - )
    action start ( - )
    action die ( - )
        basis :to die ( - ) end ;   

( object and tile flags )
    #1
    bit #directional
    bit #gfxclip
    bit #solid
    bit #important
    value nextflag

( definition role array )
create objtypes 255 array,
: def  objtypes [] @ ;

( flags )
: set?  flags @ and 0<> ;
: +flag  flags or! ;
: -flag  flags not! ;

( common graphics types )
: (clip)  clipx 2@ cx 2@ 2- 16 16 ;
: obj-sprite #gfxclip set? if (clip) clip> then spr @ nsprite ;
: obj-animate  #gfxclip set? if (clip) clip> then sprite ;

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
: ?solid  #solid set? -exit  physics> tilebuf collide-tilemap ;
: !dir  #directional set? if spawner 's dir @ else 90 then dir ! ;
: /obj  ( objtype - )
	dup objtype ! def role !
	regiontable @ rgntbl !
	initial-mhb wh@ mbw 2!
	initial-bitmask @ bitmask !
	gfxtype @ ?graphics
    setup   \ <--- user code
	?solid
	!dir
	start   \ <--- user code
;

( defining object types )
: create-spawner create , does> @ stage one /obj ;
: create-initializer  create , does> @ /obj ;

\ creates 3 words in addition to the role (if it wasn't already defined)
: deftype ( - <name> )  \ name should be encased by '<' and '>'
    >in @ exists if drop ;then >in !
	>in @ defrole >in !
	bl parse #1 /string #1 - 2>r
        nexttype lastrole @ 's typeid !
		lastrole @ nexttype objtypes [] !
		nexttype s" create-spawner *" 2r@ strjoin evaluate
		nexttype s" create-initializer /" 2r@ strjoin evaluate
        nexttype s" constant #" 2r@ strjoin evaluate
        1 +to nexttype
	2r> 2drop
;

( misc )
: type>id  's typeid @ ;
: id>type  objtypes [] @ ;
: .name    body> >name count type ;
: .type    ( obj - ) 's role @ .name ;


( define action tables )
\ allocates space for a vector table in roles. when executed, the given
\ indexed action is run.
: actiontable  ( #cells - <name> )  ( n - )
    0 ?unique drop  cells create-rolefield <adr
    does> field.offset @ role@ + swap cells + @ execute ;

( interactions )

32 actiontable collide  \ me = the one checking, you = the object collided with

\ assign handler for corresponding attribute (bit number) in the given actiontable
: :on  ( attribute role - <actiontable> <code> ; )
	' >body field.offset @ + swap bit# cells + :noname swap ! ;

\ same as :ON but configures the given role's initial-bitmask for you
\ and uses the COLLIDE actiontable specifically
: :hit  ( attribute role - <code> ; )
	2dup 's initial-bitmask @ or over 's initial-bitmask !
	s" :on collide " evaluate ;

: collide?  ( - flag )  \ usage: <subject> as with ... <object> as <bitmask> hit?
    me you = if 0 ;then
    bitmask @ you 's flags @ and 0= if 0 ;then
    ibox you >{ ibox } overlap? ;

: interact  ( - )
    stage each> as  \ en @ -exit
        bitmask @ -exit
		stage each> to you
        collide? if
			\ ." hit "
			bitmask @ you 's flags @ and 32 for
				dup #1 and if
					\ ." collide "
					i collide 
				then 1 >>
			loop drop
		then 
;
