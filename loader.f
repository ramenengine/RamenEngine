true constant dev
\ true constant HD

include ramen/ramen.f         
ide

permanent off  \ "gild" system assets
gild           \ and gild the dictionary

s" session.f" file-exists [if]
    include session.f
[then]
