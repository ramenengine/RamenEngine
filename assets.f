\ Asset manager with automatic import and asynchronous loading

\ Importing
\ IMPORT  ( -- <path> <name> )  Loads an asset from a file, creates word(s) if they don't already exist.  Otherwise it is updated.  The naming convention is:
\ Images: .PNG .JPG .BMP .GIF (and all formats supported by Allegro ): image-<name> ( -- image )
\ Samples: .WAV .MP3. .OGG etc: sample-name ( -- sample )
\    and *<name>* ( -- ) Shorthand for playing the sample
\ The name is optional.  If none is given it will be automatically taken from the filename.

\ PRELOAD  ( -- <path> <name> )  This works the same as IMPORT but the asset will be loaded synchronously
\   at the startup of the published runtime, ensuring that it is available.

\ LOOKUP ( addr c -- asset | 0 )  Can be used to look up an asset by path instead of name.
\ UPDATE ( -- )  Will cause all assets to be updated if they have been changed (timestamps are checked against the last ones).  This operation is synchronous.

\ Automatic Import
\ GATHER ( path c -- ) The given direcotry will be searched recursively and all images and audio
\ samples will have assets automatically created for them and added to the asset manager.
\ All of these assets will be set to load asynchronously if they were not already PRELOADed.
\ When you publish your app , all asset references will have their paths changed to "data/"

\ Asynchronous runtime loading
\ GET  ( asset -- )  Will load an asset immediately normally, but if the piston is running,
\   asynchronous loading will be used and an event will fire when it is ready.
\ GETALL  ( -- )  Like GET but all assets will be loaded.  Called at start of published runtime.
\ The asynchronously loader works in the background while the piston is running.
\ Actually, the files will immediately start to be loaded by a separate thread and put in
\ temporary buffers.
\ The actual turning of these buffers into usable assets is handled one at a time,
\ only if the piston is running.  Handle the events generated every time an asset is finished
\ loading in your GO> code.  An ALLEGRO_USER_EVENT will be generated.  The struct for that is defined below.  Process these with @EVENT until another kind of event is generated.
\ TODO: How to check that all assets are done loading?

[undefined] assets [if]
    create assets
[then]
