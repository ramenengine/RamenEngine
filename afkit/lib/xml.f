
\ XML reading tools

: parsexml ( adr len - dom )
   dom-new >r  true r@ dom-read-string 0= throw  r> ;

: loadxml  ( adr c - dom nnn-root )
    file@  2dup parsexml -rot  drop free throw  dup  dom>tree nnt-root@ ;

define xmling
    : value@  ( dom-nnn - adr c )  dom>node>value str-get ;
    : istype  ( dom-nnn type - dom-nnn flag )  over dom>node>type @ = ;
    : named?  ( dom-nnn adr c - dom-nnn flag ) third dom>node>name str-get $= ;
    : >first  nnn>children dnl>first @ ;
    : >next  ( dom-nnn - dom-nnn|0 )  nnn>dnn dnn-next@ ;

    \ : stash   2dup pocket place ;
    \ : ?print  dup if  pocket count type space  then ;
    \ : xmlname  dom>node>name str-get ;

    \ get # of child elements of given name
    : #elements  ( dom-nnn adr c - n ) 0 locals| n c adr |
        >first begin dup while  dom.element istype if  adr c named? if  1 +to n  then  then
        >next  repeat  drop n ;

    : (find)  ( dom-nnn adr c type - dom-nnn | 0 )  locals| type c adr |
        begin dup while  type istype if  adr c named? ?exit  then  >next  repeat ;

    : findchild  2>r >r >first r> 2r> (find) ;

    : element  ( dom-nnn n adr c - dom-nnn|0 )
        locals| c adr n |
        >first
        n 1 + for  adr c dom.element (find) dup 0= abort" XML element not found"
            i n <> if >next then  loop ;

    : attr?  ( dom-nnn name c - flag )  dom.attribute findchild 0<> ;

    : val  ( dom-nnn name c - val c )       \ get value of an attribute as a string
        locals| c name |
        name c dom.attribute findchild dup 0=
            if  name c type  true abort" XML attribute not found"  then
        value@ ;

    : pval  ( dom-nnn name c - n )  val number ;
    : ival  decimal pval fixed ;

    : text  ( dom-nnn - text c | 0 )  s" " dom.text findchild value@ ;

    : eachel  ( dom-nnn xt - ) ( dom-nnn - )
        swap >first
        begin dup while  dom.element istype if
            2dup 2>r  swap execute    2r>
        then   >next  repeat  2drop ;

    : eachel>  ( dom-nnn - <code> )  ( dom-nnn - )
        r> code> eachel ;

    : (that's)  named? ?exit  drop  r> drop ;

    : that's  bl parse postpone sliteral  ['] (that's) compile, ; immediate

only forth definitions
