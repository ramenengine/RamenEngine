include sample/zelda/loz.f
/overworld  3 3 warp

\ test objects:
64 128 at *orb
64 180 at *statue


( cave text test )

: takethis
    dialog>
        32 128 8 - 8 - 8 - at
        s"   IT'S DANGEROUS TO GO" print
        0 8 +at
        s"     ALONE! TAKE THIS." print
;

:listen
    s" player-entered-cave" occurred if
        takethis
    ;then
;

( placeholder creature hordes )

: roomwh  #cols #rows 16 16 2* ;
: roomxy  room# @ src-rowcol 32 - 16 16 2* ;
: roombox  ( - x y x y )  roomxy roomwh aabb ;

\ note: Tiled stores positions with Y representing the BOTTOM of the object.
\ we compensate by subtracting 16 from it.
:make enemyimage ( node gid - )
    2drop  at@ roombox inside? if roomxy 2negate 64 + 16 - +at *test then
;
