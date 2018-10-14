variable smoothers
defer cb
: each-data  ( xt adr -- )  ( ... adr -- ... )
    swap is cb  begin @ ?dup while  dup >r  cell+ cb   r> repeat ;
: add-data  ( adr -- )  dup @ here rot ! , ;
: @execute  @ execute ;
: :smooth  smoothers add-data here 0 , :noname swap ! ;
: smooth   ['] @execute smoothers each-data ;
: smooths  ( objlist )  each> smooth ;
: lerp!  ( adr dest-val factor -- )  >r  over @ swap r> lerp swap ! ;
