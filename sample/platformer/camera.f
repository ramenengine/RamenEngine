
( camera )
: /follow
    act> me stage push              \ keep the camera on top of everything, makes it process last
    physics>                        \ assign physics
    guy 's x 2@ 2pfloor viewwh 2halve 2pfloor 2-  x 2!  \ position relative to player so it is centered
    x 2@ 0 0 2max x 2!              \ prevent view going out of bounds.  (x/y can't be less than 0,0)
    x 2@ 2pfloor bg0 's scrollx 2!  \ scroll the background.
;
cam as /follow             \ create the camera
