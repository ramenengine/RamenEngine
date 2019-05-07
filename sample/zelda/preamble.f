include ramen/basic.f                   \ load the basic packet
include ramen/lib/std/tilemap2.f

256 236 resolution                      \ set the virtual screen resolution

( misc )
depend afkit/ans/param-enclosures.f   
depend sample/tools.f                   \ common toolkit for the samples
depend sample/events.f                  \ event system
depend ramen/lib/upscale.f              \ upscale (fat pixels) support


