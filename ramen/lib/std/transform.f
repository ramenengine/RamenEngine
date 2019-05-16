( transformation stack )
create mstack 16 cells 32 * /allot
transform: t:m
variable (m)

: mactive  ( - adr ) (m) @ 16 cells - [ 16 cells 32 * #1 - ]# and mstack + ;
: mtop  ( - adr ) (m) @ [ 16 cells 32 * #1 - ]# and mstack + ;
: mget  ( - ) al_get_current_transform mtop 16 cells move ;   
: tpush ( - )  16 cells (m) +!  mactive al_use_transform  mactive mtop 16 cells move ; 
: tpop ( - )  -16 cells (m) +!  mactive al_use_transform  mactive mtop 16 cells move ;

( transformation ops )
: translate  ( x y - ) 2af mtop -rot al_translate_transform ;
: scale  ( sx sy - ) 2af mtop -rot al_scale_transform ;
: rotate  ( angle - ) >rad 1af mtop swap al_rotate_transform ;
: hshear  ( n - ) 1af mtop swap al_horizontal_shear_transform ;
: vshear  ( n - ) 1af mtop swap al_vertical_shear_transform ;
: identity  ( - ) mtop al_identity_transform ;
: compose  ( - )  mtop mactive al_compose_transform ;
: mount   ( - ) tpop mount mget tpush ;
: unmount   ( - ) tpop unmount mget tpush ;

identity tpush  

: transform  ( - )
    identity
    sx 2@ scale
    ang @ rotate
    x 2@ [undefined] HD [if] 2pfloor [then] translate
    compose
    0 0 at 
;

: view  ( - )
    identity
    x 2@ [undefined] HD [if] 2pfloor [then] 2negate translate
\    ang @ negate rotate
    1 1 sx 2@ 2/ scale
    compose
    0 0 at
;

: view>  ( - <code> )
    view tpush r> call tpop ;

: transform>  ( - <code> )
    r> at@ 2>r  transform tpush  call  tpop  2r> at ;
