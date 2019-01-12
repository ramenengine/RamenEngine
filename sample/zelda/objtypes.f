( flags )
nextflag
bit #weapon
bit #inair
\ bit #entrance
\ bit #ground
\ bit #fire
\ bit #water
bit #npc
bit #item
bit #enemy
to nextflag

include sample/zelda/lib.f

( object types )
deftype <link>
deftype <test>
deftype <sword>
deftype <bomb>
deftype <potion>
deftype <rupee>
deftype <orb>
deftype <statue>
deftype <swordattack>
deftype <dude>

( ----------------------- Object Definitions ------------------------ )

( link )
    include sample/zelda/obj/link.f
    <link> :to setup  #solid flags !   0 8 cx 2!   16 8 mbw 2!   0 -8 ihb xy! ;
    #item <link> :hit  you pickup ;

( blue orb thing )
    #circle <orb> 's gfxtype !
    <orb> :to setup   blue tinted ;
    <orb> :to start  -5 orbit ;
    #weapon <orb> :hit  1 me damage ;

( bomb )
    <bomb> :to setup  /item  4 quantity !  1 spr ! ;
    
( potion )
    <potion> :to setup  /item  2 spr ! ;

( sword )
    <sword> :to setup  /item  anim-swordu ;
    :listen
        #sword have not if 
            s" player-entered-cave" occurred if
                128 8 - 160 at *sword 
            ;then
        then
    ;
    
( sword attacks )
    <swordattack> :to setup  #directional #weapon or flags ! ;
    : in-front 
        dir @ case
            0 of 12 2 x 2+! 14 ihb h! endof
            270 of 0 -12 x 2+! endof
            180 of -12 2 x 2+! 14 ihb h! endof
            90 of 0 12 x 2+! endof
        endcase ;
    : retract  /clipsprite dir @ 180 + 4 vec vx 2! ;
    <swordattack> :to start  in-front evoke-sword ;
    : swordstab  spawn *swordattack ['] retract 7 after 9 live-for ;
    :listen
        s" player-swung-sword" occurred if
            p1 from { swordstab }
        ;then   
    ;
    
( dude )
    <dude> :to setup  /npc   1 spr ! ;
    