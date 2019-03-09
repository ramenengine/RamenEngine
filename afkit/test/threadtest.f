\ SwiftForth, Windows, X86
\ Test Allegro threads.

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
variable val
:noname  _PARAM_0 val !  ; allegro-cb: test
: go test here al_run_detached_thread ;
