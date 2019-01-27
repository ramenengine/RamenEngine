true constant dev
\ true constant HD
include ramen/ramen.f         
\ fs on
ide
\ include ws/ws.f             
\ ui off

( Directory )
: wstest   s" ld ws/test" evaluate ;
: 3d2019   s" ld sample/3d2019/3d2019" evaluate ;
: loz    s" ld sample/zelda/loz" evaluate ;
gild

s" session.f" file-exists [if]
    include session.f
[else]
    include main.f
[then]
                                                                                     