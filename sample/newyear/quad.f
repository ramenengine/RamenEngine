( quad model )
create quad.mdl TRIANGLE_STRIP modeldata
quad.mdl vertices:
    white 
    -1 -1 0 0 1 v,  \ btm left
    -1  1 0 0 0 v,  \ top left
     1  1 0 1 0 v,  \ top right
     1 -1 0 1 1 v,  \ btm right
;vertices
quad.mdl indices:
    0 , 1 , 2 ,
    0 , 2 , 3 , 
;indices