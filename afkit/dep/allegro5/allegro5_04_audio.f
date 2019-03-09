linux-library liballegro_acodec

decimal \ important

\ addon: codec
function: al_init_acodec_addon ( -- bool )
function: al_get_allegro_acodec_version ( -- n )

\ addon: audio
#define ALLEGRO_EVENT_AUDIO_STREAM_FRAGMENT  513
#define ALLEGRO_EVENT_AUDIO_STREAM_FINISHED  514

\   /* Sample depth and type, and signedness. Mixers only use 32-bit signed
\    * float (-1..+1). The unsigned value is a bit-flag applied to the depth
\    * value.
\    */
#define ALLEGRO_AUDIO_DEPTH_INT8      $00
#define ALLEGRO_AUDIO_DEPTH_INT16     $01
#define ALLEGRO_AUDIO_DEPTH_INT24     $02
#define ALLEGRO_AUDIO_DEPTH_FLOAT32   $03
#define ALLEGRO_AUDIO_DEPTH_UNSIGNED  $08
ALLEGRO_AUDIO_DEPTH_INT8  ALLEGRO_AUDIO_DEPTH_UNSIGNED or constant ALLEGRO_AUDIO_DEPTH_UINT8
ALLEGRO_AUDIO_DEPTH_INT16 ALLEGRO_AUDIO_DEPTH_UNSIGNED or constant ALLEGRO_AUDIO_DEPTH_UINT16
ALLEGRO_AUDIO_DEPTH_INT24 ALLEGRO_AUDIO_DEPTH_UNSIGNED or constant ALLEGRO_AUDIO_DEPTH_UINT24 

#define   ALLEGRO_PLAYMODE_ONCE    $100
#define   ALLEGRO_PLAYMODE_LOOP    $101
#define   ALLEGRO_PLAYMODE_BIDIR   $102
#define   _ALLEGRO_PLAYMODE_STREAM_ONCE    $103   \ /* internal-*/
#define   _ALLEGRO_PLAYMODE_STREAM_ONEDIR  $104   \  /* internal-*/

#define   ALLEGRO_MIXER_QUALITY_POINT    $110
#define   ALLEGRO_MIXER_QUALITY_LINEAR   $111
#define   ALLEGRO_MIXER_QUALITY_CUBIC    $112

#fdefine ALLEGRO_AUDIO_PAN_NONE      -1000.0e

#define    ALLEGRO_CHANNEL_CONF_1   $10
#define    ALLEGRO_CHANNEL_CONF_2   $20
#define    ALLEGRO_CHANNEL_CONF_3   $30 
#define    ALLEGRO_CHANNEL_CONF_4   $40
#define    ALLEGRO_CHANNEL_CONF_5_1 $51
#define    ALLEGRO_CHANNEL_CONF_6_1 $61
#define    ALLEGRO_CHANNEL_CONF_7_1 $71

\ general
function: al_reserve_samples ( int-reserve_samples -- bool )
function: al_install_audio ( -- bool )
function: al_uninstall_audio ( -- )
function: al_play_sample ( ALLEGRO_SAMPLE-*data, float-gain, float-pan, float-speed, ALLEGRO_PLAYMODE-loop, ALLEGRO_SAMPLE_ID-*ret_id -- )
function: al_stop_sample ( ALLEGRO_SAMPLE_ID-*spl_id -- )
function: al_stop_samples ( -- )
function: al_destroy_sample ( sample -- )
function: al_load_sample ( const-char-*filename -- ALLEGRO_SAMPLE )
function: al_load_audio_stream ( const-char-*filename, size_t-buffer_count, unsigned-int-samples -- ALLEGRO_AUDIO_STREAM )
function: al_save_sample ( const-char-*filename, ALLEGRO_SAMPLE-*spl -- bool )

\ stream
function: al_create_audio_stream ( size_t-buffer_count, unsigned-int-samples, unsigned-int-freq, ALLEGRO_AUDIO_DEPTH-depth, ALLEGRO_CHANNEL_CONF-chan_conf -- ALLEGRO_AUDIO_STREAM )
function: al_destroy_audio_stream ( ALLEGRO_AUDIO_STREAM-*stream -- )
function: al_drain_audio_stream ( ALLEGRO_AUDIO_STREAM-*stream -- )

