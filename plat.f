[in-platform] sf [if]
: newprompt
    source-id 0= if  #tib @ 0= if ok then  then
    cr
    DEPTH 0> if  DEPTH 0 DO  S0 @ I 1+ CELLS - @ h.  LOOP  ." > " THEN
    depth 0= if ." > " then
    ;
' newprompt is prompt
[then]