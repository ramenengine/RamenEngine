
( Data )
16 16 s" link-tiles-sheet.png" >data tileset: link.ts
create rgns
0 , 0 , 16 , 16 , 8 , 8 ,
16 , 0 , 16 , 16 , 8 , 8 ,
32 , 0 , 16 , 16 , 8 , 8 ,
48 , 0 , 16 , 16 , 8 , 8 ,
rgns link.ts 1 6 / anim: testanim 0 , 1 , ;anim

( Logic )



: /link  link as  link.ts img ! /sprite testanim ;