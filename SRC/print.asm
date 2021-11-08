;
; ROM routine addresses
;
ROM_CLS                 	EQU  0x0DAF             ; Clears the screen and opens channel 2
ROM_OPEN_CHANNEL        	EQU  0x1601             ; Open a channel
ROM_PRINT               	EQU  0x203C             ; Print a string 

ROM_PRINT_CURRENT_COLUMN	EQU 23688				; valor para hacer line wrap
ROM_PRINT_CURRENT_LINE		EQU 23689				; valor para hacer retorno de carro
;
; PRINT control codes - work with ROM_PRINT and RST 0x10
;
RETORNO_DE_CARRO			EQU 13
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
RIO_JAN						EQU 26
TAM_WEEKDAYS				EQU 4
Menu:						DB AT, 1, 0, PAPER, 7, INK, 2, " G", INK, 0, "ame  ", INK, 2, "O", INK, 0, "ptions  ", INK, 2, "A", INK, 0, "cme  ", INK, 2, "D", INK, 0, "ossiers ",255
City_print_config:			DB AT, 4, 1, PAPER, 0, INK, 7, 255
City_print_config2:			DB AT, 5, 1, PAPER, 0, INK, 7, 255
Hour_print_config:			DB AT, 7, 1, 255
Button_depart_1_3:			DB AT, 20, 18, 152, 153, 154, 255
Button_depart_2_3:			DB AT, 21, 19, 155, 255
Button_depart_3_3:			DB AT, 0, 18, 156, 157, 158, 255
Button_lupa_1_3:			DB AT, 20, 24, 159, 160, 255
Button_lupa_2_3:			DB AT, 21, 23, 161, 162, 123, 255
Button_lupa_3_3:			DB AT, 0, 23, 124, 125, 126, 255
Button_crime_1_3:			DB AT, 20, 28, 35, 36, 37, 255
Button_crime_2_3:			DB AT, 21, 28, 38, 60, 61, 255
Button_crime_3_3:			DB AT, 0, 28, 62, 63, 96, 255


Window_x_inicial:			DB 0	; La posición X de la esquina superior izquierda
Window_y_inicial:			DB 3	; La posición Y de la esquina superior izquierda
Window_x_final_m_1:			DB 11	; La posición X de la esquina inferior derecha
Window_y_final_m_1:			DB 8	; La posición Y de la esquina inferior derecha
Caracter_relleno:			DB 143	; El caracter para rellenar el recuadro

;#####################################################################################################
;#####				Pinta_pantalla_juego
;#####################################################################################################
Pinta_pantalla_juego:

LD DE, Menu							; Carga en el registro DE la dirección de la cadena del menú superior
CALL Print_255_Terminated			; Pinta el menú superior
CALL Pinta_todos_recuadros			; Pinta los tres recuadros
CALL Pinta_boton_Elegir_destino		; Pinta el botón con el avión
CALL Pinta_boton_Lupa				; Pinta el boton de la lupa para las pistas
CALL Pinta_boton_Ordenador			; Pinta el boton del ordenador para la orden de arresto
LD DE, City_print_config
CALL Print_255_Terminated
CALL Print_city_text
CALL Print_city_desc
CALL Print_weekday_and_hour
CALL Dibuja_Linea
RET


;#####################################################################################################
;#####				Pinta_recuadro
;#####################################################################################################
Pinta_recuadro:

LD HL, Window_y_inicial
LD B, (HL)
LD HL, Window_x_inicial
LD C, (HL)
ld hl, Window_y_final_m_1
ld D, (hl)
ld hl, Window_x_final_m_1
ld E, (hl)


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

LD A,B
RST 0x10

LD A,C
RST 0x10

;; PRIMERA FILA
LD A, ESQUINA_SUPERIOR_IZQ
RST 0x10
INC C

Pinta_recuadro_borde_superior:
LD A, BORDE_SUPERIOR
RST 0x10
INC C
LD A, C
CP E
JR NZ, Pinta_recuadro_borde_superior

LD A, ESQUINA_SUPERIOR_DER
RST 0x10

;;; FILAS DE ENMEDIO
Pinta_recuadro_fila_enmedio:

INC B
LD HL, Window_x_inicial
LD C, (HL)

