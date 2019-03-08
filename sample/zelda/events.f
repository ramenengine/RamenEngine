( misc global events )

:listen
    s" player-left-room" occurred if
        in-cave @ if
            overworld return
            in-cave off
            dialog off
            0 s" player-exited-cave" occur
        else
            link0 as
            x @ 0 < if        gw 256 16 - x ! ;then
            x @ 256 16 - > if ge 0 x ! ;then
            y @ 64 16 + < if  gn 240 8 - y ! ;then
            y @ 256 16 - > if gs 64 17 + y ! ;then
        then
    ;then
    s" player-entered-cave" occurred if
        ( x y ) in-cave on
    ;then
;