: array:  create array, ;
: stack:  create stack, ;
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
        