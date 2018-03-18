
\ Basic structs; forward-compatible with smallfry, but valtypes are thrown away
: sfield  ( struct bytes valtype -- <name> )  ( adr -- adr+n )
    drop create over @ ,  swap +!  does> @ + ;
: svar  cell swap sfield ;

: struct variable ;
create int
create cstring

: sizeof  @ ;
