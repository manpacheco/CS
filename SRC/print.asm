;
; ROM routine addresses
;
ROM_CLS                 	EQU  0x0DAF             ; Clears the screen and opens channel 2
ROM_OPEN_CHANNEL        	EQU  0x1601             ; Open a channel
ROM_PRINT               	EQU  0x203C             ; Print a string 
;
; PRINT control codes - work with ROM_PRINT and RST 0x10
;
INK                     	EQU 0x10
PAPER                   	EQU 0x11
FLASH                   	EQU 0x12
BRIGHT                  	EQU 0x13
INVERSE                 	EQU 0x14
OVER                    	EQU 0x15
AT                      	EQU 0x16
TAB                     	EQU 0x17
CR                      	EQU 0x0C
CITY_STRING_MAX_LENGTH 		EQU 16
COUNTRY_STRING_MAX_LENGTH 	EQU 16
ESQUINA_SUPERIOR_IZQ		EQU 144
BORDE_SUPERIOR				EQU 145
ESQUINA_SUPERIOR_DER		EQU 146
BORDE_IZQ					EQU 147
BORDE_DER					EQU 148
ESQUINA_INFERIOR_IZQ		EQU 149
BORDE_INFERIOR				EQU 150
ESQUINA_INFERIOR_DER		EQU 151
Menu:						DB AT, 1, 0, PAPER, 7, INK, 2, " G", INK, 0, "ame  ", INK, 2, "O", INK, 0, "ptions  ", INK, 2, "A", INK, 0, "cme  ", INK, 2, "D", INK, 0, "ossiers ",255
City_print_config:			DB AT, 5, 1, PAPER, 0, INK, 7, 255
Hour_print_config:			DB AT, 7, 1, 255

Window_x_inicial:			DB 0	; La posición X de la esquina superior izquierda
Window_y_inicial:			DB 3	; La posición Y de la esquina superior izquierda
Window_x_final_m_1:			DB 14	; La posición X de la esquina inferior derecha
Window_y_final_m_1:			DB 8	; La posición Y de la esquina inferior derecha
Caracter_relleno:			DB 143	; El caracter para rellenar el recuadro

;#####################################################################################################
;#####				Pinta_pantalla_juego
;#####				886C puntero temporal
;#####################################################################################################
Pinta_pantalla_juego:
CALL ROM_CLS            ; Clear screen and open Channel 2 (Screen)
LD DE, Menu
CALL Print_255_Terminated
;call Pinta_recuadro

ld hl, Window_y_inicial
ld (hl),10					; La posición Y de la esquina superior izquierda
ld hl, Window_y_final_m_1
ld (hl),21					; La posición Y de la esquina inferior derecha
call Pinta_recuadro

LD DE, City_print_config
call Print_255_Terminated
CALL Print_city_text

LD DE, Hour_print_config
call Print_255_Terminated
CALL Print_city_text

Call Dibuja_Linea

ret


;#####################################################################################################
;#####				Pinta_recuadro
;#####################################################################################################
Pinta_recuadro:

ld hl, Window_y_final_m_1
ld D, (hl)
ld hl, Window_x_final_m_1
ld E, (hl)
LD HL, Window_y_inicial
LD B, (HL)
LD HL, Window_x_inicial
LD C, (HL)


;;;; CORREGIR LAS REFERENCIAS A LOS REGISTROS B, C, D y E
sorry :(


LD A, PAPER
RST 0x10
LD A, 7
RST 0x10
LD A, INK
RST 0x10
LD A, 0
RST 0x10

;Pinta_recuadro_reconfig
LD A, AT
RST 0x10

ld a,c
RST 0x10

ld a,b
RST 0x10

;; PRIMERA FILA
LD A, ESQUINA_SUPERIOR_IZQ
RST 0x10
inc b

Pinta_recuadro_borde_superior:
LD A, BORDE_SUPERIOR
RST 0x10
inc b
ld a, b
cp d
jr nz, Pinta_recuadro_borde_superior

LD A, ESQUINA_SUPERIOR_DER
RST 0x10

;;; FILAS DE ENMEDIO
Pinta_recuadro_fila_enmedio:

INC c
LD HL, Window_x_inicial
LD b, (HL)

LD A, AT
RST 0x10

ld a,c
RST 0x10

ld a,b
RST 0x10



LD A, BORDE_IZQ
RST 0x10
inc c

Pinta_recuadro_relleno:
ld hl, Caracter_relleno
LD A, (hl)
RST 0x10
inc c
ld a, c
cp d
jr nz, Pinta_recuadro_relleno

LD A, BORDE_DER
RST 0x10

ld a, b
cp e
jr nz, Pinta_recuadro_fila_enmedio

ld a,13
RST 0x10


;; ÚLTIMA FILA

;LD A, 38
;RST 0x10
;LD A, AT
;RST 0x10
;LD A, 0
;RST 0x10
;LD A, 0
;RST 0x10
;LD A, 34
;RST 0x10

INC B
ld a, b
cp 22
jr c, Pinta_recuadro_no_cambiar_canal
LD A, 1
CALL ROM_OPEN_CHANNEL
LD b,0
LD A, ESQUINA_INFERIOR_IZQ
RST 0x10

Pinta_recuadro_no_cambiar_canal:
LD HL, Window_x_inicial
LD C, (HL)

LD A, AT
RST 0x10

ld a,b
RST 0x10

ld a,c
RST 0x10

LD A, ESQUINA_INFERIOR_IZQ
RST 0x10
inc c

Pinta_recuadro_borde_inferior:
LD A, BORDE_INFERIOR
RST 0x10
inc c
ld a, c
cp d ; línea 88f6
jr nz, Pinta_recuadro_borde_inferior

atras:
jr atras

LD A, ESQUINA_INFERIOR_DER
RST 0x10

LD A, 2
CALL ROM_OPEN_CHANNEL
ld c,0

RET

;#####################################################################################################
;#####				Dibuja_Linea
;#####################################################################################################
Dibuja_Linea:
LD B, 32
LD HL,16384+32*8+96
Dibuja_Linea_loop:
LD (HL), 255
INC HL
DJNZ Dibuja_Linea_loop
RET

;#####################################################################################################
;#####				Print_255_Terminated
;#####################################################################################################
Print_255_Terminated:
LD A, (DE)											; Get the character
CP 255												; CP with 255
RET Z												; Ret if it is zero
RST 0x10											; Otherwise print the character
INC DE												; Inc to the next character in the string
JR Print_255_Terminated								; Loop

;#####################################################################################################
;#####				Print_city_text
;#####################################################################################################
Print_city_text:
ld de, Cities										;carga en DE el puntero a ciudades
ld hl, CurrentCity
ld c, 0 											; PARA MEJORAR LA LEGIBILIDAD EN DEPURIACiÓN
ld b, (HL)											;carga en B EL ÍNDICE DE la ciudad actual
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

