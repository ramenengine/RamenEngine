[defined] object-maxsize [if] object-maxsize [else] 256 cells [then] constant maxsize

maxsize constant /object
[defined] roledef-size [if] roledef-size [else] 256 cells [then] constant /roledef
variable lastrole \ used by map loaders (when loading objects scripts)
variable meta
create basis /roledef /allot  \ default rolevar and action values for all newly created roles

\ ME is defined in afkit
: as  s" to me" evaluate ; immediate
create mestk  0 , 16 cells allot
: i{ me mestk dup @ cells + cell+ !  mestk @ 1 + 15 and mestk ! ;  \ interpretive version, uses a sw stack
: i} mestk @ 1 - 15 and mestk !  mestk dup @ cells + cell+ @ to me ; 
: {  state @ if s" me >r" evaluate else  i{  then ; immediate
: }  state @ if s" r> as" evaluate else  i}  then ; immediate
: >{   s" { as " evaluate ; immediate    \ }

variable used
variable redef  \ should you want to bury anything
redef on  \ we'll keep this on while compiling RAMEN itself

: ?unique  ( size - size | <cancel caller> )
    redef @ ?exit
    >in @
        bl word find  if
            >body cell+ @ $76543210 =  if
                r> drop  ( value of >IN ) drop  ( size ) drop  exit
            then
        else
            ( addr ) drop
        then
    >in ! ;

: ?maxsize  used @ maxsize >= abort" Cannot create object field; USED is maxed out. Increase OBJECT-MAXSIZE." ;
: create-field  create used @ , $76543210 , used +! ;
: field   ?unique ?maxsize create-field does> @ me + ;
: var  cell field ;
: 's   ' >body @ ?lit s" +" evaluate ; immediate  \ also works with rolevars
: xfield  ?unique ?maxsize create-field does> @ + ;
: xvar  cell xfield ;

\ objects are organized into objlists, which are forward-linked lists of objects
\  you can continually add (statically allocate and link) objects to these lists
\  you can create "pools" which can dynamically allocate objects
\  you can itterate over objlists as a whole, or just over a pool at a time

%node sizeof used !
var #free
used @ constant /objhead
var x  var y  var en  var vx  var vy
var hidden  var drw  var beha

: object,  /object allotment /node ;

create defaults  object,                \ default values are stored here
                                        \ they are copied to new instances by INITME
defaults as  en on 

create pool  object,                    \ where we cache free objects
create root  object,

: >first  node.first @ ;
: >last   node.last @ ;
: >parent  node.parent @ ;
: initme  at@ x 2!  defaults 's en en [ maxsize /objhead - ]# move ;
: ?object  pool length 0= if here object, else pool pop then ;
: one ( parent - me=obj ) new-node as initme me swap push ;
: objects  ( parent n - ) for dup one loop drop ;
: ?remove  ( obj - ) dup >parent ?dup if remove else drop then ;
:noname ?object ; is new-node
:noname dup ?remove pool push ; is free-node
: dismiss  free-node ;

\ static objects
: object:  ( objlist - <name> )  create here as object, initme me swap push ;

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
: objlist-draw  draw> me draws ;
: objlist-act   act> me acts ;
: objlist  ( - <name> )
    create here object, dup as root push
    initme objlist-draw objlist-act ;



\ Roles
\ Note that role vars are global and not tied to any specific role.
var role
: ?update  >in @  defined if  >body lastrole !  drop r> drop exit then  drop >in ! ; 
: defrole  ?update  create  here lastrole !  basis /roledef move, ;
: role@  role @ dup 0= abort" Error: Role is null." ;
: create-rolevar  create  meta @ ,  $76543210 ,  cell meta +! ;
: rolevar  0 ?unique drop  create-rolevar  does>  @ role@ + ;
: action   0 ?unique drop  create-rolevar  does>  @ role@ + @ execute ;
: :to   ( roledef - <name> ... )  ' >body @ + :noname swap ! ;
: +exec  + @ execute ;
: ->  ( roledef - <action> )  ' >body @ postpone literal postpone +exec ; immediate
