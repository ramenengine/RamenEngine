
: sfield  ( struct bytes valtype -- <name> )  ( adr -- adr+n )
    drop create over @ ,  swap +!  does> @ + ;
: svar  cell swap sfield ;

: struct variable ;
create int
create cstring

: sizeof  @ ;
