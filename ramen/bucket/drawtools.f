: print+  ( str c - ) 2dup print stringw 0 +at ;
: +line  ( ox oy ) destxy pofs 2+ line ;
: line+  ( ox oy ) 2dup +line +at ;
