warning off
true constant dev
\ true constant HD
true constant opengl
include ramen/ramen.f
\ include ws1/ws1.f
\ ui off


fs on
ide
include ramen/stdpack.f
include ramen/lib/upscale.f
:now show> ramenbg upscale> stage draws ;
gild

ld main
