true constant dev
true constant allegro-debug
0 0 0 include ramen/ramen.f
[in-platform] sf [if]
    include ramen/ide/ide.f
    'source-id @ close-file drop
    s" test.f" file-exists [if]  ld test  [then]
    ide
[then]  