org $8000

include "data.asm"

Main:
;dirección +-8329
ld a, 56 ; selecciona tinta 7 + paper 0*8
ld (23693),a
call 3503

ld a,6 ; 1 is the code for blue
out (254),a


MainLoop:
; call PrintSprite8x8At
; call ScanAllKeys


; include "Game.asm"
; include "Video.asm"
; include "Sprite.asm"
; include "Controls.asm"
; include "Display.asm"






LD    HL, Pantalla  ; source address (put "Cobra.scr.zx0" there)
LD    DE, 16384  ; target address (screen memory in this case)
call dzx0_standard
;
; Print the string TEXT2 using my zero-terminated string print routine
;
CALL Pinta_pantalla_juego
ret

Pantalla:
incbin "start.scr.zx0"
include "dzx0_standard.asm"

include "print.asm"

end Main