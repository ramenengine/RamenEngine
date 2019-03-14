include ramen/basic.f
include ramen/lib/std/tilemap2.f
320 240 resolution

( misc )
depend afkit/ans/param-enclosures.f
depend sample/tools.f
depend sample/events.f

create startxy 0 , 0 ,
stage actor: cam

( upscaling )
depend ramen/lib/upscale.f
:now show> ramenbg 0 0 at upscale> stage draws ;