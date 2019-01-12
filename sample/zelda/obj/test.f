
deftype <test>
    s" enemy-icon.png" >data image: enemy-icon.image
    <test> :to setup  draw> damaged @ if now 1 and ?exit then  enemy-icon.image >bmp blit ;
    #weapon <test> :hit  1 damage ;