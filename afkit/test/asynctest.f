\ SwiftForth, Windows, X86
\ Test asynchronously loading a bitmap.
\ Takeaway:
\   You can't async update a texture to the GPU but things could be
\   mitigated by the possibility of loading a lot of game processing to a seperate thread and treating
\   the main thread as the "render thread"



include afkit/kit.f

: CALLBACK ( xt - res )  execute ;


LABEL RUNCB
   8 [ESP] ECX LEA                      \ ECX points to parameters
   0 [ESP] EDX MOV                      \ Return addr in CB: word's parameter field

   EBX PUSH                             \ Save registers
   ESI PUSH
   EDI PUSH
   EBP PUSH

   -16 [ESP] EBP LEA                    \ start stack in open space
   $1000 # ESP SUB                      \ move return stack below
   8 [ESP] ESI LEA                      \ user area above stack
   ECX 'WF [U] MOV                      \ set callback parameter pointer
   ESP R0 [U] MOV                       \ save stack pointers in user area
   EBP S0 [U] MOV

   |CB-USER| [ESI] EAX LEA              \ generate a new dictionary pointer
   EAX H [U] MOV                        \ and set into user area
   |CB-USER| $400 + [ESI] EAX LEA       \ top of dictionary =  here + 1k available
   EAX HLIM [U] MOV                     \ and top of dictionary

   $0A # BASE [U] MOV                   \ decimal
   0 # 'METHOD [U] MOV                  \ default method
   0 # STATE [U] MOV                    \ not compiling

   BEGIN 5 + DUP CALL   EDI POP         \ establish data space pointer in EDI
   ( *) -ORIGIN # EDI SUB

   0 # 0 [EBP] MOV                      \ nos=zero
   4 [EDX] EBX MOV                      \ get xt for tos
   ' CALLBACK >CODE CALL                \ and run the word...
   EBX EAX MOV                          \ return result

   S0 [U] ESP MOV                       \ restore
   16 # ESP ADD                         \ and negate the padding
   EBP POP                              \ restore registers
   EDI POP
   ESI POP
   EBX POP
   RET   END-CODE


: cb:  ( xt n - <name> )  \ define callback for external library
  create
  runcb ,call dup
  [+asm] cells # ret  nop [-asm]
  0= if [+asm]  nop nop  [-asm] then
  ( xt) ,
;

: allegro-cb:  0 cb: ;

variable bmp
    z" tests/bmp1.jpg" al_load_bitmap bmp !
variable mbmp

:noname
    begin
        mbmp @ 0= if
            ALLEGRO_MEMORY_BITMAP al_set_new_bitmap_flags
            z" tests/bmp2.jpg" al_load_bitmap mbmp !
        then
    again
; allegro-cb: test

0 value #frames
variable x  variable vx  1 vx !
variable y  variable vy  1 vy !
: test
    show>
        1 +to #frames
        #frames 100 = if  test here al_run_detached_thread  then
        mbmp @ if
            bmp @ al_destroy_bitmap
            mbmp @ al_clone_bitmap bmp !
            mbmp @ al_destroy_bitmap
            mbmp off
        then
        0e 0e 1.0e 1e 4sf al_clear_to_color
        bmp @ x @ y @ 2s>f 2sf 0 al_draw_bitmap

        vx @ x +!  vy @ y +!
        vx @ 0< if  x @ 0 < if  vx @ negate vx !  then then
        vy @ 0< if  y @ 0 < if  vy @ negate vy !  then then
        vx @ 0> if  x @ displayw bmp @ bmpw - >= if  vx @ negate vx !  then then
        vy @ 0> if  y @ displayh bmp @ bmph - >= if  vy @ negate vy !  then then
;

test
go
