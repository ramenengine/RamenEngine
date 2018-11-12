depend ramen/lib/pjoy.f

:noname
    show>  wipe
        cr ." Joy# 1 Sticks (0-3): "
            0 0 stick 2.  space  0 1 stick 2.  space  0 2 stick 2.  space  0 3 stick 2.
        cr ." Joy# 1 Buttons (0-15): "
            16 for  0 i btn i.  loop 
; execute