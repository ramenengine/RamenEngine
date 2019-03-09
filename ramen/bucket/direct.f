
( commandline-only task assignment ... not useful )

: direct  ( obj - <word> )  '  0  rot  perform ;
: direct:  ( obj - ... code ... ; )  :noname  [char] ; parse evaluate  0  rot  perform ;

