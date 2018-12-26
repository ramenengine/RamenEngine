\ inventory
\   the game will keep track of a bunch of "bundles"
\   for simplicity bundles are gonna be Ramen objects
\   bundle fields: (planned)
\       item type
\       quantity
\       world location
\           world#: -1 = nowhere, 0 = being carried by player
\           col,row
\           x,y

\   instead of having a world# field we'll stow objects
\   in world objlists, and the savestate will store these lists
\   consecutively with a count for each one.
\   if we really wanted, we could compact this data, but i don't think i'm gonna bother.

var itemtype
var quantity
var col  var row
objlist inventory

: !loc    coords 2@ row ! col ! ;

: /bundle  ( itemtype quantity - )
    quantity ! itemtype ! !loc ;

: ?type=  ( type obj - flag )
    's itemtype @ over = ;

: >firstlike  ( itemtype objlist - object|0 )
    0 ['] ?type= rot which@ nip ;
    
: have?  ( itemtype - quantity )
    inventory >firstlike dup if 's quantity @ then ;

: ?consolidated  ( object - object )
    >{
        itemtype @ inventory >firstlike ?dup if
            ( obj ) quantity @ over 's quantity +!
            me free-node
        else
            me
        then
    } ;

: get  ( object - )
    dup >parent inventory = if drop ;then
    ?consolidated inventory push  ;

: leave  ( object - )
    at@ world push x 2! !loc ;

\ spawn #sword 1 /bundle me constant test