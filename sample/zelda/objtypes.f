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
create-type `link
create-type `test
create-type `sword
create-type `bomb
create-type `potion
create-type `rupee
create-type `orb
create-type `statue
create-type `swordattack
create-type `dude


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
