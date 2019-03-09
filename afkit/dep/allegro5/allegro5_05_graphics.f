decimal \ important

function: al_set_target_bitmap ( ALLEGRO_BITMAP-*bitmap -- )
function: al_get_target_bitmap ( -- ALLEGRO_BITMAP-*bitmap )
function: al_set_target_backbuffer ( ALLEGRO_DISPLAY-*display -- )

function: al_clear_to_color ( float-r float-g float-b float-a -- )
function: al_draw_pixel ( float-x float-y float-r float-g float-b float-a -- )
function: al_put_pixel ( int-x int-y float-r float-g float-b float-a -- )
function: al_put_blended_pixel ( int-x int-y float-r float-g float-b float-a -- )
function: al_get_pixel ( dest-color bitmap int-x int-y -- )


\ lock bitmap: allows pixel access
function: al_lock_bitmap ( ALLEGRO_BITMAP-*bitmap, int-format, int-flags -- ALLEGRO_LOCKED_REGION )
function: al_lock_bitmap_region ( ALLEGRO_BITMAP-*bitmap, int-x, int-y, int-width, int-height, int-format, int-flags -- ALLEGRO_LOCKED_REGION )
function: al_unlock_bitmap ( ALLEGRO_BITMAP-*bitmap -- )

0
  enum  ALLEGRO_LOCK_READWRITE
  enum  ALLEGRO_LOCK_READONLY
  enum  ALLEGRO_LOCK_WRITEONLY
drop

0
  cvar ALLEGRO_LOCKED_REGION.data
  cvar ALLEGRO_LOCKED_REGION.format
  cvar ALLEGRO_LOCKED_REGION.pitch
  cvar ALLEGRO_LOCKED_REGION.pixel_size
constant /ALLEGRO_LOCKED_REGION

\ shorthand
0
  cvar ALLEGRO_LOCK.data
  cvar ALLEGRO_LOCK.format
  cvar ALLEGRO_LOCK.pitch
  cvar ALLEGRO_LOCK.pixel_size
constant /ALLEGRO_LOCK



\ Deferred drawing
function: al_hold_bitmap_drawing ( bool-hold -- )
function: al_is_bitmap_drawing_held ( -- bool )

\ Transformations
function: al_use_transform ( const-ALLEGRO_TRANSFORM*-trans -- )
function: al_copy_transform ( ALLEGRO_TRANSFORM*-dest const-ALLEGRO_TRANSFORM*-src -- )
function: al_identity_transform ( ALLEGRO_TRANSFORM*-trans -- )
function: al_build_transform ( ALLEGRO_TRANSFORM*-trans float-x float-y float-sx float-sy float-theta -- )
function: al_translate_transform ( ALLEGRO_TRANSFORM*-trans float-x float-y -- )
function: al_rotate_transform ( ALLEGRO_TRANSFORM*-trans float-theta -- )
function: al_scale_transform ( ALLEGRO_TRANSFORM*-trans float-sx float-sy -- )
function: al_transform_coordinates ( const-ALLEGRO_TRANSFORM*-trans float*-x float*-y -- )
function: al_compose_transform ( ALLEGRO_TRANSFORM*-trans const-ALLEGRO_TRANSFORM*-other -- )
function: al_get_current_transform ( -- transform )
function: al_invert_transform ( ALLEGRO_TRANSFORM-*trans -- )
function: al_check_inverse ( const-ALLEGRO_TRANSFORM-*trans float-tol -- )
function: al_horizontal_shear_transform ( const-ALLEGRO_TRANSFORM-*trans float-x -- )
function: al_vertical_shear_transform ( const-ALLEGRO_TRANSFORM-*trans float-y -- )

\ since 5.1.3
\ function: al_translate_transform_3d ( ALLEGRO_TRANSFORM*-trans float-x float-y z -- )
\ function: al_rotate_transform_3d ( ALLEGRO_TRANSFORM*-trans x y z angle -- )
\ function: al_scale_transform_3d ( ALLEGRO_TRANSFORM*-trans float-sx float-sy z -- )


