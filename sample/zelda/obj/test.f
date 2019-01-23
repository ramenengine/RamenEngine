
create-type r-test
    s" enemy-icon.png" >data image: enemy-icon.png
    r-test :to setup  draw> damaged @ if now 1 and ?exit then  enemy-icon.png >bmp blit ;
    #weapon r-test :hit  1 damage ;