LD A, AT
RST 0x10

LD A,B
RST 0x10

LD A,C
RST 0x10

LD A, BORDE_IZQ
RST 0x10
INC C

Pinta_recuadro_relleno:
LD HL, Caracter_relleno
LD A, (HL)
RST 0x10
INC C
LD A, C
CP E
JR NZ, Pinta_recuadro_relleno

LD A, BORDE_DER
RST 0x10

LD A, B
CP D
JR NZ, Pinta_recuadro_fila_enmedio

;; ÚLTIMA FILA

LD HL, Window_x_inicial
LD C, (HL)

INC B
LD A, B
CP 22
JR C, Pinta_recuadro_no_cambiar_canal

LD A, 1
PUSH BC
PUSH DE
CALL ROM_OPEN_CHANNEL
POP DE
POP BC
LD B,0
;LD C,0
LD HL, Window_y_final_m_1
LD A, (HL)
SUB 21
LD (HL),A

; fila extra en CANAL 1
LD A, AT
RST 0x10

LD A,0
RST 0x10

LD A,C
RST 0x10

LD A, BORDE_IZQ
RST 0x10
INC C

Pinta_recuadro_relleno_extra:
LD HL, Caracter_relleno
LD A, (HL)
RST 0x10
INC C
LD A, C
CP E
JR NZ, Pinta_recuadro_relleno_extra

LD A, BORDE_DER
RST 0x10
inc B

LD HL, Window_x_inicial
LD C, (HL)

jr Pinta_recuadro_imprimir_fila_inferior

Pinta_recuadro_no_cambiar_canal:
LD HL, Window_x_inicial
LD C, (HL)


Pinta_recuadro_imprimir_fila_inferior:

LD A, AT
RST 0x10

LD A,B
RST 0x10

LD A,C
RST 0x10


LD A, ESQUINA_INFERIOR_IZQ
RST 0x10
INC C

Pinta_recuadro_borde_inferior:
LD A, BORDE_INFERIOR
RST 0x10
INC C
LD A, C
CP E ; línea 88f6
JR NZ, Pinta_recuadro_borde_inferior

LD A, ESQUINA_INFERIOR_DER
RST 0x10

LD A, 2
CALL ROM_OPEN_CHANNEL

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
;#####		parámetro: en el registro DE viene la dirección de la cadena que se va a escribir 
;#####################################################################################################
Print_255_Terminated:
LD A, (DE)											; Get the character
CP 255												; CP with 255
RET Z												; Ret if it is zero
PUSH DE
RST 0x10											; Otherwise print the character
POP DE
INC DE												; Inc to the next character in the string
JR Print_255_Terminated								; Loop

;#####################################################################################################
;#####				Print_255_Terminated_with_line_wrap
;#####		parámetro: en el registro DE viene la dirección de la cadena que se va a escribir 
;#####		parámetro: en el registro B el limite izquierdo
;#####		parámetro: en el registro C el limite derecho
;#####################################################################################################
Print_255_Terminated_with_line_wrap:
LD A, (DE)											; Get the character
CP 255												; CP with 255
RET Z												; Ret if it is zero

CP RETORNO_DE_CARRO
JR Z, Retorno_carro

PUSH BC												; preserva BC
PUSH DE
PUSH HL
RST 0x10											; Otherwise print the character
POP HL
POP DE
POP BC												; restaura BC

LD HL, ROM_PRINT_CURRENT_COLUMN						; apunta al indice horizontal de print
LD A, (HL)											; carga en A
CP C												; compara con el limite derecho
;JR C, Retorno_carro									; si es menor (la coordenada va en sentido decreciente) salta a retorno de carro
;JR Continua_Print_255_Terminated_with_line_wrap		; si no, salta a continuar
JR NC, Continua_Print_255_Terminated_with_line_wrap		; si es menor o igual, salta a continuar							
JR Retorno_carro										; si es menor (la coordenada va en sentido decreciente) salta a retorno de carro

Retorno_carro:
PUSH BC												; preserva BC
LD A, AT											; carga el código AT
RST 0x10											; lo imprime