\ load/save bitmaps
function: al_load_bitmap ( const-char-*filename -- bitmap )
function: al_load_bitmap_f ( ALLEGRO_FILE-*fp const-char-*ident -- bitmap )
function: al_save_bitmap ( const-char-*filename ALLEGRO_BITMAP-*bitmap -- bool )
function: al_save_bitmap_f ( ALLEGRO_FILE-*fp const-char-*ident ALLEGRO_BITMAP-*bitmap -- bool )
function: al_set_new_bitmap_format ( format -- )
function: al_get_bitmap_format ( ALLEGRO_BITMAP-*bitmap -- int )
function: al_set_new_bitmap_flags ( flags -- )
function: al_get_new_bitmap_flags ( -- flags )

function: al_create_bitmap ( int-w int-h -- bitmap )
function: al_create_sub_bitmap ( bmp int-x int-y int-w int-h -- subbmp )
function: al_clone_bitmap ( bitmap -- bitmap )
function: al_destroy_bitmap ( ALLEGRO_BITMAP-*bitmap -- )
function: al_set_new_bitmap_depth ( n -- )

function: al_convert_mask_to_alpha ( ALLEGRO_BITMAP-*bitmap, float-r float-g float-b float-a -- )

5 1 0 [COMPATIBLE] function: al_convert_bitmap ( ALLEGRO_BITMAP -- )

\ bitmaps
0
enum   ALLEGRO_PIXEL_FORMAT_ANY
enum   ALLEGRO_PIXEL_FORMAT_ANY_NO_ALPHA
enum   ALLEGRO_PIXEL_FORMAT_ANY_WITH_ALPHA
enum   ALLEGRO_PIXEL_FORMAT_ANY_15_NO_ALPHA
enum   ALLEGRO_PIXEL_FORMAT_ANY_16_NO_ALPHA
enum   ALLEGRO_PIXEL_FORMAT_ANY_16_WITH_ALPHA
enum   ALLEGRO_PIXEL_FORMAT_ANY_24_NO_ALPHA
enum   ALLEGRO_PIXEL_FORMAT_ANY_32_NO_ALPHA
enum   ALLEGRO_PIXEL_FORMAT_ANY_32_WITH_ALPHA
enum   ALLEGRO_PIXEL_FORMAT_ARGB_8888
enum   ALLEGRO_PIXEL_FORMAT_RGBA_8888
enum   ALLEGRO_PIXEL_FORMAT_ARGB_4444
enum   ALLEGRO_PIXEL_FORMAT_RGB_888 /* 24 bit format */
enum   ALLEGRO_PIXEL_FORMAT_RGB_565
enum   ALLEGRO_PIXEL_FORMAT_RGB_555
enum   ALLEGRO_PIXEL_FORMAT_RGBA_5551
enum   ALLEGRO_PIXEL_FORMAT_ARGB_1555
enum   ALLEGRO_PIXEL_FORMAT_ABGR_8888
enum   ALLEGRO_PIXEL_FORMAT_XBGR_8888
enum   ALLEGRO_PIXEL_FORMAT_BGR_888 /* 24 bit format */
enum   ALLEGRO_PIXEL_FORMAT_BGR_565
enum   ALLEGRO_PIXEL_FORMAT_BGR_555
enum   ALLEGRO_PIXEL_FORMAT_RGBX_8888
enum   ALLEGRO_PIXEL_FORMAT_XRGB_8888
enum   ALLEGRO_PIXEL_FORMAT_ABGR_F32
enum   ALLEGRO_PIXEL_FORMAT_ABGR_8888_LE
enum   ALLEGRO_PIXEL_FORMAT_RGBA_4444
drop

#define ALLEGRO_FLIP_HORIZONTAL $00001
#define ALLEGRO_FLIP_VERTICAL  $00002

0
enum   ALLEGRO_ZERO
enum   ALLEGRO_ONE
enum   ALLEGRO_ALPHA
enum   ALLEGRO_INVERSE_ALPHA
enum   ALLEGRO_SRC_COLOR
enum   ALLEGRO_DEST_COLOR
enum   ALLEGRO_INVERSE_SRC_COLOR
enum   ALLEGRO_INVERSE_DEST_COLOR
enum   ALLEGRO_CONST_COLOR
enum   ALLEGRO_INVERSE_CONST_COLOR
enum   ALLEGRO_NUM_BLEND_MODES
drop

0
enum   ALLEGRO_ADD
enum   ALLEGRO_SRC_MINUS_DEST
enum   ALLEGRO_DEST_MINUS_SRC
drop

