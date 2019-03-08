true constant dev
\ true constant HD
include ramen/ramen.f         
ide
include ws/ws.f

( Directory )
: option:  >in @ bl parse button >in ! : ;

: help
    s" [[[ Ramen 2.0 ]]]" label nr
    s" <Tab> = toggle the console" label nr
    s" <F10> = toggle the gui" label nr
    s" <F5> = reload last file" label nr
    s" <Shift-F5> = reload the session" label nr
    s" <F2> = new page, toggle all" label nr
    s" <Alt-Enter> = toggle fullscreen" label nr 
;
help
    
: empty  empty  s" common-ui.f" file-exists if s" common-ui.f" included then ; 

permanent off  \ "gild" system assets
gild           \ and gild the dictionary
include common-ui.f

s" session.f" file-exists [if]
    include session.f
[then]
