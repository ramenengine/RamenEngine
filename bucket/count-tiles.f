depend ramen/lib/stride2d.f

: (count-tiles)    map@ tileprops@ (bm) and -exit  1 +to (count) ;
: count-tiles  ( x y w h bitmask tilesize - count )
    swap  to (bm)  0 to (count)  locals| ts h w y x |
    ['] (count-tiles)  x ts / y ts /  w ts / 1 max h ts / 1 max  1 1 stride2d
    (count) ; 