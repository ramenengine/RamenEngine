objlist: temp
stage actor: tunnelbg
128 128 * array: tunnelbuf

: stash  stage each> temp push ;
: unstash  temp each> stage push ;
: thinout  each> { dyn @ if me dismiss then } ;
: cleanup  stage thinout sweep ;

: construct
    stash
    one act>
        <esc> pressed if cleanup unstash then ;
        