function: al_draw_bitmap ( ALLEGRO_BITMAP-*bitmap, float-dx, float-dy, int-flags -- )
function: al_draw_scaled_bitmap ( ALLEGRO_BITMAP-*bitmap, float-sx, float-sy, float-sw, float-sh, float-dx, float-dy, float-dw, float-dh, int-flags -- )
function: al_draw_rotated_bitmap ( ALLEGRO_BITMAP-*bitmap, float-cx, float-cy, float-dx, float-dy, float-angle, int-flags -- )
function: al_draw_scaled_rotated_bitmap ( ALLEGRO_BITMAP-*bitmap, float-cx, float-cy, float-dx, float-dy, float-sx, float-sy, float-angle, int-flags -- )
function: al_draw_bitmap_region ( ALLEGRO_BITMAP-*bitmap, float-sx, float-sy, float-sw, float-sh, float-dx, float-dy, int-flags -- )

function: al_draw_tinted_bitmap ( ALLEGRO_BITMAP-*bitmap, float-r float-g float-b float-a float-dx, float-dy, int-flags -- )
function: al_draw_tinted_scaled_bitmap ( ALLEGRO_BITMAP-*bitmap, float-r float-g float-b float-a float-sx, float-sy, float-sw, float-sh, float-dx, float-dy, float-dw, float-dh, int-flags -- )
function: al_draw_tinted_rotated_bitmap ( ALLEGRO_BITMAP-*bitmap, float-r float-g float-b float-a float-cx, float-cy, float-dx, float-dy, float-angle, int-flags -- )
function: al_draw_tinted_scaled_rotated_bitmap ( ALLEGRO_BITMAP-*bitmap, float-r float-g float-b float-a float-cx, float-cy, float-dx, float-dy, float-sx, float-sy, float-angle, int-flags -- )
function: al_draw_tinted_bitmap_region (  ALLEGRO_BITMAP-*bitmap float-r float-g float-b float-a float-sx float-sy float-sw float-sh float-dx, float-dy, int-flags -- )
function: al_draw_tinted_scaled_rotated_bitmap_region (  ALLEGRO_BITMAP-*bitmap float-sx float-sy float-sw float-sh float-r float-g float-b float-a float-cx float-cy float-dx float-dy float-xscale float-yscale float-angle int-flags -- )


function: al_set_clipping_rectangle ( int-x int-y int-width int-height -- )
function: al_get_clipping_rectangle ( a b c d -- )
function: al_reset_clipping_rectangle ( -- )
function: al_set_blender ( int-op int-source int-dest -- )
function: al_set_separate_blender ( int-op int-source int-dest int-alpha_op int-alpha_source int-alpha_dest -- )
function: al_get_blender ( int-op int-source int-dest -- )
function: al_get_separate_blender ( int-op int-source int-dest int-alpha_op int-alpha_source int-alpha_dest -- )
function: al_set_blend_color  ( float-r float-g float-b float-a -- )


\ addon: opengl
function: al_get_opengl_proc_address     ( const-char-*name -- addr )
function: al_get_opengl_extension_list    ( -- addr )
function:    al_get_opengl_texture        ( ALLEGRO_BITMAP-*bitmap -- gluint )
function: al_remove_opengl_fbo         ( ALLEGRO_BITMAP-*bitmap -- )
function:    al_get_opengl_fbo           ( ALLEGRO_BITMAP-*bitmap -- gluint )
function: al_set_current_opengl_context   ( ALLEGRO_DISPLAY-*display -- )

\ addon: image
linux-library liballegro_image
function:  al_init_image_addon ( -- bool )
function:  al_get_allegro_image_version ( -- ver )

\ addon: primitives
linux-library liballegro_primitives

0
enum ALLEGRO_PRIM_LINE_LIST
enum ALLEGRO_PRIM_LINE_STRIP
enum ALLEGRO_PRIM_LINE_LOOP
enum ALLEGRO_PRIM_TRIANGLE_LIST
enum ALLEGRO_PRIM_TRIANGLE_STRIP
enum ALLEGRO_PRIM_TRIANGLE_FAN
enum ALLEGRO_PRIM_POINT_LIST
drop

1
enum ALLEGRO_PRIM_POSITION
enum ALLEGRO_PRIM_COLOR_ATTR
enum ALLEGRO_PRIM_TEX_COORD
enum ALLEGRO_PRIM_TEX_COORD_PIXEL
drop

0
enum ALLEGRO_PRIM_FLOAT_2
enum ALLEGRO_PRIM_FLOAT_3
enum ALLEGRO_PRIM_SHORT_2
drop

