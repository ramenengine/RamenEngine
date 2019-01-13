

( load the Tiled data )
s" overworld-rooms.tmx" >data open-map
    s" testrooms1" find-tmxlayer tilebuf  0 32 load-tmxlayer  \ load well below the room buffer
    s" overworld-tiles.tsx" find-tileset# load-tileset


( loading a room )
defer enemyimage  ' 2drop is enemyimage
create enemy-handlers  0 , ' enemyimage , 0 ,
: *enemies
    s" overworld-rooms.tmx" >data open-map
    s" Enemy Locations" find-objgroup enemy-handlers load-objects
;
: srcrc  #cols /mod #cols #rows 2* 32 + ;
: disposable?  dynamic? important? not and ;
: thinout  ['] disposable? swap those> dismiss ;
: cleanup  stage thinout  world thinout ;
: room  ( i - )  \ expressed as $cr  c=column r=row 
    cleanup
    1p dup room# ! srcrc tilebuf adr-pitch
    0 4 roombuf adr-pitch
    #cols cells #rows 2move
    0 ['] *enemies later
;

: cave  ( - )
    $37 room
    128 8 - 236 8 - 2 s" player-entered-cave" occur ;


( world )
struct %world
    %world object-maxsize sfield world>objlist
    %world svar world.rooms
    
: defworld  ( w h - <name> )
    objlist 0 , 
    here me world.rooms ! ( w h ) array2d-head,
        \ array ought to be last thing in dictionary so that we can comma rooms in
    does>
        \ world stage remove  dup stage push
        to world ;

: maploc  ( col row - adr )
    world world.rooms @ loc ;

: warp  ( col row )  2dup coords 2!  maploc @ room ;

( go north go south etc )
: gn  coords 2@ 0 -1 2+ warp ;
: gs  coords 2@ 0 1 2+ warp ;
: ge  coords 2@ 1 0 2+ warp ;
: gw  coords 2@ -1 0 2+ warp ;

: return  coords 2@ warp ;

