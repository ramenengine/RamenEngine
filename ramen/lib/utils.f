: nodetree:  create _node static, ;
: vector:  create 3, ;
: color:  create 4, ;

: >datapath  ( adr c - adr c )  \ prepend assets with data path
    project count s" data/" strjoin 2swap strjoin ;  


: /pan  ( speed - ) \ move something with arrowkeys
    perform> begin
        <left> kstate if dup negate x +! then
        <right> kstate if dup x +! then
        <up> kstate if dup negate y +! then
        <down> kstate if dup y +! then
        pause again
;

: /vpan  ( speed - ) \ move something with arrowkeys; uses velocity
    perform> begin
        0 0 vx 2!
        <left> kstate if dup negate vx ! then
        <right> kstate if dup vx ! then
        <up> kstate if dup negate vy ! then
        <down> kstate if dup vy ! then
        pause again
;