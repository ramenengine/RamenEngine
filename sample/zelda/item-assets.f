s" weapon-sprites.png" >data image: weapons.image
s" items_OG.png" >data image: items.image
    16 16 items.image subdivide

here weapons.image image.regions !
    2 , 1 , 16 , 16 , 0 , 0 , \ 0 wood sword (right)

weapons.image 0 autoanim: anim-swordr 0 , ;anim
weapons.image 0 autoanim: anim-swordl 0 ,h ;anim
items.image 0 autoanim: anim-swordu 15 , ;anim
items.image 0 autoanim: anim-swordd 15 ,v ;anim

create evoke-sword dir-anim-table  ' anim-swordr , ' anim-swordd , ' anim-swordl , ' anim-swordu ,