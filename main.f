: /chr  draw> sprite+ ;

16 16 s" sam/zelda/data/link-tiles-sheet.png" tileset: link.ts
stage object: link
link.ts img !
/chr
10 10 sx 2!

create rgns
0 , 0 , 16 , 16 , 8 , 8 ,
16 , 0 , 16 , 16 , 8 , 8 ,
32 , 0 , 16 , 16 , 8 , 8 ,
48 , 0 , 16 , 16 , 8 , 8 ,

rgns link.ts 1 6 / anim: testanim 0 , 1 , 2 , 3 , ;anim
testanim