LD HL, ROM_PRINT_CURRENT_LINE						; carga el puntero a la linea actual de print
LD B, (HL)											; carga el valor en B
LD A, 24											; carga 24 en A para calcular la línea
SUB B												; A <- ( 24-B )
INC A												; incrementa A - baja una línea
RST 0x10											; imprime y posiciona el cursor

POP BC												; restaura BC
LD A, B												; carga en A el valor de la columna
RST 0x10											; imprime

Continua_Print_255_Terminated_with_line_wrap:
INC DE												; Inc to the next character in the string
JR Print_255_Terminated_with_line_wrap				; Loop


;#####################################################################################################
;#####				Pinta_boton_Elegir_destino
;#####################################################################################################
Pinta_boton_Elegir_destino:
LD HL, Caracter_relleno
LD (HL),32

LD HL, Window_y_inicial
LD (HL),19					
LD HL, Window_y_final_m_1
LD (HL),21
LD HL, Window_x_inicial
LD (HL),17					
LD HL, Window_x_final_m_1
LD (HL),21
CALL Pinta_recuadro

LD DE, Button_depart_1_3
CALL Print_255_Terminated

LD DE, Button_depart_2_3
CALL Print_255_Terminated

LD A, 1
PUSH BC
PUSH DE
CALL ROM_OPEN_CHANNEL
POP DE
POP BC

LD DE, Button_depart_3_3
CALL Print_255_Terminated

LD A, 2
CALL ROM_OPEN_CHANNEL
RET

;#####################################################################################################
;#####				Pinta_boton_Lupa
;#####################################################################################################
Pinta_boton_Lupa:
ld hl, Window_y_final_m_1
ld (hl),21
ld hl, Window_x_inicial
ld (hl),22					
ld hl, Window_x_final_m_1
ld (hl),26					
call Pinta_recuadro

LD DE, Button_lupa_1_3
CALL Print_255_Terminated

LD DE, Button_lupa_2_3
CALL Print_255_Terminated

LD A, 1
PUSH BC
PUSH DE
CALL ROM_OPEN_CHANNEL
POP DE
POP BC

LD DE, Button_lupa_3_3
CALL Print_255_Terminated

LD A, 2
CALL ROM_OPEN_CHANNEL
RET

;#####################################################################################################
;#####				Pinta_boton_Ordenador
;#####################################################################################################
Pinta_boton_Ordenador:
LD HL, Window_y_final_m_1
LD (HL),21
LD HL, Window_x_inicial
LD (HL),27					
LD HL, Window_x_final_m_1
LD (HL),31					
CALL Pinta_recuadro

LD DE, Button_crime_1_3
CALL Print_255_Terminated

LD DE, Button_crime_2_3
CALL Print_255_Terminated

LD A, 1
PUSH BC
PUSH DE
CALL ROM_OPEN_CHANNEL
POP DE
POP BC

LD DE, Button_crime_3_3
CALL Print_255_Terminated

LD A, 2
CALL ROM_OPEN_CHANNEL
RET


;#####################################################################################################
;#####				Print_weekday_and_hour
;#####################################################################################################
Print_weekday_and_hour:

LD DE, Hour_print_config
call Print_255_Terminated
LD A,32
RST 0x10
LD DE, Weekdays
LD HL, CurrentWeekday
LD A, (HL)
print_weekday_loop:
DEC A
OR A
JR Z, print_weekday_end
LD B,0
LD C,TAM_WEEKDAYS ; TAMAÑO DE LOS DÍAS DE LA SEMANA
EX  DE,HL
ADD HL, BC
EX  DE,HL
jr print_weekday_loop
print_weekday_end:
CALL Print_255_Terminated

LD A,32
RST 0x10
LD DE, CurrentHour
CALL Print_255_Terminated
RET


;#####################################################################################################
;#####				Pinta_todos_recuadros
;#####				Para el primero, asume toda la configuración por defecto
;#####################################################################################################
Pinta_todos_recuadros:

CALL Pinta_recuadro					; Pinta el primer recuadro para la ciudad, el día y la hora con todos los valores por defecto (0,3)->(10,7)

