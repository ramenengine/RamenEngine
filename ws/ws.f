\ really basic workspaces functionality; just buttons (and labels that are also buttons)
[defined] wsing [if] \\ [then]

#2 #0 #0 [version] [ws]
#1 #5 #0 [ramen] [checkver]

only forth definitions

create window  %rect sizeof /allot
create hovered 32 stack,
variable ui  ui on
create mouse 0 , 0 ,

( element class )
0 node-class: _element
    var attr  
    0 field span \ pos and dims
    var x var y var w var h
    var data <adr 
    var datasize <int 
;class
:noname  data @ free throw ; _element class.destructor !

create figure _element static

    
define wsing
    include ws/rangetools.f

    ( attributes )
    #1 8 <<
    \ bit #deleted
    bit #boxed
    bit #newrow
    bit #click
    drop
        
    \ --- Low-level stuff ---
    : ??  attr @ and 0<> ;
    : pos@  span xy@ ;
    : pos!  span xy! ;
    : dims@  span wh@ ;
    : dims!  span wh! ;
    : ew@   dims@ drop ;
    : eh@   dims@ nip ;
    : *element  ( figure - me=new )  \ add an element
        _element dynamic  me swap push ;
    : data@  ( - adr n )
        data @ datasize @ ;
    : data!  ( adr n - )
        data @ 0= if  dup allocate throw data ! dup datasize !
                  else  data @ over resize throw data ! dup datasize ! then
        ( adr n ) data @ swap move ;
                  
    \ --- Display ---
    : newrow  margins x@  peny @ fnt @ chrh + 30 + at ;
    : boxshadow  5 5 +at  dims@ black 0.5 alpha rectf  -5 -5 +at ;
    : printdata  data@ print ;
    : textoutline
        at@  black 1 alpha
            1 0 +at  printdata
            0 1 +at  printdata
            -1 0 +at printdata
            -1 0 +at printdata
            0 -1 +at printdata
            0 -1 +at printdata
            1 0 +at  printdata
            1 0 +at  printdata
        at
    ;
    : drawlabel  at@  0 13 +at  textoutline  white printdata  at  ew@ penx +! ;
    : drawbutton
        at@  
        #click ?? if
            2 2 +at
            dims@ dgrey rectf  dims@ lgrey rect 
        else
            boxshadow  dims@ grey rectf  dims@ white rect 
        then
        16 12 +at  printdata
        at
        ew@ 15 + penx +! ;
    
    : pos2@  pos@ dims@ 2+ ;
    : draw
        #newrow ?? if  newrow  exit  then
        data@ stringwh 32 16 2+ dims!
        penx @ ew@ + 15 + displayw >= if  newrow  then
        at@ pos!
        #boxed ?? if  drawbutton
                  else  drawlabel  then 
    ;
        
        
    ( transformation stack )
    create mstack 16 cells 32 * /allot
    variable (m)
    : m  (m) @ [ 16 cells 32 * #1 - ]# and mstack + ;
    : mfetch  ( transform - )  m swap 16 cells move ;
    : mpush ( transform - )  16 cells (m) +!   m 16 cells move  m al_use_transform ;
    : mdrop  ( - )  -16 cells (m) +!  m al_use_transform ;
    m al_identity_transform m al_use_transform
    : translate  ( transform x y - ) 2af al_translate_transform ;
    : scale  ( transform sx sy - ) 2af al_scale_transform ;
    : rotate  ( transform angle - ) 1af al_rotate_transform ;
    : hshear  ( transform n - ) 1af al_horizontal_shear_transform ;
    : vshear  ( transform n - ) 1af al_vertical_shear_transform ;
    
    ( draw relative )
    transform: r:m
    
    : relative>  ( object - <code> )
        >{  r:m mfetch  r:m  pos@ [undefined] HD [if] 2pfloor [then] translate  r:m mpush }
        r> call
        mdrop ;
        
    : draw-window
        window xy@ 10 10 2- at  window wh@ 20 20 2+ black 0.4 alpha rectf  ;
    
    : /window
        displayw 0.37 * 500 max displayw min  displayh 100 - window wh!
        displayw window w@ - 0 window xy!
        window xywh@ margins xywh!
    ;
    
    : (ui)  ( figure - )
        /window  draw-window  margins xy@ at  dup relative>  each> as draw ;
    
    \ --- interaction ---
    : ?hover  ( figure - )
        hovered vacate
        each> as
            mouse xy@ pos@ me node.parent @ >{ pos@ } 2+ dims@ area inside? if
                me hovered push  
            then
    ;
    : click
        me
        hovered >top @ >{
            #boxed ?? if
                #click attr or!
                data@ } rot ( data count old-me ) as ['] evaluate catch ?.catch
            ;then
            drop 
        } 
    ;
    : ?click  hovered length -exit  click ;
    : unclick  figure each> as  #click attr not! ;

    consolas chrh 30 + constant rowh

\ --- Public stuff ---
only forth definitions also wsing


: window:up   figure >{ y @ rowh - y ! } ;
: window:down figure >{ y @ rowh + 0 min y ! } ;

: ws:pageup   mouse xy@ window aabb@ inside? if window:down else ide:pageup then ;
: ws:pagedown mouse xy@ window aabb@ inside? if window:up else ide:pagedown then ;

: ui-mouse
    etype ALLEGRO_EVENT_MOUSE_AXES = if
        evt ALLEGRO_MOUSE_EVENT.x 2@ 2p mouse xy!
        { figure ?hover }
        evt ALLEGRO_MOUSE_EVENT.dz @ 0 > if ws:pageup then
        evt ALLEGRO_MOUSE_EVENT.dz @ 0 < if ws:pagedown then
    then
    etype ALLEGRO_EVENT_MOUSE_BUTTON_DOWN = if ?click then
    etype ALLEGRO_EVENT_MOUSE_BUTTON_UP = if { unclick } then
;

: blank  ( figure )
    vacate
;
: button  ( text c )  { figure *element data! #boxed attr ! } ;
: label  ( text c )   { figure *element data! } ;
: nr  { figure *element #newrow attr ! } ;  \ new row
: drawui  consolas font>  unmount  figure (ui) ;

: ?toggle-ui
    etype ALLEGRO_EVENT_KEY_DOWN = keycode <f10> = and if  ui @ not ui !  then
    etype ALLEGRO_EVENT_KEY_DOWN = keycode <f2> = and if
        repl @ ui @ or if page repl off ui off else repl on ui on then
    then 
;
: (system)   ide-system  ?toggle-ui  ui @ if ui-mouse then ;

[defined] dev [if]
    0 value ui:lasterr
    :make ?system
        ['] (system) catch
        dup if ui:lasterr 0= if cr ." GUI error." dup to ui:lasterr throw ;then then
        to ui:lasterr
    ;
    
    :make ?overlay  ide-overlay  ui @ if drawui then  unmount ;
    
    :make free-node  destroy ;
    
    : empty  hovered vacate  fs @ not if unclick then  figure blank  _element invalidate-pool  empty ;
    
    oscursor on 
[then]

gild