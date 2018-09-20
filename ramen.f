exists empty [if] empty [then]
include afkit/ans/version.f
#1 #1 0 [version]
include ramen/base.f
[undefined] LIGHTWEIGHT [if]
    include ramen/default.f
[THEN]
only forth definitions marker (empty)  \ gild point for empty
ide-loaded @ not [if]
    [in-platform] sf [if]
        include ramen/ide/ide.f   \ gilded
        s" test.f" file-exists [if]  ld test  [then]
    [then]
[then]