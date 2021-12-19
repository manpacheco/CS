ORG $6000

include "data.asm"

Main:
LD A, 56 							; selecciona tinta 7 + paper 0*8
LD (23693),A						; establecer colores de pantalla
CALL 3503							; borrar la pantalla

LD A,6 								; carga el color del borde
OUT (254),A							; establecer el color del borde

LD HL, Carton_bold_font-256
LD IX, 23606
LD (IX), L
LD IX, 23607
LD (IX), H

CALL ROM_CLS            			; Clear screen and open Channel 2 (Screen)
CALL Pinta_pantalla_juego
CALL Pinta_imagen_ciudad
CALL Dibuja_Linea
CALL Inicia_caso
CALL Refresh_city

MainLoop:
LD A,5								; carga el color del borde
OUT (254),A
HALT

CALL ScanAllKeys					; lee las teclas
LD A,1								; 1 is the code for blue
OUT (254),A
HALT
JR MainLoop
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
include "Game.asm"
Carton_bold_font:
include "Carton_bold_font.asm"
include "screens.asm"
include "Buttons.asm"
include "Printer.asm"
include "print.asm"
Last_position:

end Main