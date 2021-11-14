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

CALL ROM_CLS            ; Clear screen and open Channel 2 (Screen)

CALL Pinta_pantalla_juego
CALL Pinta_imagen_ciudad
; CALL PintaCursor
; call Pinta_impresora
MainLoop:
ld a,5 ; 1 is the code for blue
out (254),a
HALT

CALL ScanAllKeys
ld a,1 ; 1 is the code for blue
out (254),a
HALT
jr MainLoop
RET

Pantalla:
incbin "From_01_to_06.scr.zx0"
Pantalla0712:
incbin "From_07_to_12.scr.zx0"
Pantalla1318:
incbin "From_13_to_18.scr.zx0"
Pantalla1924:
incbin "From_19_to_24.scr.zx0"
Pantalla2530:
incbin "From_25_to_30.scr.zx0"
PantallaWorld:
incbin "world.scr.zx0"
include "dzx0_standard.asm"
include "Controls.asm"
include "Sound.asm"
Carton_bold_font:
include "Carton_bold_font.asm"
include "screens.asm"
include "print.asm"
Last_position:

end Main