\ function: unsigned-int, al_get_audio_stream_frequency ( const-ALLEGRO_AUDIO_STREAM-*stream -- )
\ function: unsigned-int, al_get_audio_stream_length ( const-ALLEGRO_AUDIO_STREAM-*stream -- )
\ function: unsigned-int, al_get_audio_stream_fragments ( const-ALLEGRO_AUDIO_STREAM-*stream -- )
\ function: unsigned-int, al_get_available_audio_stream_fragments ( const-ALLEGRO_AUDIO_STREAM-*stream -- )

\ function: float, al_get_audio_stream_speed ( const-ALLEGRO_AUDIO_STREAM-*stream -- )
\ function: float, al_get_audio_stream_gain ( const-ALLEGRO_AUDIO_STREAM-*stream -- )
\ function: float, al_get_audio_stream_pan ( const-ALLEGRO_AUDIO_STREAM-*stream -- )

\ function: ALLEGRO_CHANNEL_CONF, al_get_audio_stream_channels ( const-ALLEGRO_AUDIO_STREAM-*stream -- )
\ function: ALLEGRO_AUDIO_DEPTH, al_get_audio_stream_depth ( const-ALLEGRO_AUDIO_STREAM-*stream -- )
\ function: ALLEGRO_PLAYMODE, al_get_audio_stream_playmode ( const-ALLEGRO_AUDIO_STREAM-*stream -- )

function: al_get_audio_stream_playing ( stream -- bool )
\ function: al_get_audio_stream_attached ( const-ALLEGRO_AUDIO_STREAM-*spl -- )

function: al_get_audio_stream_fragment ( const-ALLEGRO_AUDIO_STREAM-*stream -- addr )

function: al_set_audio_stream_speed ( ALLEGRO_AUDIO_STREAM-*stream, float-val -- bool )
function: al_set_audio_stream_gain ( ALLEGRO_AUDIO_STREAM-*stream, float-val -- bool )
function: al_set_audio_stream_pan ( ALLEGRO_AUDIO_STREAM-*stream, float-val -- bool )

function: al_set_audio_stream_playmode ( ALLEGRO_AUDIO_STREAM-*stream, ALLEGRO_PLAYMODE-val -- bool )
function: al_set_audio_stream_playing ( ALLEGRO_AUDIO_STREAM-*stream, bool-val -- bool )
\ function: al_detach_audio_stream ( ALLEGRO_AUDIO_STREAM-*stream -- bool )
function: al_set_audio_stream_fragment ( ALLEGRO_AUDIO_STREAM-*stream,-*val -- bool )

function: al_rewind_audio_stream ( ALLEGRO_AUDIO_STREAM-*stream -- bool )
function: al_seek_audio_stream_secs ( ALLEGRO_AUDIO_STREAM-*stream, double time -- bool )
function: al_get_audio_stream_position_secs ( ALLEGRO_AUDIO_STREAM-*stream -- n )
function: al_get_audio_stream_length_secs ( ALLEGRO_AUDIO_STREAM-*stream -- n )
function: al_set_audio_stream_loop_secs ( ALLEGRO_AUDIO_STREAM-*stream, double start, double end -- bool )
\ function: al_get_audio_stream_event_source ( ALLEGRO_AUDIO_STREAM-*stream -- ALLEGRO_EVENT_SOURCE-* )





\ sample instance

function: al_create_sample_instance ( sample -- instance )
function: al_destroy_sample_instance ( instance -- )
function: al_get_sample_instance_position ( sample -- n )
function: al_set_sample ( sample data -- bool )
function: al_get_sample_frequency ( sample -- n )

function: al_set_sample_instance_position ( ALLEGRO_SAMPLE_INSTANCE-*spl, unsigned-int-val -- bool )
function: al_set_sample_instance_length ( ALLEGRO_SAMPLE_INSTANCE-*spl, unsigned-int-val -- bool )
function: al_get_sample_instance_length ( ALLEGRO_SAMPLE_INSTANCE-*spl -- int )

