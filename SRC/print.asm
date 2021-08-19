;
; ROM routine addresses
;
ROM_CLS                 EQU  0x0DAF             ; Clears the screen and opens channel 2
ROM_OPEN_CHANNEL        EQU  0x1601             ; Open a channel
ROM_PRINT               EQU  0x203C             ; Print a string 
;
; PRINT control codes - work with ROM_PRINT and RST 0x10
;
INK                     EQU 0x10
PAPER                   EQU 0x11
FLASH                   EQU 0x12
BRIGHT                  EQU 0x13
INVERSE                 EQU 0x14
OVER                    EQU 0x15
AT                      EQU 0x16
TAB                     EQU 0x17
CR                      EQU 0x0C



CITY_STRING_MAX_LENGTH EQU 16
COUNTRY_STRING_MAX_LENGTH EQU 16

Esquina_superior_izq:	DB 144
Borde_superior:			DB 145
Esquina_superior_der:	DB 146
Borde_der:				DB 147
Borde_izq:				DB 148
Esquina_inferior_izq:	DB 149
Borde_inferior:			DB 150
Esquina_inferior_der:	DB 151
Menu:					DB AT, 1, 0, PAPER, 7, INK, 2, " G", INK, 0, "ame  ", INK, 2, "O", INK, 0, "ptions  ", INK, 2, "A", INK, 0, "cme  ", INK, 2, "D", INK, 0, "ossiers ",255
City_print_config:		DB AT, 4, 0, PAPER, 0, INK, 7, 255
;City_print_config:		DB AT, 4, 0, PAPER, 7, INK, 0, 255
;Prueba_UDG:				DB 144,145,145,145,145,146, 255

;
; My print routine
; DE: Address of the string
;
Print_255_Terminated:
LD A, (DE)					; Get the character
CP 255						; CP with 255
RET Z						; Ret if it is zero
RST 0x10					; Otherwise print the character
INC DE						; Inc to the next character in the string
JR Print_255_Terminated		; Loop

Print_city_text:
ld de, Cities											;carga en DE el puntero a ciudades
ld hl, CurrentCity
ld c, 0 ; PARA MEJORAR LA LEGIBILIDAD EN DEPURIACiÓN
ld b, (HL)										;carga en B EL ÍNDICE DE la ciudad actual
Print_city_text_loop:
ld a, (de)											;carga en A el caracter de la cadena apuntado por el puntero en DE
cp 255												;compara con 255
jp z, no_incrementar_contador_ciudades				;si es 255, salta para no incrementar B
inc b
no_incrementar_contador_ciudades:
inc de												;pasa al siguiente caracter
djnz Print_city_text_loop
call Print_255_Terminated
ret


Dibuja_Linea:
LD B, 32
;LD HL,16384
;LD HL,16928
LD HL,16992
Dibuja_Linea_loop:
LD (HL), 255
INC HL
DJNZ Dibuja_Linea_loop
RET

; 886C puntero temporal
Pinta_pantalla_juego:
CALL ROM_CLS            ; Clear screen and open Channel 2 (Screen)
LD DE, Menu
CALL Print_255_Terminated
Call Dibuja_Linea
LD DE, City_print_config
CALL Print_255_Terminated
CALL Print_city_text
;ld de, Prueba_UDG
;CALL Print_255_Terminated
ret

Pinta_recuadro:



org 65368
; UDG A
db 0, 0, 0, 31, 16, 16, 19, 19
; UDG B
db 0, 0, 0, 255, 0, 0, 255, 255
; UDG C
db 0, 0, 0, 240, 16, 28, 156, 156
; UDG D
db 19, 19, 19, 19, 19, 19, 19, 19
; UDG E
db 156, 156, 156, 156, 156, 156, 156, 156
; UDG F
db 19, 19, 19, 16, 16, 31, 7, 0
; UDG G
db 255, 255, 255, 0, 0, 255, 255, 0
; UDG H
db 156, 156, 156, 28, 28, 252, 252, 0