0
  cvar ALLEGRO_VERTEX_ELEMENT.attribute
  cvar ALLEGRO_VERTEX_ELEMENT.storage
  cvar ALLEGRO_VERTEX_ELEMENT.offset
constant /ALLEGRO_VERTEX_ELEMENT

0
  cvar ALLEGRO_VERTEX.x
  cvar ALLEGRO_VERTEX.y
  cvar ALLEGRO_VERTEX.z
  cvar ALLEGRO_VERTEX.u
  cvar ALLEGRO_VERTEX.v
  cvar ALLEGRO_VERTEX.r
  cvar ALLEGRO_VERTEX.g
  cvar ALLEGRO_VERTEX.b
  cvar ALLEGRO_VERTEX.a
constant /ALLEGRO_VERTEX

function: al_init_primitives_addon ( -- bool )
function: al_draw_prim ( const-void*-vtxs const-ALLEGRO_VERTEX_DECL*-decl ALLEGRO_BITMAP*-texture int-start int-end int-type -- )
function: al_draw_indexed_prim ( const-void*-vtxs const-ALLEGRO_VERTEX_DECL*-decl ALLEGRO_BITMAP*-texture-const int*-indices int-num_vtx int-type -- )
function: al_create_vertex_decl ( const-ALLEGRO_VERTEX_ELEMENT*-elements int-stride -- addr )
function: al_draw_line ( float-x1 float-y1 float-x2 float-y2 float-r float-g float-b float-a float-thickness -- )
function: al_draw_triangle ( float-x1 float-y1 float-x2 float-y2 float-x3 float-y3 float-r float-g float-b float-a float-thickness -- )
function: al_draw_rectangle      ( float-x1 float-y1 float-x2 float-y2 float-r float-g float-b float-a float-thickness -- )
function: al_draw_filled_rectangle ( float-x1 float-y1 float-x2 float-y2 float-r float-g float-b float-a -- )
function: al_draw_rounded_rectangle ( float-x1 float-y1 float-x2 float-y2 float-rx float-ry float-r float-g float-b float-a float-thickness -- )
function: al_calculate_arc ( float*-dest int-stride float-cx float-cy float-rx float-ry float-start_theta float-delta_theta float-thickness int-num_segments -- )
function: al_draw_circle ( float-cx float-cy float-r float-r float-g float-b float-a float-thickness -- )
function: al_draw_ellipse ( float-cx float-cy float-rx float-ry float-r float-g float-b float-a float-thickness -- )
function: al_draw_arc ( float-cx float-cy float-r float-start_theta float-delta_theta float-r float-g float-b float-a float-thickness -- )
function: al_draw_elliptical_arc ( float-cx float-cy float-rx float-ry float-start_theta float-delta_theta float-r float-g float-b float-a float-thickness -- )
\ function: al_draw_pieslice ( float-cx float-cy float-r float-start_theta float-delta_theta float-r float-g float-b float-a float-thickness -- )
function: al_calculate_spline ( float*-dest int-stride float-points[8] float-thickness int-num_segments -- )
function: al_draw_spline ( float-points[8] float-r float-g float-b float-a float-thickness -- )
function: al_calculate_ribbon ( float*-dest int-dest_stride const-float-*points int-points_stride float-thickness int-num_segments -- )
function: al_draw_ribbon ( const-float-*points int-points_stride float-r float-g float-b float-a float-thickness int-num_segments -- )
function: al_draw_filled_triangle ( float-x1 float-y1 float-x2 float-y2 float-x3 float-y3 float-r float-g float-b float-a -- )
function: al_draw_filled_ellipse  ( float-cx float-cy float-rx float-ry float-r float-g float-b float-a -- )
function: al_draw_filled_circle ( float-cx float-cy float-r float-r float-g float-b float-a -- )
\ function: al_draw_filled_pieslice ( float-cx float-cy float-r float-start_theta float-delta_theta ALLEGRO_COLOR-color )
function: al_draw_filled_rounded_rectangle ( float-x1 float-y1 float-x2 float-y2 float-rx float-ry float-r float-g float-b float-a -- )

\ font addon

linux-library liballegro_ttf
function: al_init_ttf_addon ( -- bool )

