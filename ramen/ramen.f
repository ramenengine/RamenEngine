[undefined] [ramen] [if] 
    include afkit/ans/version.f
    #2 #0 #0 [version] [ramen]
    
    cr .( Loading Ramen... ) \ "
    include ramen/base.f          \ gilded
    [in-platform] sf [if]
        include ramen/ide/ide.f   \ gilded
        include ramen/system.f    \ gilded, extends `IDE`
    [then]
[then]

cr .( Loaded Ramen. ) \ "