( Z-sorting extension )

depend ramen/lib/rsort.f

extend: _actor
    var zorder  \ defines z order.  lower = more behind, higher = more in front
;class

extend: _objlist
    var zsort   \ enables zsort on object lists
;class

define internal
: drawem  ( adr cells - )  cells bounds do  i @ as  draw  cell +loop ;
: #queued  ( adr - #cells ) here swap - cell/ ;
: (enqueue)  ( objlist - )  each> as  hidden @ ?exit  me , ;  
: enqueue  ( objlist - adr #cells )  here swap (enqueue) dup #queued ;

using internal
: zorder@  's zorder @ ;
: zdraws ( objlist - )
    here >r
        ( objlist ) enqueue
            2dup ['] zorder@ rsort
                drawem
    r> reclaim ;
: draws ( objlist - )
    dup 's zsort @ if zdraws ;then
    draws ;

previous
stage 's zsort on
