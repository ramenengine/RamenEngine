( flags )
nextflag
    bit #weapon
    bit #inair
    \ bit #entrance
    \ bit #ground
    \ bit #fire
    \ bit #water
    bit #npc
    bit #item
    bit #enemy
drop

( vars )
    var hp
    var maxhp
    var atk
    var hp  2 defaults 's hp !
    var maxhp  2 defaults 's maxhp !

( misc )
: sf@+  dup sf@ cell+ ;
: tinted   fore sf@+ f>p swap sf@+ f>p swap sf@+ f>p swap sf@+ f>p nip tint 4! ;
: damage  ( n - )
    damaged @ if drop ;then
    dup negate hp +! damaged !
    hp @ 0 <= if hp @ h. end ;then
    60 after> damaged off ;

( canned motions )
: orbit  ( n )
    !startxy
    perform> 0 begin
        dup 16 vec startx 2@ 2+ x 2! over +
    pause again ;

( actor directional stuff )
var olddir
action evoke-direction  ( - )
: !face  ( - ) dir @ olddir !  evoke-direction ; 
: downward  ( - ) 90 dir ! !face ;
: upward    ( - ) 270 dir ! !face ;
: leftward  ( - ) 180 dir ! !face ;
: rightward ( - ) 0 dir !   !face ;
: ?face     ( - ) dir @ olddir @ = ?exit !face ;    
: dir-anim-table  ( - )  does> dir @ 90 / cells + @ execute ;
    
( item stuff )
include sample/zelda/item-assets.f
256 cells quest-field inventory
: /item  item-regions rgntbl !  items.image img !  #item +flag ;
: item[]  ( n - adr ) cells inventory + ;
: get  ( qty objtype - ) item[] +! ;
: .item  ( obj - )  dup .type  ."  qty: " 's qty ? ;
: pickup ( obj - ) >{ cr ." Picked up: " me .item  qty @ objtype @ get dismiss } ;
: have  ( objtype - n )  item[] @ ;

( npc's )
16 16 s" npc.png" >data tileset: npc.png
: /npc  #npc flags !  npc.png img ! ;
