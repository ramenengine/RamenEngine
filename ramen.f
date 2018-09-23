exists empty [if] empty [then]
include afkit/ans/version.f
#1 #3 0 [version] [ramen]
include ramen/base.f
ide-loaded @ not [if]
    [in-platform] sf [if]
        include ramen/ide/ide.f   \ gilded
        s" test.f" file-exists [if]  ld test  [then]
    [then]
[then]