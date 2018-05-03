\ TODO
\ [x] - check if properties are already defined and early out if so
\        (2/23 for now, just VARs, due to their size guarantee)
\ [x] - but provide a way to "force" property definitions (REDEF flag)
\ [ ] - prototypes???  putting it off.  

\ things smallfry could bring to this;
\   inspection
\   more efficient use of memory (at the cost of speed...)
\   prototypes and embedded objects
\   proper subclassing
\   polymorphism / mixin support / interface support

\ for simplicity this will be used for more than just game objects.  possibilities:
\   audio channels
\   disembodied tasks
\   gui objects
\   particles

[defined] object-maxsize [if] object-maxsize [else] 256 cells [then] constant maxsize

0 value me
: as  to me ;
create mestk  0 , 16 cells allot
: {  state @ if " me >r" evaluate else me mestk dup @ + cell+ !  mestk @ cell+ 63 and mestk !  then ; immediate
: }  state @ if " r> as" evaluate else mestk @ cell- 63 and mestk !  mestk dup @ + cell+ @   then ; immediate
: nxt  me @ to me ;

variable used
variable redef  \ should you want to bury anything

: ?unique  ( size -- size | <cancel caller> )
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
: field   ?unique ?maxsize create used @ , $76543210 , used +! does> @ me + ;
: var  cell field ;
: 's   ' >body @ ?lit " +" evaluate ; immediate
: xfield  ?unique create used @ , $76543210 , used +! does> @ + ;
: xvar  cell xfield ;

\ objects are organized into objlists, which are forward-linked lists of objects
\  you can continually add (statically allocate and link) objects to these lists
\  you can create "pools" which can dynamically allocate objects
\  you can itterate over objlists as a whole, or just over a pool at a time


redef on  \ we'll keep this on while compiling RAMEN itself
var lnk  var en  var ^pool
var x  var y  var vx  var vy
var hidden  var drw  var beha


\ objlists and pools
struct (objlist) \ objlist struct, also used for pools
    (objlist) int svar ol.first
    (objlist) int svar ol.count
    (objlist) int svar ol.#free
    (objlist) int svar ol.last
: count+!  ol.count +! ;
: >first  ol.first @ as ;
: free+!   ol.#free +! ;
: >last   ol.last @ as ;
create dummy  0 ,  dummy as
: object  {  here  maxsize /allot  }  dup lnk !  as ;
: objects  for  object  loop ;
: objlist   create dummy , 0 , 0 , dummy , ;
: ?first  dup ol.first @ dummy = -exit  here over ol.first ! ;
: add  ( objlist n -- )  over >last  swap ?first  2dup count+!  swap objects  me swap ol.last ! ;
: pool:  ( objlist n -- <name> )
    locals| n ol |
    ol ?first drop
    ol >last  n ol count+!  here  ( 1st )  n objects
        create  ( 1st ) , n , n , me ,
    me ol ol.last !
    ;
: each>  ( objlist/pool -- <code> )
    r> swap  dup >first  { ol.count @ 0 do  en @ if  dup >r  call  r>   then  nxt  loop  drop } ;
: all>  ( objlist/pool -- <code> )
    r> swap  dup >first  { ol.count @ 0 do  dup >r  call  r>   nxt  loop  drop } ;
: enough  " r> drop r> drop unloop r> drop " evaluate ; immediate
: named  me constant ;
: single  ( objlist -- <name> )  1 add  named ;
: any?  dup ol.#free @ 0= ;
: enable  x [ maxsize 3 cells - ]# 0 cfill en on at@ x 2! hidden on ;
: remove  en off  hidden on  1 ^pool @ free+! ;
: hidden?  hidden @ ;
: ?noone  any? abort" A pool was exhausted. In: ONE " ;
: one ( pool -- ) ?noone  dup all> en @ ?exit  enough  enable  ^pool !  -1 ^pool @ free+! ;

\ making stuff move and displaying them
: ?call  ?dup -exit call ;
: draw   hidden? ?exit  x 2@ at  drw @ ?call ;
: act   beha @ ?call ;
: draw>  r> drw ! hidden off ;
: act>   r> beha ! ;
: from  x 2@ 2+ at ;
: flicker  hidden @ not hidden ! ;

\ roles
[defined] roledef-size [if] roledef-size [else] 256 cells [then] constant /roledef
: roledef  create /roledef /allot ;
: derive   ( src -- )  last @ name> >body /roledef move ;
variable meta
var role
: rolevar  create  meta @ ,  $99991111 ,  cell meta +!  does>  @ + ;
: action   rolevar  does>  @ role @ + @ execute ;
: :to   ( roledef -- <name> ... )  ' >body @ + :noname swap ! ;
: my  " role @" evaluate  ' >body @ ?lit   " +" evaluate ; immediate

: ->   state @ if postpone { postpone as  ' compile,  postpone } else { as ' execute } then ; immediate
