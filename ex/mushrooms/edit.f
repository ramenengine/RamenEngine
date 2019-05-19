variable tile

: cursor  ( - col row ) p1 's x 2@ bank subwh 2 2 2/ 2+ bank subwh 2/ 2pfloor ;
: tilebuf   ( - array ) tilebuf ;
: bankcols  ( - cols ) bank image.subcols @ ;

: g* globalscale * ;
: 2g*  g* swap g* swap ;
: tileret
    tile @ if 
        tile @ 1 -  bankcols /mod   bank subwh 2*  2 2 2*  +at
        white bank subwh 2 2 2* rect
    then
;
: tileset
    \ draw tileset
    displayw vieww g* - bank imagew 2 * - 0 at white 1 alpha bank >bmp dup bmpwh 2 2 2* sblit
    \ draw tile selection reticule
    tileret
;
: editor  unmount tileset ;

: controls
    etype ALLEGRO_EVENT_KEY_CHAR = if
        ctrl? if
            keycode case
                <r> of  reload  endof
                <s> of  savemap  cr ." Saved." endof
            endcase
        ;then
        keycode case
            <1> of  -1 tile +!  endof
            <2> of   1 tile +!  endof
            <3> of   bankcols negate tile +!  endof
            <4> of   bankcols tile +!  endof
        endcase
    ;then
;

: scontrols
    <space> kstate if  tile @ cursor tilebuf loc !  then
;

\ moves the view to the top right corner and forces globalscale to 3.
: shove
    #3 to #globalscale
    identity
    globalscale dup scale
    displayw vieww g* - 0 translate
    tpush
    displayw vieww g* - 0 mountwh clip ;

: /edit
    0 perform>
        begin
            2 <space> kstate if 2 * then
            <left> kstate if dup negate x +! then
            <right> kstate if dup x +! then
            <up> kstate if dup negate y +! then
            <down> kstate if dup y +! then
            drop
        pause
        again 
;

reload 
p1 { /edit :now act> scontrols ; }
:now  show> ramenbg mount shove update-camera playfield editor ;
:now  pump> controls ;
