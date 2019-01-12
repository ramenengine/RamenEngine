deftype <sword>
    <sword> :to setup  /item  anim-swordu ;
    
    :listen
        #sword have not if 
            s" player-entered-cave" occurred if
                128 8 - 160 at *sword 
            ;then
        then
    ;