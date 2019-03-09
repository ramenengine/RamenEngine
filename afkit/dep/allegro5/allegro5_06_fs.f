decimal \ important

function: al_create_fs_entry   ( path -- entry )
function: al_destroy_fs_entry  ( entry -- )
function: al_get_fs_entry_name ( entry -- cname )

: bit  dup constant  1 lshift ;
1
bit ALLEGRO_FILEMODE_READ    \ 1
bit ALLEGRO_FILEMODE_WRITE   \ 1 << 1
bit ALLEGRO_FILEMODE_EXECUTE \ 1 << 2
bit ALLEGRO_FILEMODE_HIDDEN  \ 1 << 3
bit ALLEGRO_FILEMODE_ISFILE  \ 1 << 4
bit ALLEGRO_FILEMODE_ISDIR   \ 1 << 5
drop

\ AL_FUNC(bool,                 al_update_fs_entry,  (ALLEGRO_FS_ENTRY *e));

function: al_get_fs_entry_mode ( fsentry -- n )

function: al_get_fs_entry_atime ( ALLEGRO_FS_ENTRY -- ms )
function: al_get_fs_entry_mtime ( ALLEGRO_FS_ENTRY -- ms )
function: al_get_fs_entry_ctime ( ALLEGRO_FS_ENTRY -- ms )
function: al_get_fs_entry_size  ( ALLEGRO_FS_ENTRY -- ofs )
function: al_fs_entry_exists    ( ALLEGRO_FS_ENTRY -- flag )
function: al_remove_fs_entry    ( ALLEGRO_FS_ENTRY -- flag )

function: al_open_directory   ( ALLEGRO_FS_ENTRY -- bool )
function: al_read_directory   ( ALLEGRO_FS_ENTRY -- fsentry )
function: al_close_directory  ( ALLEGRO_FS_ENTRY -- bool )


\ AL_FUNC(bool,                 al_filename_exists,  (const char *path));
\ AL_FUNC(bool,                 al_remove_filename,  (const char *path));
\ AL_FUNC(char *,               al_get_current_directory, (void));
\ AL_FUNC(bool,                 al_change_directory, (const char *path));
\ AL_FUNC(bool,                 al_make_directory,   (const char *path));
\
\ AL_FUNC(ALLEGRO_FILE *,       al_open_fs_entry,    (ALLEGRO_FS_ENTRY *e,
\                                                     const char *mode));
\


\ /* Helper function for iterating over a directory using a callback. */

-1
enum   ALLEGRO_FOR_EACH_FS_ENTRY_ERROR \ = -1
enum   ALLEGRO_FOR_EACH_FS_ENTRY_OK    \ =  0
enum   ALLEGRO_FOR_EACH_FS_ENTRY_SKIP  \ =  1
enum   ALLEGRO_FOR_EACH_FS_ENTRY_STOP  \ =  2
drop
5 1 9 [compatible] function:  al_for_each_fs_entry  ( fs_entry_dir callback extra -- int )  \ ( fs_entry extra -- enum )
\ AL_FUNC(int,  al_for_each_fs_entry, (ALLEGRO_FS_ENTRY *dir,
\                                      int (*callback)(ALLEGRO_FS_ENTRY *entry, void *extra),
\                                      void *extra));
