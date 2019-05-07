
( item stuff )
_actor fields:
    var qty

_actor >prototype as
    1 qty !

ld item-assets
256 cells quest-field inventory
: /item  items.image img !  #item +flag ;
: item[]  ( n - adr ) cells inventory + ;
: get  ( qty role - ) role>type item[] +! ;
: .item  ( obj - )  dup .type  ."  qty: " 's qty ? ;
: have  ( role - n )  role>type item[] @ ;
: pickup ( obj - ) { cr ." Picked up: "
    me .item  qty @ role @ get
    ." Have: " role @ have .  me dismiss } ;
