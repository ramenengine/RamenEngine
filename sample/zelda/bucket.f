
\ old scrolling code::::
\ : fakeload   -vel  0 anmspd @!  15 pauses  anmspd ! ;
\ : shiftwait  begin pause scrshift @ 0= until
\     x @ 1 + dup 8 mod - x !  y @ 1 + dup 8 mod - y !  idle ;
\ : scroll  fakeload  godir  shiftwait ;
\     dirkeys? -exit
\     x @ camx @ -  0 <=  left? and             if  0 scroll  then
\     x @ camx @ -  320 mbw @ -  >=  right? and if  1 scroll  then
\     y @ camy @ 8 + -  0 <=  up? and           if  2 scroll  then
\     y @ camy @ -  208 mbh @ -  >=  down? and  if  3 scroll  then ;


