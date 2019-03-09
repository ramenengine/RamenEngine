        img @ image.subw @ if
            img @ image.subw 2@ 0.5 0.5 2* cx 2!
        else 
            img @ imagewh 0.5 0.5 2* cx 2!
        then
        
        
( compile-time struct literal tools )
: field+  >body @ + ;
: := ( baseadr - <fieldname> <values...> baseadr )
    0 locals| n |
    dup >r ' field+ ( fieldadr )
        begin bl parse ?dup while
            evaluate over !
            cell+
        repeat
        ( fieldadr c-addr ) drop drop
    r>
;
: $= ( baseadr - <fieldname> <string> baseadr )
    dup ' field+ >r 0 parse r> place ;