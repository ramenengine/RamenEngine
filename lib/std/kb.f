: keydown   over #5 rshift #1 + #2 lshift + @ swap #31 and #1 swap lshift and 0<> ;
: klast     kblast keydown ;
: kstate    kbstate keydown ;
: kdelta    >r  r@ kstate #1 and  r> klast #1 and  - ;
: pressed   kdelta #1 = ;
: released  kdelta #-1 = ;
