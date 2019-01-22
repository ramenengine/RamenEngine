
create-type <test>
    s" enemy-icon.png" >data image: enemy-icon.png
    <test> :to setup  draw> damaged @ if now 1 and ?exit then  enemy-icon.png >bmp blit ;
    #weapon <test> :hit  1 damage ;