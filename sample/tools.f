( tasks )
objlist tasks

extend-class _actor
    var (xt) <xt
    var target <adr
    var targetid
end-class

: ?waste  target @ >{ ?id ?dup if @ targetid @ <> ?end then } ;
: target!   dup target ! >{ ?id ?dup if @ targetid ! then } ;
: *task  me tasks one  target!  act> ?waste ;
: (after)  perform> pauses (xt) @ target @ >{ execute } end ;
: after  ( xt n - ) { *task swap (xt) ! (after) } ;
: after>  ( n - <code> ) r> code> swap after ;
: (every)  perform> begin (xt) @ target @ >{ execute } dup pauses again ;
: every  ( xt n - ) { *task swap (xt) ! (every) } ;
: every>  ( n - <code> ) r> code> swap every ;