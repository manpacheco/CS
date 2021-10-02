;org $8000
;ORG $5B00
ORG $6000

include "data.asm"

Main:
;dirección +-8329
ld a, 56 ; selecciona tinta 7 + paper 0*8
ld (23693),a
call 3503

ld a,6 ; 1 is the code for blue
out (254),a

ld hl, Carton_bold_font-256
ld ix, 23606
ld (ix), l
ld ix, 23607
ld (ix), h

MainLoop:
; call PrintSprite8x8At
; call ScanAllKeys


; include "Game.asm"
; include "Video.asm"
; include "Sprite.asm"
; include "Controls.asm"
; include "Display.asm"


LD    HL, Pantalla  ; source address (put "Cobra.scr.zx0" there)
;LD    DE, 16384  ; target address (screen memory in this case) $4000 in hex
LD    DE, UNZIPPED_SCREEN_ADDRESS
call dzx0_standard

;
; Print the string TEXT2 using my zero-terminated string print routine
;
CALL Pinta_pantalla_juego

Call Pinta_imagen_ciudad

end_loop:
jr end_loop
ret

Pantalla:
incbin "From_01_to_06.scr.zx0"
incbin "From_07_to_12.scr.zx0"
include "dzx0_standard.asm"
Carton_bold_font:
include "Carton_bold_font.asm"
include "screens.asm"
include "print.asm"


end Main