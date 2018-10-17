variable smoothers
defer cb
: each-data  ( xt adr -- )  ( ... adr -- ... )
    swap is cb  begin @ ?dup while  dup >r  cell+ cb   r> repeat ;
: add-data  ( adr -- )  dup @ here rot ! , ;
: @execute  dup @ execute  ;
: +smoother  ( xt -- )  ( adr -- )  smoothers add-data , ;
: smooths  ( objlist )  each> ['] @execute smoothers each-data ;
: lerp!  ( adr dest-val factor -- )  >r  over @ swap r> lerp swap ! ;
