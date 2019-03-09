

( load the Tiled data )
: reload
    -tiles -bitmaps 
    s" overworld-rooms.tmx" >data open-map
        s" testrooms1" find-tmxlayer tilebuf  0 32 load-tmxlayer  \ load well below the room buffer
        s" overworld-tiles.tsx" find-tileset# load-tileset
; reload

( loading a room )
defer enemyimage  ' 2drop is enemyimage
create enemy-handlers  0 , ' enemyimage , 0 ,
: *enemies
    {
        s" overworld-rooms.tmx" >data open-map
        s" Enemy Locations" find-objgroup enemy-handlers load-objects
    }
;
: disposable?  dyn @ #important set? not and ;
: thinout  ['] disposable? swap those> dismiss ;
: cleanup  stage thinout ;

: !roomsrc ( room# - )
    #cols /mod #cols #rows 2* 32 +   #cols #rows  srcrect xywh! ;

: room  ( i - )  \ expressed as $cr  c=column r=row 
    1p dup room# !
    !roomsrc  tilebuf dup 0 4 put2d 
    cleanup *enemies
;

: cave  ( - )
    $37 room
    128 8 - 236 8 - 2 s" player-entered-cave" occur ;


( world )
nodetree: worlds

0 node-class: _world
    var rooms  \ array2d
;class
    
: world:  ( - <name> )  ( - )
    create _world static  me to world  me worlds push
    does>  to world  0 world worlds indexof world# !
;

: rooms:  ( w h - )
    here world 's rooms ! ( w h ) array2d-head, ;

: maploc  ( col row - adr )
    world 's rooms @ loc ;  

: warp  ( col row )
    2dup coords 2!  maploc @ room ;

( go north go south etc )
: gn  coords 2@ 0 -1 2+ warp ;
: gs  coords 2@ 0 1 2+ warp ;
: ge  coords 2@ 1 0 2+ warp ;
: gw  coords 2@ -1 0 2+ warp ;

: return  coords 2@ warp ;

