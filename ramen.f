[defined] [ramen] [if] \\ [then]
[defined] gforth [if]
    include ~+/afkit/ans/version.f
[else]
    include afkit/ans/version.f
[then]
#1 #8 #0 [version] [ramen]
cr .( Loading Ramen... ) \ "
[defined] gforth [if]
    include ~+/ramen/base.f          \ gilded
[else]
    include ramen/base.f          \ gilded
[then]

[in-platform] sf [if]
    include ramen/ide/ide.f   \ gilded
[then]
