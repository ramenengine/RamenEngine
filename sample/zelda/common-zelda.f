\ more attributes
nextflag
bit #weapon
drop

\ var col  var row

( canned motions )
: orbit  ( n ) !startxy perform> 0 begin dup 16 vec startx 2@ 2+ x 2! over + pause again ;

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
action gotten ( - )
include sample/zelda/item-assets.f
256 cells qfield inventory
: /item  item-regions rgntbl !  items.image img !  #item +flag ;
: item[]  ( n - adr ) cells inventory + ;
: get  ( quantity objtype - ) item[] +! ;
basis :to gotten  ( - )  quantity @ objtype @ get ;
\ : .item  ( obj - )  dup >{ h. ."  Type: " itemtype ?  ."  Quantity: " quantity ? } ;
: pickup ( obj - ) >{ ( cr ." Got: " me .item ) gotten dismiss } ;
: have  ( itemtype - n )  item[] @ ;
