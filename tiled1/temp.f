16 cellstack: tilesets
16 cellstack: firstgids

: (tiles)  xmleach>  " tile" ?xml -exit  over call ;

: tiles>  ( tileset -- <code> )  >el  r>  (code) >r  to (code)  (tiles) r> to (code) ;



: aggregate  ( node adr c cellstack -- )  locals| cs c a |
    cs 0 truncate  a c xmlfirst begin  ?dup while  dup cs push  a c  xmlnext repeat ;

: +tileset  ( firstgid tileset -- )
    dup tilesetdoms push  " tileset" >first  swap tilesets push  tilesets push ;

: load-tilesets
    tilesetdoms scount for  @+ dom-free  loop drop
    tilesetdoms 0 truncate
    tilesets 0 truncate
    mapnode " tileset" eachel> dup " firstgid" attr
    swap +tileset ;

