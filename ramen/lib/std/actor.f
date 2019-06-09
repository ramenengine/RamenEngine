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
    var x  var y  var z
    var vx  var vy  var vz
    var drw <adr
    var beha <adr
    var dyn <flag          \ is dynamic
;class

: basis  _role >prototype ;  \ default role-var and action values for all newly created roles

64 cells node-class: _objlist
;class

create objlists  _node static,           \ parent of all objlists

: >first  ( node - node|0 ) node.first @ ;
: >last   ( node - node|0 ) node.last @ ;
: >parent  ( node - node|0 ) node.parent @ ;
: ?id  id $80000000 and 0= if id else 0 then ;
: !id  1 nextid +!  nextid @ id ! ;
: *actor ( parent - actor )  _actor dynamic {  me swap push  !id  at@ x 2!  dyn on  me } ;
: detach  ( node - ) dup >parent dup if remove else drop drop then ;
: dismiss ( actor - ) 's marked on ;

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
: from  ( actor x y - ) rot 's x 2@ 2+ at ;
: -act  ( - ) act> noop ;
: objlist:  ( - <name> )  create _objlist static objlists push ;

( stage )
objlist: stage  \ default object list

: one  ( - )  stage *actor as ;

( static actors )
: actor:   ( parent - <name> )
    create  _actor static as  !id  ?dup if me swap push then  
    _actor fields: ;

( role stuff )

: role's  ( - <field> adr )
    s" role @" evaluate  ' >body _role superfield>offset ?literal s" +" evaluate
; immediate

( actions )
: is-action?  field.attributes @ ;

: action:   ( - <name> ) ( ??? - ??? )
    _role fields:
    cell ?superfield <adr ( flag ) 
    true lastField field.attributes ! 
    -exit
    does>  _role superfield>offset role @ + @ execute ;    

: role-var  class  _role to class  var  to class ;
: role-field  class >r  _role to class  field  r> to class ;

: :to   ( role - <name> ... )
    postpone 's :noname swap ! ;

: :action   ( - <name> <code> ; )  ( ??? - ??? )
    >in @  action:  >in !  basis :to ;


: ->  ( role - <action> )
    postpone 's s" @ execute" evaluate ; immediate

( create role )
: ?update  ( - <name> )
    >in @
    defined if  >body to lastRole  r> drop drop ;then
    drop
    >in ! ;

: role:  ( - <name> )
    ?update  create  _role static as
    me to lastRole
    _actor fields:
    ['] is-action? _role >fields some>
        :noname swap
            field.offset @
            dup basis + postpone literal s" @ execute ; " evaluate  \ compile "bridge" code
            lastRole + !  \ assign our "bridge" to the corresponding action    
;


( inspection )
: .role  ( actor - )
    >class ?dup if peek else ." No role" then ;

: .objlist  ( objlist - )
    dup length 1i i. each>
        {  cr me h. ." ID: " id ?  ."  X/Y: " x 2@ 2.  } ;

_actor >prototype as
    en on
    basis role !