linux-library liballegro_font
#define ALLEGRO_TTF_NO_KERNING  $1
#define ALLEGRO_TTF_MONOCHROME  $2
#define ALLEGRO_TTF_NO_AUTOHINT $4

function: al_init_font_addon ( -- bool )
function: al_shutdown_font_addon ( -- )
\ function: al_get_allegro_font_version ( -- int )
function: al_load_bitmap_font ( const-char-*filename -- font )
function: al_load_font ( const-char-*filename int-size int-flags -- font )
function: al_grab_font_from_bitmap ( ALLEGRO_BITMAP-*bmp int-n const-int-ranges[] -- font )
function: al_create_builtin_font ( -- font )

function: al_draw_ustr ( const-ALLEGRO_FONT-*font float-r float-g float-b float-a float-x float-y int-flags ALLEGRO_USTR-const-*ustr -- )
function: al_draw_text ( const-ALLEGRO_FONT-*font float-r float-g float-b float-a float-x float-y int-flags char-const-*text -- )
function: al_draw_justified_text ( const-ALLEGRO_FONT-*font float-r float-g float-b float-a float-x1 float-x2 float-y float-diff int-flags char-const-*text -- )
function: al_draw_justified_ustr ( const-ALLEGRO_FONT-*font float-r float-g float-b float-a float-x1 float-x2 float-y float-diff int-flags ALLEGRO_USTR-const-*text -- )

function: al_get_text_width ( const-ALLEGRO_FONT-*f const-char-*str -- int )
function: al_get_ustr_width ( const-ALLEGRO_FONT-*f const-ALLEGRO_USTR-*ustr -- int )
function: al_get_font_line_height ( const-ALLEGRO_FONT-*f -- int )
function: al_get_font_ascent ( const-ALLEGRO_FONT-*f -- int )
function: al_get_font_descent ( const-ALLEGRO_FONT-*f -- int )
function: al_destroy_font ( ALLEGRO_FONT-*f -- )
function: al_get_ustr_dimensions ( const-ALLEGRO_FONT-*f ALLEGRO_USTR const-*text int-*bbx int-*bby int-*bbw int-*bbh -- )
function: al_get_text_dimensions ( const-ALLEGRO_FONT-*f char-const-*text int-*bbx int-*bby int-*bbw int-*bbh -- )

\ RL: i'm going to use the struct words defined above instead of this:
\ fast but unsafe
\ : al_bitmap_size  4 cells + dup @ swap cell+ @ ;
\ safe but slow
function: al_get_bitmap_width  ( ALLEGRO_BITMAP-*bitmap -- n )
function: al_get_bitmap_height ( ALLEGRO_BITMAP-*bitmap -- n )

\ some opengl stuff ... todo
\ AL_FUNC(uint32_t,          al_get_opengl_version,        (void));
\ AL_FUNC(bool,            al_have_opengl_extension,      (const char *extension));
\ AL_FUNC(void*,            al_get_opengl_proc_address,     (const char *name));
\ AL_FUNC(ALLEGRO_OGL_EXT_LIST*, al_get_opengl_extension_list,    (void));
\ AL_FUNC(GLuint,           al_get_opengl_texture,        (ALLEGRO_BITMAP *bitmap));
\ AL_FUNC(void,            al_remove_opengl_fbo,         (ALLEGRO_BITMAP *bitmap));
\ AL_FUNC(GLuint,           al_get_opengl_fbo,           (ALLEGRO_BITMAP *bitmap));
\ AL_FUNC(void,            al_get_opengl_texture_size,     (ALLEGRO_BITMAP *bitmap,
\                                             int *w, int *h));
\ AL_FUNC(void,            al_get_opengl_texture_position,  (ALLEGRO_BITMAP *bitmap,
\                                             int *u, int *v));
\ AL_FUNC(void,            al_set_current_opengl_context,   (ALLEGRO_DISPLAY *display));
\ AL_FUNC(int,             al_get_opengl_cvariant,        (void));

function: al_map_rgba ( r g b a -- allegro-color )
function: al_unmap_rgba ( ALLEGRO_COLOR-color unsigned-char-*r, unsigned-char-*g, unsigned-char-*b, unsigned-char-*a -- )

