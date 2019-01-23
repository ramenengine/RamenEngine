\ this convenience word will automatically define and load
\ all the script files in a given dir.
\ i need to wrap Allegro's al_for_each_fs_entry(), which
\ depends on the ability to create ALLEGRO_FS_ENTRY's
\ and possibly other Allegro functions.
\ that's a lot of work.  for now, just gonna do it by hand.
\ : load-scripts  ( path c - )
\     2>r
\     
\     2r> drop
\ ;

( object types - maintain the ordering to keep savestates coherent )
create-type r-link
create-type r-test
create-type r-sword
create-type r-bomb
create-type r-potion
create-type r-rupee
create-type r-orb
create-type r-statue
create-type r-swordattack
create-type r-dude


( load in scripts - order doesn't matter - later on i'll automate this )
include sample/zelda/obj/link.f
include sample/zelda/obj/test.f
include sample/zelda/obj/sword.f
include sample/zelda/obj/bomb.f
include sample/zelda/obj/potion.f
include sample/zelda/obj/rupee.f
include sample/zelda/obj/orb.f
include sample/zelda/obj/statue.f
include sample/zelda/obj/swordattack.f
include sample/zelda/obj/dude.f
