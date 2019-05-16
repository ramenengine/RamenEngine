: array:  create array, ;
: stack:  create stack, ;
: nodetree:  create _node static, ;
: vector:  create 3, ;
: color:  create 4, ;

: >datapath  ( adr c - adr c )  \ prepend assets with data path
    project count s" data/" strjoin 2swap strjoin ;  


: /pan  \ move something with arrowkeys
    act>
        <left> kstate if -1 x +! then
        <right> kstate if 1 x +! then
        <up> kstate if -1 y +! then
        <down> kstate if 1 y +! then
;
        