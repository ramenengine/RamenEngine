depend 3dpack/v3d.f

stage actor: cam
transform: t
transform: t2
transform: t3
transform: camt

ALLEGRO_PRIM_LINE_LIST      constant LINE_LIST
ALLEGRO_PRIM_LINE_STRIP     constant LINE_STRIP
ALLEGRO_PRIM_LINE_LOOP      constant LINE_LOOP
ALLEGRO_PRIM_TRIANGLE_LIST  constant TRIANGLE_LIST
ALLEGRO_PRIM_TRIANGLE_STRIP constant TRIANGLE_STRIP
ALLEGRO_PRIM_TRIANGLE_FAN   constant TRIANGLE_FAN
ALLEGRO_PRIM_POINT_LIST     constant POINT_LIST

\ Model data structs
struct %modeldata
    %modeldata 2 cells sfield vertices   \ pointer, count
    %modeldata 2 cells sfield indices    \ pointer, count
    %modeldata svar primtype

: >count  cell+ ;

: f,  sf, ;
: v,  ( x y z u v -- )
    1pf 1pf 1pf 1pf 1pf f, f, f, f, f, fore 4@ 4, ;
    
: vertices:  ( modeldata -- modeldata adr )
    here dup third vertices !  white ;

: ;vertices  ( modeldata adr -- )
    here swap - /ALLEGRO_VERTEX i/ 1p swap vertices >count ! ;
 
: modeldata  ( primtype -- )
    0 , 0 , 0 , 0 , , ;

: indices:  ( modeldata -- modeldata adr )
    here over indices ! here  decimal ;

: ;indices  ( modeldata adr -- )
    locals| adr model |
    here adr - cell/ model indices >count !  fixed ;

: v[]  ( n modeldata - adr )  vertices @ swap /ALLEGRO_VERTEX * + ;


\ Model objects

extend: _actor
    %v3d sizeof field pos
    %v3d sizeof field scl
    \ 0 field rtn  \ tilt, pan, roll  (i.e. pitch, yaw, roll)
        var tilt
        var pan
        var roll
    var mdl <adr
    var tex <adr
;class

_actor prototype as
    1 1 1 scl 3!


1e 1sf constant (1e)
0e 1sf constant (0e)
create axis  3 cells allot
: modelview
    t 0transform
    
    t (1e) (0e) (0e)  roll @ 1pf d>r 1sf   al_rotate_transform_3d
    t (0e) (1e) (0e)  pan @ 1pf d>r 1sf   al_rotate_transform_3d    
    (0e) (0e) (1e) axis 3! 
    t axis dup >y over >z al_transform_coordinates_3d    
    t axis 3@  tilt @ 1pf d>r 1sf  al_rotate_transform_3d

    t2 0transform
    t2 scl 3@ 3af al_scale_transform_3d
    t2 t al_compose_transform
    t2 pos 3@ 3af al_translate_transform_3d
    t2 t3 16 cells move
    t2 camt al_compose_transform
    t2 al_use_transform
;

: texture@  tex @ dup if >bmp then ;

: model  ( -- )
    mdl @ -exit
    modelview
    mdl @ indices @ if 
        mdl @ vertices @
        0 \ vertex decl
        texture@
        mdl @ indices 2@ 1i
        mdl @ primtype @
        al_draw_indexed_prim
    else
        mdl @ vertices 2@ 1i >r
        0 \ vertex decl
        texture@
        0 \ first vertex
        r> \ last vertex
        mdl @ primtype @
        al_draw_prim
    then
;


: camera-transform  ( -- )
    camt identity
    camt pos 3@ 3negate 3af al_translate_transform_3d    
    camt (0e) (0e) (1e)  roll @ negate >rad 1af al_rotate_transform_3d
    camt (0e) (1e) (0e)  pan @  negate >rad 1af al_rotate_transform_3d
    camt (1e) (0e) (0e)  tilt @ negate >rad 1af al_rotate_transform_3d
;


: /model  mdl !  draw> model ;

\ : -camt  camt al_identity_transform ;
\ : /globalmodel  mdl !  draw> +state -camt model -state ;


0 value (code)

: veach  ( xt modeldata -- )  ( ALLEGRO_VERTEX -- )
    swap >code to (code)  vertices 2@ for
        dup >r  (code) call  r> /ALLEGRO_VERTEX +
    loop drop ;
    
: veach>  ( modeldata -- <code> )  
    r> code> swap veach ;
    
: transform-model  ( modeldata -- )  \ uses the "t" transform
    veach>  t swap vtransform ;


create (v) 3 cells allot

: 3f@p  dup sf@ f>p swap cell+ dup sf@ f>p swap cell+ sf@ f>p ;

: local  ( x y z -- x y z )  \ transform local point  (note: expensive!)
    modelview  3af (v) 3!  t3 (v) vtransform   (v) 3f@p  ;