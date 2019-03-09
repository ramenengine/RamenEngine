[undefined] [version] [if]
: packver  swap 8 lshift or swap 24 lshift or ;
: (checkver)  ( ver ver - )
    over 0 = if 2drop exit then
    2dup
    swap $ff000000 and swap $ff000000 and <> abort" Incompatible major version!"
    2dup
    swap $00ffffff and swap $00ffffff and > abort" Incompatible minor version and/or revision!"
    swap $00ffff00 and swap $00ffff00 and < if
        cr  #2 attribute ." Version mismatch warning: "
        #3 attribute
        space including -path type ." : "
        space tib #tib @ type
        #0 attribute
    then
;
: .line  cr tib #tib @ type ;
: [version]  ( M m R - <name> )  .line packver constant ;
: [checkver]  ( M m R packver - )
    depth 4 < abort" Missing version spec!"
    >r packver r> (checkver) ;

[then]

\ versions are expressed as three values M = major, m = minor, R = revision
\ in documentation, they're expressed as M.m.r
\ Major versions are always source breaking
\ Minor versions are generally additions, but also sometimes deletions, renames, and semantic changes
\ Revisions are bugfixes, and benign tweaks such as dox and housekeeping


