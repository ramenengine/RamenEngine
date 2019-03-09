depend ramen/stdpack.f
depend 3dpack/v3d.f       cr .( Loaded vector3d module. ) \ "    
depend 3dpack/model.f     cr .( Loaded 3d model module. ) \ "
depend 3dpack/cam3d.f     cr .( Loaded 3d camera module. ) \ "

: 3>r  s" >r >r >r" evaluate ; immediate
: 3r>  s" r> r> r>" evaluate ; immediate
: 3over  #5 pick #5 pick #5 pick ;

transform: p 
80 value fov

: f  fov >rad 2 / tan ;
: asp  viewwh / ;

: 3d
    p al_identity_transform
    p 0 0 -1 3af al_translate_transform_3d
    p   asp f * negate 1af   f 1af           1 1af
        asp f * 1af          f negate 1af    32768 1af
    al_perspective_transform
    p al_use_projection_transform
    ALLEGRO_DEPTH_TEST #1 al_set_render_state
    1 1af al_clear_depth_buffer 
;

create pen3 0 , 0 , 0 ,
: at3  pen3 3! ;
: at3@  pen3 3@ ;
: +at3  pen3 3+! ;
: xz@  dup >x @ swap >z @ ;
: xz!  dup >r >z ! r> >x ! ;

cam as :now draw> camera-transform ;