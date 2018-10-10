
\ Audio API 1

variable sid
: play  ( sample -- )
    dup >r  >smp 1e 0e 1e 3sf  r> sample.loop @  sid  al_play_sample ;

ALLEGRO_PLAYMODE_ONCE  constant once
ALLEGRO_PLAYMODE_BIDIR constant bidir
ALLEGRO_PLAYMODE_LOOP  constant looping

variable strm
: stream ( adr c loopmode -- )
    >r
    zstring   #3 #2048  al_load_audio_stream strm !
    strm @ r> al_set_audio_stream_playmode drop
    strm @ mixer al_attach_audio_stream_to_mixer drop ;

