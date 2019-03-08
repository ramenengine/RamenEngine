
( item stuff )
ld item-assets
256 cells quest-field inventory
: /item  items.image img !  #item +flag ;
: item[]  ( n - adr ) cells inventory + ;
: get  ( qty role - ) role>type item[] +! ;
: .item  ( obj - )  dup .type  ."  qty: " 's qty ? ;
: pickup ( obj - ) >{ cr ." Picked up: " me .item  qty @ role @ get dismiss } ;
: have  ( role - n )  role>type item[] @ ;