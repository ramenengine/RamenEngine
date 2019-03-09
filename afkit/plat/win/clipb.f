create clp 256 allot
: clipb@  ( - adr c )
    GetForegroundWindow OpenClipboard -exit
    CF_TEXT GetClipboardData ?dup -exit GlobalLock
        dup zcount clp place
        GlobalUnlock drop
    CloseClipboard drop
    clp count ;
0 value gh  0 value gm
: clipb!  ( adr c - )
    GetForegroundWindow OpenClipboard -exit
    EmptyClipboard DROP
    GMEM_MOVEABLE over #1 + GlobalAlloc to gh
    gh GlobalLock to gm
    gm swap move
    CF_TEXT gh SetClipboardData DROP
    gh GlobalUnlock DROP
    CloseClipboard drop ;
