warning off
true constant dev
\ true constant HD
true constant opengl
include ramen/ramen.f         cr .( Loaded Ramen. ) \ "
\ fs on
ide
include ws/ws.f               cr .( Loaded Workspace. ) \ "
ui off
include ramen/stdpack.f       cr .( Loaded Standard Pack. ) \ "

( Directory )
: wstest   s" ld ws/test" evaluate ;
: 3d2019   s" ld sample/3d2019/3d2019" evaluate ;
gild

( Load main program )
ld main