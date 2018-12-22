\ Standard library set
\ Very general purpose

depend ramen/lib/std/rangetools.f  cr .( Loaded rangetools module. ) \ "
depend ramen/lib/std/task.f        cr .( Loaded task module. ) \ "
depend ramen/lib/std/cgrid.f       cr .( Loaded collision grid module. ) \ "
depend ramen/lib/std/zsort.f       cr .( Loaded zsort module. ) \ "
depend ramen/lib/std/v2d.f         cr .( Loaded vector2d module. ) \ "
depend ramen/lib/std/kb.f          cr .( Loaded keyboard lex. ) \ "
depend ramen/lib/std/audio1.f      cr .( Loaded audio module. ) \ "
depend ramen/lib/std/sprites.f     cr .( Loaded sprites module. ) \ "
depend ramen/lib/std/tilemap.f     cr .( Loaded tilemap module. ) \ "
depend ramen/lib/tiled/tiled.f     cr .( Loaded Tiled support. ) \ "

:slang think  stage dup acts multi ;
:slang physics  stage each> as vx 2@ x 2+! ;
: default-step  step> think physics stage sweep ;
