decimal \ important

#define <A>  1
#define <B>  2
#define <C>  3
#define <D>  4
#define <E>  5
#define <F>  6
#define <G>  7
#define <H>  8
#define <I>  9
#define <J>  10
#define <K>  11
#define <L>  12
#define <M>  13
#define <N>  14
#define <O>  15
#define <P>  16
#define <Q>  17
#define <R>  18
#define <S>  19
#define <T>  20
#define <U>  21
#define <V>  22
#define <W>  23
#define <X>  24
#define <Y>  25
#define <Z>  26

#define <0>  27
#define <1>  28
#define <2>  29
#define <3>  30
#define <4>  31
#define <5>  32
#define <6>  33
#define <7>  34
#define <8>  35
#define <9>  36

#define <PAD_0>  37
#define <PAD_1>  38
#define <PAD_2>  39
#define <PAD_3>  40
#define <PAD_4>  41
#define <PAD_5>  42
#define <PAD_6>  43
#define <PAD_7>  44
#define <PAD_8>  45
#define <PAD_9>  46

#define <F1>  47
#define <F2>  48
#define <F3>  49
#define <F4>  50
#define <F5>  51
#define <F6>  52
#define <F7>  53
#define <F8>  54
#define <F9>  55
#define <F10>  56
#define <F11>  57
#define <F12>  58

#define <ESCAPE>  59
<escape> constant <esc>
#define <TILDE>  60
<tilde> constant <`>
<tilde> constant <~>
#define <MINUS>  61
<minus> constant <->
#define <EQUALS>  62
<equals> constant <=>
<equals> constant <+>
#define <BACKSPACE>  63
<backspace> constant <bksp>
#define <TAB>  64
#define <OPENBRACE>  65
<openbrace> constant <[>
#define <CLOSEBRACE>  66
<closebrace> constant <]>
#define <ENTER>  67
#define <SEMICOLON>  68
<semicolon> constant <;>
#define <QUOTE>  69
<quote> constant <'>
#define <BACKSLASH>  70
<backslash> constant <\>
#define <BACKSLASH2>  71 /* DirectInput calls this DIK_OEM_102: "< > | on UK/Germany keyboards" */
#define <COMMA>  72
<comma> constant <,>
#define <FULLSTOP>  73
<fullstop> constant <.>
#define <SLASH>  74
<slash> constant </>
#define <SPACE>  75

#define <INSERT>  76
<insert> constant <ins>
#define <DELETE>  77
<delete> constant <del>
#define <HOME>  78
#define <END>  79
#define <PGUP>  80
#define <PGDN>  81
#define <LEFT>  82
#define <RIGHT>  83
#define <UP>  84
#define <DOWN>  85

#define <PAD_SLASH>  86
#define <PAD_ASTERISK>  87
#define <PAD_MINUS>  88
#define <PAD_PLUS>  89
#define <PAD_DELETE>  90
#define <PAD_ENTER>  91

#define <PRINTSCREEN>  92
#define <PAUSE>  93

#define <ABNT_C1>  94
#define <YEN>  95
#define <KANA>  96
#define <CONVERT>  97
#define <NOCONVERT>  98
#define <AT>  99
#define <CIRCUMFLEX>  100
#define <COLON2>  101
#define <KANJI>  102

#define <PAD_EQUALS>  103  /* MacOS X */
#define <BACKQUOTE>  104  /* MacOS X */
#define <SEMICOLON2>  105  /* MacOS X -- TODO: ask lillo what this should be */
#define <COMMAND>  106  /* MacOS X */
#define <UNKNOWN>  107

\ /* All codes up to before #define <MODIFIERS can be freely
\  * assignedas additional unknown keys like cvarious multimedia
\  * and application keys keyboards may have.
\  */

#define <lshift>  215
#define <rshift>  216
#define <LCTRL>  217
#define <RCTRL>  218
#define <ALT>  219
#define <ALTGR>  220
#define <LWIN>  221
#define <RWIN>  222
#define <MENU>  223
#define <SCROLLLOCK>  224
#define <NUMLOCK>  225
#define <CAPSLOCK>  226


#define ALLEGRO_KEYMOD_SHIFT       $00001
#define ALLEGRO_KEYMOD_CTRL        $00002
#define ALLEGRO_KEYMOD_ALT         $00004
#define ALLEGRO_KEYMOD_LWIN        $00008
#define ALLEGRO_KEYMOD_RWIN        $00010
#define ALLEGRO_KEYMOD_MENU        $00020
#define ALLEGRO_KEYMOD_ALTGR       $00040
#define ALLEGRO_KEYMOD_COMMAND     $00080
#define ALLEGRO_KEYMOD_SCROLLLOCK  $00100
#define ALLEGRO_KEYMOD_NUMLOCK     $00200
#define ALLEGRO_KEYMOD_CAPSLOCK    $00400
#define ALLEGRO_KEYMOD_INALTSEQ	   $00800
#define ALLEGRO_KEYMOD_ACCENT1     $01000
#define ALLEGRO_KEYMOD_ACCENT2     $02000
#define ALLEGRO_KEYMOD_ACCENT3     $04000
#define ALLEGRO_KEYMOD_ACCENT4     $08000
