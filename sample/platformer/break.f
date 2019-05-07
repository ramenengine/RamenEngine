
: break
    at@ nip 16 + groundy ! green
    at@ 16 for 16 for
        2dup i j 2+ at 115 *particle drop
        -0.02 0.02 between 0 0.1 between vx 2! 0.03 ay ! \ 0.01e afade sf!
    loop loop 2drop ;