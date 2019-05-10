true constant dev

include ramen/ramen.f         
ide

: platformer  s" ld sample/platformer/platformer" evaluate ;

permanent off  \ "gild" system assets
gild           \ and gild the dictionary

s" session.f" file-exists [if]
    include session.f
[then]

