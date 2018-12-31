( object types )
1
enum #link
enum #test
enum #sword
enum #bomb
enum #potion
enum #rupee
enum #orb
enum #statue
value nextitemtype

( link )
defobj link
    include sample/zelda/link.f
    #sprite <link> 's gfxtype !
    <link> :to /settings link.ts img !   #solid flags !   0 8 cx 2!   16 8 mbw 2!   0 0 ihb xy! ;
    #item <link> :hit  you pickup ;

( blue orb thing )
defobj orb
    #circle <orb> 's gfxtype !
    <orb> :to /settings   blue tinted ;
    <orb> :to start  -5 orbit ;
    #weapon <orb> :hit  1 me damage ;

defrole <item>
    <item> :to /settings  item-regions rgntbl !  items.image img !  #item +flag ;

( bomb )
defobj bomb
    #sprite <bomb> 's gfxtype !
    <bomb> :to /settings  <item> -> /settings  4 quantity !  1 spr ! ;
    
( potion )
defobj potion
    #sprite <potion> 's gfxtype !
    <potion> :to /settings  <item> -> /settings  2 spr ! ;

