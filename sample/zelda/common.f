( ---=== Common objects framework ===--- )

\ this framework helps with creating object types.
\ it takes care of the following:
\ - some canned graphics types - circle, box, sprites
\ - attributes and handling collisions between objects based on them
\ - initial map hitbox
\ - enum-style type id's
\ - generic actions: SETUP START DIE
\ - hitbox for object-object collisions
\ - standardized object initialization
\ - standardized initialization words e.g. /ACTOR *ACTOR
\ - action tables
\ - standardized object-object collision handling

\ note: this code is specific to 2d games and needs modification for 3d

1 value nextType

extend: _role
    var gfxtype    \ 0 = nothing, 1 = circle, 2 = box, 3 = sprite, 4 = animation
    var initial-bitmask <hex
    %rect sizeof field initial-mhb    \ map hitbox
    var typeid
    
    ( actions )
    action setup ( - )
    action start ( - )
    action die ( - )
;class

basis :to die ( - ) end ;   

extend: _actor
    var objtype 
    var bitmask <hex        \ whaet the object should interact with
    var flags   <hex        \ what attributes the object has
    %rect sizeof field ihb  \ interaction hitbox
    var damaged             \ stores the attack power of the last call to DAMAGE
    var startx  var starty
    var dir \ angle
;class

( object and tile flags )
    #1
    bit #directional
    bit #gfxclip
    bit #solid
    bit #important
    value nextflag

( object type array )
create typeRoles 255 stack,
: type>role  typeRoles 1 - [] @ ;
: role>type  's typeid @ ;

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
: gfx-circle draw> 8 8 +at  tint 4@ rgba damaged @ ?flash 8 circlef ;
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
: /obj  ( role - )
	dup role !
    role>type objtype !
    role's initial-mhb wh@ mbw 2!
    role's initial-bitmask @ bitmask !
    role's gfxtype @ ?graphics
    setup   \ <--- user code
	?solid
	spawndir @ dir ! 
	start   \ <--- user code
;

( defining object types )
: spawner:  ( role - <name> )  ( - )  create , <ui does> @  stage one  /obj ;
: initializer:  ( role - <name> )  ( - ) create , does> @ /obj ;

\ creates 3 words in addition to the role (if it wasn't already defined)
: type: ( - <name> )
    >in @ exists if drop ;then >in !
	>in @  role:
    >in !
	bl parse 2>r 
        nextType lastRole 's typeid !
		lastRole typeRoles push
		lastRole s" spawner: *" 2r@ strjoin evaluate
		lastRole s" initializer: /" 2r@ strjoin evaluate
        \ nextType s" constant #" 2r@ strjoin evaluate
        1 +to nextType
	2r> 2drop
;

( misc )
: .type    ( obj - ) 's role @ .name ;


( define action tables )
\ allocates space for a vector table in roles. when executed, the given
\ indexed action is run.
: actiontable:  ( #cells - <name> )  ( n - )
    _role fields:
    cells ?superfield <adr  -exit
    does> _role superfield>offset role@ + swap cells + @ execute ;

( interactions )

32 actiontable: collide  \ me = the one checking, you = the object collided with

\ assign handler for corresponding attribute (bit number) in the given actiontable
: :on  ( attribute role - <actiontable> <code> ; )
	postpone 's swap bit# cells + :noname swap ! ;

\ same as :ON but configures the given role's initial-bitmask for you
\ and uses the COLLIDE actiontable specifically
: :hit  ( attribute role - <code> ; )
	2dup 's initial-bitmask @ or over 's initial-bitmask !
	s" :on collide " evaluate ;

: collide?  ( - flag )  \ usage: <subject> as with ... <object> as <bitmask> hit?
    me you = if 0 ;then
    bitmask @ you 's flags @ and 0= if 0 ;then
    ibox you { ibox } overlap? ;

: interact  ( - )
    stage each> as  \ en @ -exit
        bitmask @ -exit
		stage each> to you
        collide? if
			\ ." hit "
			bitmask @ you 's flags @ and 
			32 for
				dup #1 and if
					\ ." collide "
					i collide 
				then 1 >>
			loop drop
		then 
;

