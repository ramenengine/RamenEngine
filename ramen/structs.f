also venery
    0 value lastfield
    
    struct %struct
        %struct %node sembed struct>node
        %struct svar struct.size

    struct %field
        %field %node sembed field>node
        %field svar field.offset
        %field svar field.size
        %field svar field.inspector

    : struct:  create %struct *struct /node ;
    
    : (.field)  ( adr size - )
        bounds ?do i @ dup if . else i. then cell +loop ;
        
    : create-field  ( struct bytes - <name> )  ( - field )
        swap  >r
        create
            here to lastfield
            %field *struct dup /node  dup r@ push
            r@ struct.size @ over field.offset !
            ['] (.field) over field.inspector !  \ initialize the inspector
            udup field.size !
                r> struct.size +! ;

previous

            
: sfield  ( struct bytes - <name> )  ( adr - adr+n )
    create-field
        does> [ 0 field.offset ]# + @ + ;
        
: svar  ( struct - <name> )  ( adr - adr+n )
    cell sfield ;

: sizeof  ( struct - size )
    struct.size @ ;
    
: *struct  ( struct - adr )
    here swap sizeof /allot ;

: struct,  ( struct - )
    *struct drop ;

: is>  ( - <code> ; )  ( adr size - )
    r> code> lastfield field.inspector ! ;

: (.fields)
    each> ( adr field )
        normal         
        dup body> >name ccount type space
        bright
        2dup dup field.size @ swap field.inspector @ execute
        field.size @ +   \ go to next field in the passed instance
;

: .fields ( adr struct - )
    dup node.first @ field.offset @ u+  (.fields) drop ;

[defined] h. [if]
    : <hex  is> drop @ dup 0= if #5 attribute then ." $" h. normal ;
    : <adr  <hex ;
[else]
    : <adr  ;
[then]
[defined] f. [if]
    : <float is> drop sf@ f. ." e" ;
[then]
: <cstring  is> drop ccount type ;
: <string  is> drop count type ;
: <flag  is> drop @ if ." true " else ." false " then ;
: <body  is> drop @ .name ;
: <word  is> drop @ dup if >body .name else i. then ;