LD HL, Window_y_inicial				; Carga en HL el puntero a la variable Y inicial de la ventana
LD (HL),10							; La posición Y de la esquina superior izquierda
LD HL, Window_y_final_m_1			; Carga en HL el puntero a la variable Y final más uno de la ventana
LD (HL),21							; La posición Y de la esquina inferior derecha
call Pinta_recuadro					; Pinta el segundo recuadro para la imagen de la ciudad

;;;; Panel derecho
ld hl, Window_y_inicial				; Carga en HL el puntero a la variable Y inicial de la ventana
ld (hl),3					        ; Carga en la variable el valor
ld hl, Window_y_final_m_1           ; Carga en HL el puntero a la variable Y final más uno de la ventana
ld (hl),17                          ; Carga en la variable el valor
ld hl, Window_x_inicial             ; Carga en HL el puntero a la variable Y inicial de la ventana
ld (hl),12							; Carga en la variable el valor
ld hl, Window_x_final_m_1			; Carga en HL el puntero a la variable Y final más uno de la ventana
ld (hl),31							; Carga en la variable el valor
call Pinta_recuadro					; Pinta el tercer recuadro para la descripción de la ciudad

ret

;#####################################################################################################
;#####				Print_city_text
;#####################################################################################################
Print_city_text:

LD HL, CurrentCity
LD C, 0 											; PARA MEJORAR LA LEGIBILIDAD EN DEPURACiÓN
LD B, (HL)											; carga en B EL ÍNDICE DE la ciudad actual
INC B												; suma 1 al índice de ciudad
LD DE, Cities										; carga en DE el puntero a ciudades
CALL Select_elemento
CALL Print_255_Terminated
RET

;#####################################################################################################
;#####				Select_elemento
;#####		parámetro: en el registro BC viene el índice del elemento que se va a seleccionar
;#####		parámetro: en el registro DE viene la dirección de la cadena que se va a escribir 
;#####		salida: en el registro DE sale la dirección de la cadena con el elemento seleccionado
;#####################################################################################################
Select_elemento:
LD A, (DE)											; carga en A el caracter de la cadena apuntado por el puntero en DE
CP 255												; compara con 255
JP Z, no_incrementar_contador						; si es 255, salta para no incrementar B
INC B												; incrementa el contador en el registro B
no_incrementar_contador:
INC DE												; pasa al siguiente caracter
DJNZ Select_elemento
RET

;#####################################################################################################
;#####				Print_city_desc
;#####################################################################################################
Print_city_desc:
LD A, AT                							; AT control character
RST 0x10
LD A, 4                 							; Y
RST 0x10
LD A, 13                							; X
RST 0x10

LD HL, CurrentCity
LD DE, City_descriptions
LD B, (HL)
LD C, 0
call Select_elemento
;CALL Print_255_Terminated
LD B, 13
LD C, 3
CALL Print_255_Terminated_with_line_wrap
RET

Restablecer_valores_por_defecto_recuadros:
LD HL, Window_x_inicial
LD (HL), 0
LD HL, Window_y_inicial
LD (HL), 3
LD HL, Window_x_final_m_1
LD (HL), 11
LD HL, Window_y_final_m_1
LD (HL), 8
LD HL, Caracter_relleno
LD (HL), 143
RET

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
; UDG I ; DEPART 1/7
db 0, 102, 84, 86, 84, 102, 0, 0
; UDG J ; DEPART 2/7
db 0, 238, 170, 238, 138, 138, 0, 0
; UDG K ; DEPART 3/7
db 0, 206, 164, 196, 164, 164, 0, 0
; UDG L ; DEPART 4/7
db 0, 0, 0, 0, 24, 24, 126, 24
; UDG M ; DEPART 5/7
db 0, 127, 6, 0, 0, 0, 0, 0
; UDG N ; DEPART 6/7
db 60, 255, 126, 126, 60, 0, 0, 0
; UDG O ; DEPART 7/7
db 0, 254, 96, 0, 0, 0, 0, 0
; UDG P ; LUPA 1/8
db 0, 0, 3, 12, 16, 35, 36, 64
; UDG Q ; LUPA 2/8
db 1, 1, 129, 97, 17, 137, 73, 133
; UDG R ; LUPA 3/8
db 0, 0, 0, 0, 1, 15, 63, 124
; UDG S ; LUPA 4/8
db 65, 32, 33, 112, 252, 227, 0, 8