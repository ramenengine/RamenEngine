[defined] object-maxsize [if] object-maxsize [else] 256 cells [then] constant maxsize
maxsize constant /object
[defined] roledef-size [if] roledef-size [else] 256 cells [then] constant /roledef
variable lastrole \ used by map loaders (when loading objects scripts)
struct %role
struct %obj
create basis /roledef /allot  \ default rolevar and action values for all newly created roles

\ ME is defined in afkit
: as  s" to me" evaluate ; immediate
create mestk  0 , 16 cells allot
: i{ me mestk dup @ cells + cell+ !  mestk @ 1 + 15 and mestk ! ;  \ interpretive version, uses a sw stack
: i} mestk @ 1 - 15 and mestk !  mestk dup @ cells + cell+ @ to me ; 
: {  state @ if s" me >r" evaluate else  i{  then ; immediate
: }  state @ if s" r> as" evaluate else  i}  then ; immediate
: >{   s" { as " evaluate ; immediate    \ }

: used  %obj struct.size ;

variable redef  \ should you want to bury anything
redef on  \ we'll keep this on while compiling RAMEN itself

: >magic  %field @ + @ ;
: ?unique  ( size - size | <cancel caller> )
    redef @ ?exit
    >in @
        bl word find  if
            >body >magic $76543210 =  if
                r> drop  ( value of >IN ) drop  ( size ) drop  exit
            then
        else
            ( addr ) drop
        then
    >in ! ;

: ?maxsize  used @ maxsize >= abort" Cannot create object field; USED is maxed out. Increase OBJECT-MAXSIZE." ;
: field   ?unique ?maxsize %obj swap create-field $76543210 , does> field.offset @ me + ;
: var  cell field ;
: 's   ' >body field.offset @ ?lit s" +" evaluate ; immediate  \ also works with rolevars

\ objects are organized into objlists, which are forward-linked lists of objects
\  you can continually add (statically allocate and link) objects to these lists
\  you can create "pools" which can dynamically allocate objects
\  you can itterate over objlists as a whole, or just over a pool at a time

%node @ %obj struct.size +!
used @ constant /objhead
var en <flag  var hidden <flag  
var x  var y  var vx  var vy
var drw <adr  var beha <adr

: object,  /object allotment /node ;

create defaults  object,                \ default values are stored here
                                        \ they are copied to new instances by INIT
defaults as  en on 

create pool  object,                    \ where we cache free objects
create root  object,                    \ catch-all destination

: >first  node.first @ ;
: >last   node.last @ ;
: >parent  node.parent @ ;
: init  at@ x 2!  defaults 's en en [ maxsize /objhead - ]# move ;
: one ( parent - me=obj ) new-node as init me swap push ;
: objects  ( parent n - ) for dup one loop drop ;
: ?remove  ( obj - ) dup >parent ?dup if remove else drop then ;
:noname pool length 0= if here object, else pool pop then ; is new-node
:noname dup ?remove pool push ; is free-node
: dismiss  free-node ;

\ static objects
: object   here as object, init ;
: object:  ( objlist - <name> )  create object me swap push ;

\ making stuff move and displaying them
: ?call  ?dup -exit call ;
: draw   en @ -exit  hidden @ ?exit  x 2@ at  drw @ ?call ;
: draws each> as draw ;
: act   en @ -exit  beha @ ?call ;
: acts  each> as act ;
: draw>  r> drw ! hidden off ;
: act>   r> beha ! ;
: away  ( obj x y - ) rot 's x 2@ 2+ at ;
: -act  act> noop ;
: objlist  ( - <name> )  create here as object, init ;


\ Roles
\ Note that role vars are global and not tied to any specific role.
var role <adr
: ?update  >in @  defined if  >body lastrole !  drop r> drop exit then  drop >in ! ; 
: defrole  ?update  create  here lastrole !  basis /roledef move, ;
: role@  role @ dup 0= abort" Error: Role is null." ;
: create-rolevar  %role cell create-field $76543210 , ;
: rolevar  0 ?unique drop  create-rolevar  does> field.offset @ role@ + ;
: action   0 ?unique drop  create-rolevar <adr does> field.offset @ role@ + @ execute ;
: :to   ( roledef - <name> ... )  ' >body field.offset @ + :noname swap ! ;
: +exec  + @ execute ;
: ->  ( roledef - <action> )  ' >body field.offset @ postpone literal postpone +exec ; immediate

\ Inspection
: o.   %obj .fields ;
: .me  me o. ;
: .role  ( obj - )  's role @ ?dup if %role .fields else ." No role" then ;