\ Allegro's audio API has been loaded already, so we don't load it here.

0 value mixer
0 value voice

: -audio
    mixer -exit
    mixer 0 al_set_mixer_playing drop 
;

: +audio
    mixer if  mixer #1 al_set_mixer_playing drop  exit then 
    #44100 ALLEGRO_AUDIO_DEPTH_INT16 ALLEGRO_CHANNEL_CONF_2 al_create_voice to voice
    #44100 ALLEGRO_AUDIO_DEPTH_FLOAT32 ALLEGRO_CHANNEL_CONF_2 al_create_mixer to mixer
    mixer voice al_attach_mixer_to_voice 0= abort" Couldn't initialize audio"
    mixer al_set_default_mixer drop
    mixer #1 al_set_mixer_playing drop
;

: initaudio
    0 to mixer  0 to voice
    al_init_acodec_addon not if  s" Allegro: Couldn't initialize audio codec addon." alert -1 abort  then
    al_install_audio not if  s" Allegro: Couldn't initialize audio." alert -1 abort  then
    #32 al_reserve_samples not if  s" Allegro: Error reserving samples." alert -1 abort  then
    +audio
;

: updateaudio
;
