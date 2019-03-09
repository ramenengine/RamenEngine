: platform  s" sflinux" ;

include afkit/ans/ffl/sflinux/ffl.f   \ FFL: DOM; FFL loads FPMATH
include afkit/dep/allegro5/allegro-5.2.x.f

library libX11.so

function: XOpenDisplay ( zdisplayname - display )
function: XDefaultScreen ( &display - display )

function: XSync ( display discard - )
function: XMapWindow ( display window - )
function: XRaiseWindow ( display  window - )

function: XSetInputFocus ( display window revert time - )
function: XGetInputFocus ( display &window &revert - )

include afkit/plat/sf.f
