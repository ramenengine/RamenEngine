: area  ( x y w h -- x1 y1 x2 y2 )  2over 2+ ;
: lowerupper  ( n n -- lower higher )  2dup > if  swap  then ;
: between  ( n n -- n )  lowerupper  over -  #1 +  rnd + ;
: vary  ( n rnd -- n )  dup 0.5 *  -rot rnd +  swap - ;
: 2vary  ( n n rnd rnd -- n n )  rot swap vary >r vary r> ;
: either  ( a b - a | b )  2 rnd if  drop  else  nip  then ;
: 2ratio  ( x y w h xfactor. yfactor. - x y )  2* 2+ ;
: middle  ( x y w h - x y )  0.5 0.5 2ratio ;
: 2halve  0.5 0.5 2* ;

\ center a rectangle (1) in the middle of another one (2).  returns x/y of top-left corner.
: center  ( w1 h1 x y w2 h2 - x y )  2halve 2rot 2halve 2- 2+ ;

\ find a random position in the rectangle (x,y,x+w,y+h)
: 2rnd  ( x y -- x y )  rnd swap rnd swap ;
: somewhere  ( x y w h - x y )  2rnd 2+ ;

\ find if 2 rectangles (x1,y1,x2,y2) and (x3,y3,x4,y4) overlap.
: overlap? ( xyxy xyxy - flag )
  2swap 2rot rot > -rot < and >r rot > -rot < and r> and ;

: inside?  ( xy xyxy - flag )  2>r 2>r 2dup 2r> 2r> overlap? ;