#define  ALLEGRO_MEMORY_BITMAP            $0001  (                                 )
#define  _ALLEGRO_KEEP_BITMAP_FORMAT      $0002  (	/* now a bitmap loader flag */ )
#define  ALLEGRO_FORCE_LOCKING            $0004  (	/* no longer honoured */       )
#define  ALLEGRO_NO_PRESERVE_TEXTURE      $0008  (                                 )
#define  _ALLEGRO_ALPHA_TEST              $0010  (   /* now a render state flag */ )
#define  _ALLEGRO_INTERNAL_OPENGL         $0020  (                                 )
#define  ALLEGRO_MIN_LINEAR               $0040  (                                 )
#define  ALLEGRO_MAG_LINEAR               $0080  (                                 )
#define  ALLEGRO_MIPMAP                   $0100  (                                 )
#define  _ALLEGRO_NO_PREMULTIPLIED_ALPHA  $0200  (	/* now a bitmap loader flag */ )
#define  ALLEGRO_VIDEO_BITMAP             $0400  (                                 )
#define  ALLEGRO_CONVERT_BITMAP           $1000  (                                 )

0 constant ALLEGRO_ALIGN_LEFT
#1 constant ALLEGRO_ALIGN_CENTER
#2 constant ALLEGRO_ALIGN_RIGHT

linux-library liballegro_primitives

5 1 0 [compatible] function: al_draw_polygon  ( vertices count joinstyle r g b a thickness miterlimit -- )
5 1 0 [compatible] function: al_draw_filled_polygon  ( vertices count r g b a -- )

0
enum ALLEGRO_LINE_JOIN_NONE
enum ALLEGRO_LINE_JOIN_BEVEL
enum ALLEGRO_LINE_JOIN_ROUND
enum ALLEGRO_LINE_JOIN_MITER
drop

\ Shader stuff

0
enum ALLEGRO_SHADER_AUTO \ = 0,
enum ALLEGRO_SHADER_GLSL \ = 1,
enum ALLEGRO_SHADER_HLSL \ = 2
drop

\ /* Shader variable names */
#define ALLEGRO_SHADER_VAR_COLOR             z" al_color"
#define ALLEGRO_SHADER_VAR_POS               z" al_pos"
#define ALLEGRO_SHADER_VAR_PROJVIEW_MATRIX   z" al_projview_matrix"
#define ALLEGRO_SHADER_VAR_TEX               z" al_tex"
#define ALLEGRO_SHADER_VAR_TEXCOORD          z" al_texcoord"
#define ALLEGRO_SHADER_VAR_TEX_MATRIX        z" al_tex_matrix"
#define ALLEGRO_SHADER_VAR_USER_ATTR         z" al_user_attr_"
#define ALLEGRO_SHADER_VAR_USE_TEX           z" al_use_tex"
#define ALLEGRO_SHADER_VAR_USE_TEX_MATRIX    z" al_use_tex_matrix"

5 1 0 [compatible] function: al_create_shader ( ALLEGRO_SHADER_PLATFORM-platform -- shader )
5 1 0 [compatible] function: al_attach_shader_source   ( ALLEGRO_SHADER-*shader  ALLEGRO_SHADER_TYPE-type  const-char-*source -- bool )
5 1 0 [compatible] function: al_attach_shader_source_file   ( ALLEGRO_SHADER-*shader  ALLEGRO_SHADER_TYPE-type   const-char-*filename -- bool )
5 1 0 [compatible] function: al_build_shader   ( ALLEGRO_SHADER-*shader -- bool   )
5 1 0 [compatible] function: al_get_shader_log   ( ALLEGRO_SHADER-shader -- zstr )
5 1 0 [compatible] function: al_get_shader_platform   ( ALLEGRO_SHADER-shader -- ALLEGRO_SHADER_PLATFORM )
5 1 0 [compatible] function: al_use_shader   ( ALLEGRO_SHADER-shader -- bool   )
5 1 0 [compatible] function: al_destroy_shader   ( ALLEGRO_SHADER-shader -- )
5 1 0 [compatible] function: al_set_shader_sampler   ( const-char-name   ALLEGRO_BITMAP-bitmap  int-unit -- bool )
5 1 0 [compatible] function: al_set_shader_matrix   ( const-char-name  const-ALLEGRO_TRANSFORM-matrix -- bool  )
5 1 0 [compatible] function: al_set_shader_int   ( const-char-name   int-i -- bool )
5 1 0 [compatible] function: al_set_shader_float   ( const-char-name   float-f -- bool )
5 1 0 [compatible] function: al_set_shader_int_vector   ( const-char-name   int-num_components  const-int-i   int-num_elems -- bool )
5 1 0 [compatible] function: al_set_shader_float_vector   ( const-char-name   int-num_components     const-float-f   int-num_elems -- bool )
5 1 0 [compatible] function: al_set_shader_bool   ( const-char-name   bool-b -- bool )
5 1 0 [compatible] function: al_get_default_shader_source   ( ALLEGRO_SHADER_PLATFORM-platform  ALLEGRO_SHADER_TYPE-type -- zstr )

