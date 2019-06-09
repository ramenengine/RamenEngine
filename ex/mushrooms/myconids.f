( myconids )
16 16 s" myconids.png" >datapath tileset: myconids.png
s" dig.png" >datapath image: dig.png
_actor fields:
    var leader
    var state
    var job
1 32 / constant walk-anim-speed
myconids.png walk-anim-speed autoanim: /myconid1.anim 2 , 3 , 4 , 3 , ;anim
myconids.png walk-anim-speed autoanim: /myconid2.anim 6 , 7 , 8 , 7 , ;anim
myconids.png walk-anim-speed autoanim: /engineer.anim 11 , 12 , 13 , 12 , ;anim

: /myconid1  /shadowed /myconid1.anim ;
: /myconid2  /shadowed /myconid2.anim ;
: -v  0 0 vx 2! ;
: rdelay  0.5 2 between delay ;
: dist  's x x proximity ;
: close?  leader @ dist 40 < ;
: /wander  
    0 perform> begin    
        leader @ if
            close? if
                360 rnd 0.5 vec vx 2! rdelay -v rdelay 
            else
                pause
            then
        else
            -v rdelay 360 rnd 0.5 vec vx 2! rdelay 
        then
    again ;
: chase   leader @ 's x x vdif angle 1.5 vec vx 2! ;
: enlist  p1 leader !  enlisted# state !  /wander
    me party push 
    act> close? not if chase /wander then ;
: drawn?   ( - f ) p1 's net @ dup -exit dup dist swap 's radius @ 2 + <= ;
: /?enlist  act> drawn? if cr ." Join!" enlist then ;
: disengage  cr ." Leave!"  /wander  leader off  roaming# state !  /?enlist
    me party remove ;

: /myconid  [myconid] role !  /myconid2 /solid /wander /?enlist ;
: /engineer [myconid] role !  engineer# job !  /solid  /wander /?enlist
    /engineer.anim   draw>  !org  1 1 shadow sprite     9 nsprite ;

: in-party ( job - n )
    locals| j |
    0 party each> { job @ j = if 1 + then } 
;

( digging stuff )
: ?dig
    
;

( avatar )
: /strobe  ( amount ) perform> grow 5 pauses 0.05 fadeout p1 's net off end ;
: strobe ( radius - )  me 0 0 from stage *actor dup net ! { /net /strobe } ;
: release   stage each> { state @ enlisted# = if disengage then } ;
: /avatar   [myconid] role !  1.333 /vpan  /solid
    act>
        <space> pressed if 40 strobe then
        <q> pressed if release then
        <d> pressed if ?dig then
;