function: al_set_sample_instance_speed ( ALLEGRO_SAMPLE_INSTANCE-*spl, float-val -- bool )
function: al_set_sample_instance_gain ( ALLEGRO_SAMPLE_INSTANCE-*spl, float-val -- bool )
function: al_set_sample_instance_pan ( ALLEGRO_SAMPLE_INSTANCE-*spl, float-val -- bool )
function: al_set_sample_instance_playmode ( ALLEGRO_SAMPLE_INSTANCE-*spl, ALLEGRO_PLAYMODE-val -- bool )
function: al_set_sample_instance_playing ( ALLEGRO_SAMPLE_INSTANCE-*spl, bool-val -- bool )
function: al_get_sample_instance_playing ( ALLEGRO_SAMPLE_INSTANCE-*spl,  -- bool )
function: al_play_sample_instance ( ALLEGRO_SAMPLE_INSTANCE-*spl -- bool )
function: al_stop_sample_instance ( ALLEGRO_SAMPLE_INSTANCE-*spl -- bool )
function: al_get_sample_instance_frequency ( const-ALLEGRO_SAMPLE_INSTANCE-*spl -- int )


\ mixer
function: al_get_default_mixer ( -- mixer )
function: al_set_default_mixer ( mixer -- bool )
function: al_restore_default_mixer ( -- )

function: al_create_mixer ( unsigned-int-freq, ALLEGRO_AUDIO_DEPTH-depth, ALLEGRO_CHANNEL_CONF-chan_conf -- ALLEGRO_MIXER* )
function: al_destroy_mixer ( ALLEGRO_MIXER-*mixer -- )
function: al_attach_sample_instance_to_mixer (  ALLEGRO_SAMPLE_INSTANCE-*stream, ALLEGRO_MIXER-*mixer -- bool )
function: al_attach_audio_stream_to_mixer ( ALLEGRO_AUDIO_STREAM-*stream, ALLEGRO_MIXER-*mixer -- bool )
function: al_attach_mixer_to_mixer ( ALLEGRO_MIXER-*stream, ALLEGRO_MIXER-*mixer -- bool )
function: al_set_mixer_postprocess_callback (  ALLEGRO_MIXER-*mixer, callback[buf,numsamps,userdata--] userdata -- bool ) 

function: al_get_mixer_frequency ( const-ALLEGRO_MIXER-*mixer -- n )
\ function: ALLEGRO_CHANNEL_CONF, al_get_mixer_channels ( const-ALLEGRO_MIXER-*mixer -- )
function: al_get_mixer_depth ( const-ALLEGRO_MIXER-*mixer -- depth )
\ function: ALLEGRO_MIXER_QUALITY, al_get_mixer_quality ( const-ALLEGRO_MIXER-*mixer -- )
\ function: float, al_get_mixer_gain ( const-ALLEGRO_MIXER-*mixer -- )
\ function: al_get_mixer_playing ( const-ALLEGRO_MIXER-*mixer -- )
\ function: al_get_mixer_attached ( const-ALLEGRO_MIXER-*mixer -- )
function: al_set_mixer_frequency ( ALLEGRO_MIXER-*mixer, unsigned-int-val -- bool )
function: al_set_mixer_quality ( ALLEGRO_MIXER-*mixer, ALLEGRO_MIXER_QUALITY-val -- bool )
function: al_set_mixer_gain ( ALLEGRO_MIXER-*mixer, float-gain -- bool )
function: al_set_mixer_playing ( ALLEGRO_MIXER-*mixer, bool-val -- bool )
function: al_detach_mixer ( ALLEGRO_MIXER-*mixer -- bool )

\ voice
function: al_create_voice ( unsigned-int-freq, ALLEGRO_AUDIO_DEPTH-depth, ALLEGRO_CHANNEL_CONF-chan_conf -- ALLEGRO_VOICE* )
function: al_destroy_voice ( ALLEGRO_VOICE-*voice -- )
function: al_attach_sample_instance_to_voice (  ALLEGRO_SAMPLE_INSTANCE-*stream, ALLEGRO_VOICE-*voice -- bool )
function: al_attach_audio_stream_to_voice (  ALLEGRO_AUDIO_STREAM-*stream, ALLEGRO_VOICE-*voice  -- bool )
function: al_attach_mixer_to_voice ( ALLEGRO_MIXER-*mixer, ALLEGRO_VOICE-*voice -- bool )
\ function: al_detach_voice ( ALLEGRO_VOICE-*voice -- )

function: al_set_voice_position ( ALLEGRO_VOICE-*voice, unsigned-int-val -- bool )
function: al_set_default_voice  ( voice -- bool )
function: al_get_default_voice  ( -- voice )