#1
enum ALLEGRO_VERTEX_SHADER
enum ALLEGRO_PIXEL_SHADER
drop

$10
enum ALLEGRO_ALPHA_TEST
enum ALLEGRO_WRITE_MASK
enum ALLEGRO_DEPTH_TEST
enum ALLEGRO_DEPTH_FUNCTION
enum ALLEGRO_ALPHA_FUNCTION
enum ALLEGRO_ALPHA_TEST_VALUE
drop

0
enum ALLEGRO_RENDER_NEVER
enum ALLEGRO_RENDER_ALWAYS
enum ALLEGRO_RENDER_LESS
enum ALLEGRO_RENDER_EQUAL
enum ALLEGRO_RENDER_LESS_EQUAL
enum ALLEGRO_RENDER_GREATER
enum ALLEGRO_RENDER_NOT_EQUAL
enum ALLEGRO_RENDER_GREATER_EQUAL
drop

5 1 2 [compatible] function: al_set_render_state ( state val -- )

5 2 3 [compatible] function: al_color_lch_to_rgb ( float-l, float-c, float-h, float-*red, float-*green, float-*blue -- )
5 2 3 [compatible] function: al_color_hsv_to_rgb ( float-h, float-s, float-v, float-*red, float-*green, float-*blue -- )
5 2 3 [compatible] function: al_color_hsl_to_rgb ( float-h, float-s, float-l, float-*red, float-*green, float-*blue -- )
5 2 3 [compatible] function: al_color_rgb_to_lch ( float-red, float-green, float-blue, float-*l, float-*c, float-*h -- )
5 2 3 [compatible] function: al_color_rgb_to_hsv ( float-red, float-green, float-blue, float-*h, float-*s, float-*v -- )
5 2 3 [compatible] function: al_color_rgb_to_hsl ( float-red, float-green, float-blue, float-*h, float-*s, float-*l -- )

function: al_scale_transform_3d ( ALLEGRO_TRANSFORM-*trans, float-sx, float-sy, float-sz -- )
function: al_translate_transform_3d ( ALLEGRO_TRANSFORM-*trans, float-x, float-y, float-z -- )
function: al_rotate_transform_3d ( ALLEGRO_TRANSFORM-*trans, float-x, float-y, float-z float-ang -- )
function: al_perspective_transform ( ALLEGRO_TRANSFORM-*trans, float-left, float-top, float-n, float-right, float-bottom, float-f -- )
function: al_use_projection_transform ( ALLEGRO_TRANSFORM-*trans, -- )
function: al_orthographic_transform ( ALLEGRO_TRANSFORM-*trans, float-left, float-top, float-n, float-right, float-bottom, float-f -- )
function: al_clear_depth_buffer ( float-z -- )
function: al_transform_coordinates_3d ( const-ALLEGRO_TRANSFORM*-trans float*-x float*-y float*-z -- )

#define ALLEGRO_STATE_NEW_DISPLAY_PARAMETERS $0001
#define ALLEGRO_STATE_NEW_BITMAP_PARAMETERS  $0002
#define ALLEGRO_STATE_DISPLAY                $0004
#define ALLEGRO_STATE_TARGET_BITMAP          $0008
#define ALLEGRO_STATE_BLENDER                $0010
#define ALLEGRO_STATE_NEW_FILE_INTERFACE     $0020
#define ALLEGRO_STATE_TRANSFORM              $0040
#define ALLEGRO_STATE_PROJECTION_TRANSFORM   $0100
#define ALLEGRO_STATE_ALL                    $ffff
ALLEGRO_STATE_TARGET_BITMAP ALLEGRO_STATE_NEW_BITMAP_PARAMETERS +  constant  ALLEGRO_STATE_BITMAP
function: al_store_state ( ALLEGRO_STATE flags -- )
function: al_restore_state ( ALLEGRO_STATE -- )

#1024 constant /ALLEGRO_STATE