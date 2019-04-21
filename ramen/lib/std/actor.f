0 value lastRole \ used by map loaders (when loading objects scripts)
variable nextid

0  4 kbytes  class: _role
;class

512 cells  node-class: _actor
    var role <body
    var id 
    var en <flag
    var hidden <flag
    var marked <flag \ for deletion
    var x  var y  var vx  var vy
    var drw <adr
    var beha <adr
    var dyn <flag          \ is dynamic
;class

: basis _role prototype ;  \ default role-var and action values for all newly created roles

_actor prototype as
    en on

create objlists  _node static            \ parent of all objlists

: >first  ( node - node|0 ) node.first @ ;
: >last   ( node - node|0 ) node.last @ ;
: >parent  ( node - node|0 ) node.parent @ ;
: ?id  id $80000000 and 0= if id else 0 then ;
: !id  1 nextid +!  nextid @ id ! ;
: /actor  ( - )  !id ;
: one ( parent - me=obj )  _actor dynamic  me swap push  /actor  at@ x 2!  dyn on ;
: detach  ( obj - ) dup >parent dup if remove else drop drop then ;
: dismiss ( - ) marked on ;

: actor:free-node
    dup _actor is? not if  destroy ;then
    {
        dyn @ if  me destroy  then
        id off  \ necessary for breaking connections
    }
;    
    
' actor:free-node is free-node

\ making stuff move and displaying them
: ?call  ( adr - ) ?dup -exit call ;
: draw   ( - ) en @ -exit  hidden @ ?exit  x 2@ at  drw @ ?call ;
: draws  ( objlist ) each> as draw ;
: act   ( - ) en @ -exit  beha @ ?call ;
: sweep ( - ) objlists each> each> as marked @ -exit  marked off  id off  me free-node ;
: acts  ( objlist ) each> as act ;
: draw>  ( - <code> ) r> drw ! hidden off ;
: act>   ( - <code> ) r> beha ! ;
: from  ( obj x y - ) rot 's x 2@ 2+ at ;
: -act  ( - ) act> noop ;
: objlist:  ( - <name> )  create _actor static me objlists push ;

( stage )
objlist: stage  \ default object list
: /stage  stage vacate  0 nextid ! ;

( static actors )
: actor,  ( parent - )  _actor static  me swap push  /actor ;
: actor:   ( parent - <name> )  create  actor, ;

( role stuff )
: role@  ( - role )
    role @ dup 0= abort" Error: Role is null." ;

: role's  ( - <field> adr )
    s" role@" evaluate  ' >body _role superfield>offset ?literal s" +" evaluate
; immediate

( actions )
: is-action?  field.attributes @ ;

: action:   ( - <name> ) ( ??? - ??? )
    _role fields:
    cell ?superfield <adr ( flag ) 
    true lastField field.attributes ! 
    -exit
    does>  _role superfield>offset role@ + @ execute ;    

: role-var  _role fields: var ;
: role-field  _role fields: field ;


: :to   ( role - <name> ... )
    postpone 's :noname swap ! ;

: ->  ( role - <action> )
    postpone 's s" @ execute" evaluate ; immediate

( create role )
: ?update  ( - <name> )
    >in @
    defined if  >body to lastRole  r> drop drop ;then
    drop
    >in ! ;

: role:  ( - <name> )
    ?update  create  _role static
    me to lastRole
    ['] is-action? _role >fields some>
        :noname swap
            field.offset @
            dup basis + postpone literal s" @ execute ; " evaluate  \ compile "bridge" code
            lastRole + !  \ assign our "bridge" to the corresponding action    
;


( inspection )
: .role  ( obj - )
    >class ?dup if peek else ." No role" then ;

: .objlist  ( objlist - )
    dup length 1i i. each>
        {  cr me h. ." ID: " id ?  ."  X/Y: " x 2@ 2.  } ;

