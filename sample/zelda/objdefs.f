( object types )
1
enum #link
enum #test
enum #sword
enum #bomb
enum #potion
enum #orb
enum #statue
value nextitemtype

( link )
defobj link
    include sample/zelda/link.f
    #sprite <link> 's gfxtype !
    <link> :to /settings link.ts img !   #solid flags !   16 8 mbw 2!   0 0 ihb xy! ;

( blue orb thing )
defobj orb
    #circle <orb> 's gfxtype !
    <orb> :to /settings   ['] blue >body 4@ tint 4! ;
    <orb> :to start -5 orbit ;
    #weapon <orb> :hit  1 me damage ;
