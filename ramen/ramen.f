[undefined] [ramen] [if] 
    include afkit/ans/version.f
    #2 #0 #0 [version] [ramen]
    
    cr .( Loading Ramen... ) \ "
    include ramen/base.f          \ gilded
    [in-platform] sf [if]
        include ramen/ide/ide.f   \ gilded
    [then]
[then]

cr .( Loaded Ramen. ) \ "