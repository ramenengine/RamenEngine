: 2!  swap over cell+ ! ! ;
: 2@  dup @ swap cell+ @ ;
: 2+!  swap over cell+ +! +! ;
: 3@  dup @ swap cell+ dup @ swap cell+ @ ;
: 4@  dup @ swap cell+ dup @ swap cell+ dup @ swap cell+ @ ;
: 3!  dup >r  2 cells + !  r> 2! ;
: 4!  dup >r  2 cells + 2! r> 2! ;


\ Pen
create penx  0 ,  here 0 ,  constant peny
: at   ( x y -- )  penx 2! ;
: +at  ( x y -- )  penx 2+! ;
: at@  ( -- x y )  penx 2@ ;

\ Allegro stuff
: -bmp  ?dup -exit al_destroy_bitmap ;
