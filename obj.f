\ TODO
\ [x] - check if properties are already defined and early out if so
\        (2/23 for now, just VARs, due to their size guarantee)
\ [x] - but provide a way to "force" property definitions (REDEF flag)
\ [ ] - prototypes???  putting it off.  
\ [ ] - copy parent to already defined roles
\ [ ] - add magic number to roles for checking if already defined

\ for simplicity this will be used for more than just game objects.  possibilities:
\   audio channels
\   disembodied tasks
\   gui objects
\   particles

[defined] object-maxsize [if] object-maxsize [else] 256 cells [then] constant maxsize

\ ME is defined in afkit
: as  s" to me" evaluate ; immediate
create mestk  0 , 16 cells allot
: i{ me mestk dup @ cells + cell+ !  mestk @ 1 + 15 and mestk ! ;  \ interpretive version, uses a sw stack
: i} mestk @ 1 - 15 and mestk !  mestk dup @ cells + cell+ @ to me ; 
: {  state @ if s" me >r" evaluate else  i{  then ; immediate
: }  state @ if s" r> as" evaluate else  i}  then ; immediate
: nxt  me @ to me ;
: >{   s" { as " evaluate ; immediate

variable used
variable redef  \ should you want to bury anything
redef on  \ we'll keep this on while compiling RAMEN itself

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


var lnk  var ^pool
var x  var y  var en  var vx  var vy
var hidden  var drw  var beha



create defaults  maxsize /allot         \ default values are stored here
                                        \ they are copied to new instances by INITME
defaults as  en on 

\ objlists and pools
struct %objlist \ objlist struct, also used for pools
    %objlist int svar ol.first
    %objlist int svar ol.count
    %objlist int svar ol.#free
    %objlist int svar ol.last
: count+!  ol.count +! ;
: >first  ol.first @ as ;
: free+!   ol.#free +! ;
: >last   ol.last @ ;
: object  {  here  maxsize /allot  }  dup lnk !  as  ;
: objects  for  object  loop ;
create (ol)  defaults , 0 , 0 , defaults , 
: objlist   create  (ol) %objlist sizeof move, ;
: /objlist   (ol) swap %objlist sizeof move ;
: ?first  dup ol.first @ defaults = -exit  here over ol.first ! ;
: pool:  ( objlist n -- <name> )
    locals| n ol |
    ol ?first drop
    ol >last as  n ol count+!  here  ( 1st )  n objects
        create  ( 1st ) , n , n , me ,
    me ol ol.last !
    ;
: each>  ( objlist/pool -- <code> )
    r>  { swap dup >first  ol.count @ for  en @ if  dup >r  call  r>   then  nxt  loop  drop } ;
: each   ( objlist/pool xt -- )  
    >code  { swap dup >first  ol.count @ for  en @ if  dup >r  call  r>   then  nxt  loop  drop } ;
: all>  ( objlist/pool -- <code> )
    r>  { swap dup >first  ol.count @ for  dup >r  call  r>   nxt  loop  drop } ;
: enough  s" r> drop r> drop unloop r> drop " evaluate ; immediate
: any?  dup ol.#free @ 0= ;
: initme  at@ x 2!  defaults 's en  en  [ maxsize 4 cells - ]# move ;
: remove  ( object -- )  >{  en off  hidden on  1 ^pool @ free+!  } ;
: hidden?  hidden @ ;
: ?noone  any? abort" ONE: A pool was exhausted. " ;
: (slot)  ( pool -- me=obj )  ?noone  all>  en @ ?exit  enough ;
: one ( pool -- me=obj )  dup (slot)  initme  dup ^pool !  -1 swap free+! ;

\ static object lists
: (add)  ( objlist -- )  >r r@ >last as  r@ ?first drop  1 r@ count+!  1 objects  me r> ol.last !  initme ;
: add  ( objlist n -- )  for dup (add) loop drop ; 
: object:  ( objlist -- <name> )  create 1 add ;

\ making stuff move and displaying them
: ?call  ?dup -exit call ;
: draw   hidden? ?exit  x 2@ at  drw @ ?call ;
: act   beha @ ?call ;
: draw>  r> drw ! hidden off ;
: act>   r> beha ! ;
: away  ( obj x y -- ) rot 's x 2@ 2+ at ;
: -act  act> noop ;

\ Roles
\ Note that role vars are global and not tied to any specific role.
[defined] roledef-size [if] roledef-size [else] 256 cells [then] constant /roledef
var role
variable meta
create basis /roledef /allot  \ default rolevar and action values for all newly created roles
: ?update  >in @  exists if  drop  r> drop exit then  >in ! ; 
: roledef:  ?update  create  basis /roledef move,  ;
: role@  role @ dup 0= abort" Error: Role is null." ;
: create-rolevar  create  meta @ ,  $76543210 ,   cell meta +!  ;
: rolevar  0 ?unique drop  create-rolevar  does>  @ role@ + ;
: action   0 ?unique drop  create-rolevar  does>  @ role@ + @ execute ;
: :to   ( roledef -- <name> ... )  ' >body @ + :noname swap ! ;
: +exec  + @ execute ;
: ->  ( roledef -- <action> )  ' >body @ postpone literal postpone +exec ; immediate

\ Filtering tools
0 value xt
: #queued  ( addr -- addr n )  here over - cell/ 1p ;
: eachcell  ( addr n xt -- )  ( addr -- )
    xt >r  to xt
        cells bounds do  i xt execute  cell +loop
    r> to xt ;
: eachcell>  ( addr n -- <code> )  ( addr -- )
    r> code> eachcell ;
: some  ( objlist filterxt xt -- )  ( addr n -- )
    here >r  -rot  each  r@ #queued rot execute  r> reclaim ;
: some>  ( objlist filterxt -- <code> )  ( addr n -- )
    r> code> some ;
    