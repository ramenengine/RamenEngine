
( extend loop )
: think  ( - ) stage acts  tasks multi  stage multi  tasks acts ;
: physics ( - ) stage each> as ?physics vx 2@ x 2+! ;
: zelda-step ( - ) step> think physics interact sweep ;
: zelda-show  ( - ) show> ramenbg upscale> stage draws ;
zelda-step zelda-show
