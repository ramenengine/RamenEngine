: PARSE-WORD ( "<spaces>name" - c-addr u )   /SOURCE OVER >R  BL SKIP DROP R> - >IN +!  BL PARSE ;
: [platform]     platform parse-word compare 0= ; immediate
: [in-platform]  platform parse-word search nip nip ; immediate

[in-platform] win32 [if]
    #2 attribute  cr .( ====== Windows note ====== )  #0 attribute
    cr .( The audio codec and other addons will not work on Windows unless )
    cr .( you copy all of the Allegro DLL's to your host Forth's bin folder. )
    cr .( You can still load the Allegro DLL without doing this; you just won't )
    cr .( be able to play anything but WAV files or call certain other functions.)
    cr
[then]

[in-platform] win32 [if] true constant win32 [then]
[in-platform] linux [if] true constant linux [then]
