\ Asset manager, simple version

\ asseting
\ asset  ( path c -- <name> )  Loads an asset from a file, creates word(s) if they don't already exist.  Otherwise it is updated.  The naming convention is:
\ Images: .PNG .JPG .BMP .GIF (and all formats supported by Allegro ): image-<name> ( -- image )
\ Samples: .WAV .MP3. .OGG etc: sample-name ( -- sample )
\    and *<name>* ( -- ) Shorthand for playing the sample

\ Updating
\ UPDATE ( -- )  Will cause all assets to be updated if they have been changed (timestamps are checked against the last ones).  This operation is synchronous.

\ Runtime Loading
\ /ASSETS ( -- )  Loads all assets.  This is called by published runtimes at startup.

\ -------------------------------------------------------------------------------------------------

struct file
    file int svar file.link
    file int svar file.mtime           \ last modified timestamp
    file int svar file.asset           \ image or sample pointer
    file int svar file.type
    file 256 cstring sfield file.path
    \ file int svar file.async
    
[undefined] assets [if]
    variable assets  \ backward linked list
[then]

: link,  here over @ , swap ! ;
: file>mtime  zstring al_create_fs_entry dup al_get_fs_entry_mtime swap al_destroy_fs_entry ;
: sanitize ( adr c -- adr c )  \ replace spaces and underscores with dashes
    -trailing
    2dup bl [char] - replace-char
    2dup [char] _ [char] - replace-char ;
: loadbitmap  0 al_set_new_bitmap_flags    zstring al_load_bitmap ;

\ --------------------------------------------------------------------------------------------------

: #assets  ( -- n )  0  assets @ begin ?dup while  1 u+  file.link @  repeat ;
: .asset
    dup file.path count type  space space file.asset @ body> >name count type ;
: .assets  ( -- )
    cr ." Total: " #assets 1i i.
    assets @ begin ?dup while  dup cr .asset file.link @  repeat ;

\ --------------------------------------------------------------------------------------------------

: lookup  ( addr c -- asset-file | 0 )
    locals| c addr |
    assets @ begin dup while  dup file.path count addr c compare -exit  file.link @  repeat ;

\ --------------------------------------------------------------------------------------------------

\ : *asset  \ just images for now
\    " image: image-"  2over sanitize strjoin  evaluate ;

: asset  ( path c -- <name> )
    create 2dup $image >r
        assets link,  2dup file>mtime ,  r> ,  0 ( file.type ) ,  here 256 allot place ;

\ --------------------------------------------------------------------------------------------------
: image-loader  dup file.path count loadbitmap swap file.asset @ init-image ;

create loaders  ' image-loader ,
: (load)  dup file.type @ cells loaders + @ execute ;
: /assets ( -- )
    assets @ begin ?dup while
        dup cr .asset  dup  (load)  file.link @ repeat ;


\ TBD
: update ( -- ) ;
