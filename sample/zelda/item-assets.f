s" weapon-sprites.png" >data image: weapons.image
s" item-sprites.png" >data image: items.image
create weapon-regions
    2 , 1 , 16 , 16 , 0 , 0 , \ 0 wood sword (right)
create item-regions
    104 , 0 , 8 , 16 , -4 , 0 , \ 0 wood sword (up)
    136 , 0 , 8 , 16 , -4 , 0 , \ 1 bomb
    80 , 0 , 8 , 16 , -4 , 0 ,  \ 2 potion
    
weapon-regions weapons.image 0 autoanim: anim-swordr 0 , ;anim
weapon-regions weapons.image 0 autoanim: anim-swordl 0 h, ;anim
item-regions items.image 0 autoanim: anim-swordu 0 , ;anim
item-regions items.image 0 autoanim: anim-swordd 0 v, ;anim

create evoke-sword dir-anim-table  ' anim-swordr , ' anim-swordd , ' anim-swordl , ' anim-swordu ,