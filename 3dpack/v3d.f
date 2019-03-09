struct %v3d
    %v3d svar v3d.x
    %v3d svar v3d.y
    %v3d svar v3d.z
: 3+  >r rot >r 2+ r> r> + ;
: 3+! dup >r 3@ 3+ r> 3! ;
: >x ;
: >y cell+ ;
: >z cell+ cell+ ;
: z@ >z @ ;
: z! >z ! ;
: z+! >z +! ;
: 3negate  negate >r 2negate r> ;
: 3mod  >r rot >r 2mod r> r> mod ;


: 3uvec  ( tilt pan -- x y -z )
    uvec >r  swap uvec nip  r>  negate ;

\ : 3uvec  ( tilt pan -- x y z )  swap 1pf d>r 1pf d>r ( f: yaw pitch ) 
\     fover fcos fover fcos f* f>p
\     fswap fsin fover fcos f* f>p
\     fsin f>p 
\ ;
: 3*  >r rot >r 2* r> r> * ;
: 3vec  ( tilt pan len -- x y z ) >r 3uvec r> dup dup 3* ;

: 3rnd  >r rot >r 2rnd 2r> rnd ;

: vtransform  ( transform v3d )  dup cell+ dup cell+ al_transform_coordinates_3d ;
