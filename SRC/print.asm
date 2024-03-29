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
ESPACIO_BAJA_RES			EQU 128
INK                     	EQU 0x10
PAPER                   	EQU 0x11
FLASH                   	EQU 0x12
BRIGHT                  	EQU 0x13
INVERSE                 	EQU 0x14
OVER                    	EQU 0x15
AT                      	EQU 0x16
TAB                     	EQU 0x17
CR                      	EQU 0x0C
CARACTER_TODO_RELLENO		EQU 143
WHITE						EQU 7
YELLOW						EQU 6
BLACK						EQU 0
PAPER_HOLE_CHARACTER		EQU 59
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
PRINTER_BASE_X				EQU 15
PRINTER_BASE_Y				EQU 15
TAM_WEEKDAYS				EQU 4
CARACTER_ASCII_0			EQU 48
CARACTER_ASCII_1			EQU 49
CARACTER_ASCII_2			EQU 50
CARACTER_ASCII_3			EQU 51
CARACTER_ASCII_4			EQU 52
CARACTER_ASCII_5			EQU 53
CARACTER_ASCII_6			EQU 54
CARACTER_ASCII_7			EQU 55
CARACTER_ASCII_8			EQU 56
CARACTER_ASCII_9			EQU 57
CARACTER_ASCII_9_M_1		EQU 58

Menu:						DB AT, 1, 0, PAPER, 7, INK, 2, " G", INK, 0, "ame  ", INK, 2, "O", INK, 0, "ptions  ", INK, 2, "A", INK, 0, "cme  ", INK, 2, "D", INK, 0, "ossiers ",255
City_origin:				DB AT, 4, 2, 255
City_destination1:			DB AT, 3, 15, 255
City_destination2:			DB AT, 4, 15, 255
City_destination3:			DB AT, 5, 15, 255
City_destination4:			DB AT, 6, 15, 255
City_print_config:			DB AT, 4, 1, PAPER, 0, INK, 7, 255
City_print_config2:			DB AT, 5, 1, PAPER, 0, INK, 7, 255


Hour_print_config:			DB AT, 7, 1, 255
Buttons_y_inicial			EQU 19
Buttons_y_final				EQU 21
Button_depart_x_inicial		EQU 13
Button_depart_x_final		EQU Button_depart_x_inicial+4
Button_depart_1_3:			DB AT, 20, Button_depart_x_inicial+1, 152, 153, 154, 255
Button_depart_2_3:			DB AT, 21, Button_depart_x_inicial+2, 155, 255
Button_depart_3_3:			DB AT, 0, Button_depart_x_inicial+1, 156, 157, 158, 255
Button_lupa_x_inicial		EQU 19
Button_lupa_x_final			EQU Button_lupa_x_inicial+4
Button_lupa_1_3:			DB AT, 20, Button_lupa_x_inicial+2, 159, 160, 255
Button_lupa_2_3:			DB AT, 21, Button_lupa_x_inicial+1, 161, 162, 123, 255
Button_lupa_3_3:			DB AT, 0, Button_lupa_x_inicial+1, 124, 125, 126, 255
Button_crime_x_inicial		EQU 25
Button_crime_x_final		EQU Button_crime_x_inicial+4
Button_crime_1_3:			DB AT, 20, Button_crime_x_inicial+1, 35, 36, 37, 255
Button_crime_2_3:			DB AT, 21, Button_crime_x_inicial+1, 38, 60, 61, 255
Button_crime_3_3:			DB AT, 0, Button_crime_x_inicial+1, 62, 63, 96, 255
Cursor_string:				DB BRIGHT,1,OVER,1,143,143,143

Window_x_inicial:			DB 0	; La posición X de la esquina superior izquierda
Window_y_inicial:			DB 3	; La posición Y de la esquina superior izquierda
Window_x_final_m_1:			DB 11	; La posición X de la esquina inferior derecha
Window_y_final_m_1:			DB 8	; La posición Y de la esquina inferior derecha
Caracter_relleno:			DB 143	; El caracter para rellenar el recuadro



;#####################################################################################################
;#####				Borrar_panel_derecho
;#####################################################################################################
Borrar_panel_derecho:
ld hl, Caracter_relleno								; Carga en HL la dirección del caracter de relleno
ld (hl), CARACTER_TODO_RELLENO						; Carga en la dirección del caracter de relleno el caracter todo relleno
call Print_panel_derecho							; Imprime el panel derecho, usando el caracter de relleno definido previamente
ret

;#####################################################################################################
;#####				PintaCursor
;#####################################################################################################
PintaCursor:
LD HL, Cursor										; Carga en HL la dirección del cursor
LD A, (HL)											; Carga en A el valor del cursor
OR A												; Operación para afectar los flags
RET Z												; Si el cursor era 0, ya se termina
LD C, A												; Copia el cursor en C
DEC C												; Resta uno al cursor
LD B, 0												; Carga 0 en B como parte alta de BC
LD HL, Cursor_botones								; Carga en HL la dirección base de los botones de los distintos valores de la variable cursor
ADD HL, BC											; Suma HL y BC para conseguir en HL la dirección del botón actualmente indicado por la variable cursor

LD C, (HL)											; Prepara en C el elemento apuntado por HL
INC C												; Suma 1
LD A, Buttons_y_inicial+1							; Prepara en A la posicion vertical y también le suma 1 (se les suma 1 porque los bordes no tiene que iluminarse)


;; A: Y characters shift down (en destino)
;; C: X Characters shift left (en destino)

call obtener_direccion_zona_atributos
ld b, 3
PintaCursor_loop:
push hl
ld a, 64
or (hl)
ld (hl),a
inc hl
ld a, 64
or (hl)
ld (hl),a
inc hl
ld a, 64
or (hl)
ld (hl),a
pop hl
ld e, 32
ld d,0
add hl, de
djnz PintaCursor_loop
RET

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
LD A, WHITE
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
;#####				Print_linea_blanco
;#####################################################################################################
Print_linea_blanco:
PUSH BC
PUSH AF
PUSH DE
LD A, AT
RST 0x10												; Otherwise print the character

LD A, 2
RST 0x10												; Otherwise print the character

LD A, 0
RST 0x10												; Otherwise print the character

LD B, 32												; Get the character
Bucle_Print_linea_blanco:
LD A, 32	
RST 0x10												; Otherwise print the character
DJNZ Bucle_Print_linea_blanco
POP DE
POP AF
POP BC
RET


;#####################################################################################################
;#####				Print_255_Terminated
;#####		parámetro: en el registro DE viene la dirección de la cadena que se va a escribir 
;#####		usa: AF, DE *[se hace llamada a ROM]
;#####################################################################################################
Print_255_Terminated:
LD A, (DE)												; Get the character
CP 255													; CP with 255
RET Z													; Ret if it is zero
PUSH DE	
RST 0x10												; Otherwise print the character
POP DE	
INC DE													; Inc to the next character in the string
JR Print_255_Terminated									; Loop

;#####################################################################################################
;#####				Print_flat_255_Terminated
;#####		parámetro: en el registro DE viene la dirección de la cadena que se va a escribir 
;#####################################################################################################
Print_flat_255_Terminated:
LD A, (DE)												; Get the character
CP 255													; CP with 255
RET Z													; Ret if it is zero
CP ESPACIO_BAJA_RES
JR Z, Print_flat_255_Terminated_continuar
CP RETORNO_DE_CARRO
JR NZ, Print_flat_255_Terminated_continuar_inner
LD A, ESPACIO_BAJA_RES
Print_flat_255_Terminated_continuar_inner
PUSH DE	
RST 0x10												; Otherwise print the character
POP DE	
Print_flat_255_Terminated_continuar:
INC DE													; Inc to the next character in the string
JR Print_flat_255_Terminated									; Loop

;#####################################################################################################
;#####				Print_255_Terminated_with_line_wrap
;#####		parámetro: en el registro DE viene la dirección de la cadena que se va a escribir 
;#####		parámetro: en el registro B el limite izquierdo
;#####		parámetro: en el registro C el limite derecho
;#####################################################################################################
Print_255_Terminated_with_line_wrap:

LD A, (DE)												; Lee el primer carácter
CP 255													; Compara con 255 que hace de separador
RET Z													; Si era igual a 255 retorna
CP RETORNO_DE_CARRO										; Ahora compara con 13 (retorno de carro) 
JR Z, Retorno_carro										; Si era igual al retorno de carro, salta a Retorno_carro
	
PUSH BC													; preserva en pila el registro BC
PUSH DE													; preserva en pila el registro DE
RST 0x10												; Imprime el carácter actual
POP DE													; restaura el registro DE desde la pila
POP BC													; restaura el registro BC desde la pila
	
LD HL, ROM_PRINT_CURRENT_COLUMN							; apunta al indice horizontal de print
LD A, (HL)												; carga en A el indice horizontal de print
CP C													; compara con el limite derecho
JR NC, Continua_Print_255_Terminated_with_line_wrap		; si es menor o igual, salta a continuar
JR Retorno_carro										; si es menor (la coordenada va en sentido decreciente) salta a retorno de carro

Retorno_carro:
PUSH BC													; preserva BC
LD A, AT												; carga el código AT
RST 0x10												; lo imprime

LD HL, ROM_PRINT_CURRENT_LINE							; carga el puntero a la linea actual de print
LD B, (HL)												; carga el valor en B
LD A, 24												; carga 24 en A para calcular la línea
SUB B													; A <- ( 24-B )
INC A													; incrementa A - baja una línea
RST 0x10												; imprime y posiciona el cursor
POP BC													; restaura BC
LD A, B													; carga en A el valor de la columna
RST 0x10												; imprime

Continua_Print_255_Terminated_with_line_wrap:
INC DE													; Inc to the next character in the string
JR Print_255_Terminated_with_line_wrap					; Loop


;#####################################################################################################
;#####		Print_255_Terminated_with_line_wrap_in_the_printer
;#####		parámetro: en el registro DE viene la dirección de la cadena que se va a escribir 
;#####		parámetro: en el registro B el limite izquierdo
;#####		parámetro: en el registro C el limite derecho
;#####################################################################################################
Print_255_Terminated_with_line_wrap_in_the_printer:
LD A, PAPER
RST 0x10
LD A, WHITE
RST 0x10
LD A, INK
RST 0x10
LD A, BLACK
RST 0x10
LD A, (DE)															; Lee el primer carácter
CP 255																; Compara con 255 que hace de separador
RET Z																; Si era igual a 255 retorna
push af								;;;; NEW
ld a, h								;;;; NEW
cp 69								;;;; NEW
pop ix
ld a, ixh
JR NZ, Continuar_con_char_13 		;;;; NEW
CP RETORNO_DE_CARRO													; Ahora compara con 13 (retorno de carro) 
JR Z, Cargar_espacio 				;;;; NEW
CP ESPACIO_BAJA_RES
JR Z, Continua_Print_255_Terminated_with_line_wrap_in_the_printer
JR Continuar_con_char_13
Cargar_espacio:
LD A, 32
Continuar_con_char_13:
CP RETORNO_DE_CARRO													; Ahora compara con 13 (retorno de carro) 
JR Z, Retorno_carro_in_the_printer									; Si era igual al retorno de carro, salta a Retorno_carro
Continuar_sin_char_13: ;;;; NEW
PUSH BC																; preserva en pila el registro BC
PUSH DE																; preserva en pila el registro DE
RST 0x10
call Noise															; Imprime el carácter actual
POP DE																; restaura el registro DE desde la pila
POP BC																; restaura el registro BC desde la pila
push hl				
LD HL, ROM_PRINT_CURRENT_COLUMN										; apunta al indice horizontal de print
LD A, (HL)															; carga en A el indice horizontal de print
pop hl
CP C																; compara con el limite derecho
JR NC, Continua_Print_255_Terminated_with_line_wrap_in_the_printer	; si es menor o igual, salta a continuar
			
Retorno_carro_in_the_printer:			



push bc
push de
call Hacer_scroll_papel_impresora
LD A, AT															; carga el código AT
RST 0x10															; lo imprime
LD A, PRINTER_BASE_Y
RST 0x10															; imprime y posiciona el cursor
LD A, PRINTER_BASE_X
RST 0x10															; imprime
pop de
pop bc

Continua_Print_255_Terminated_with_line_wrap_in_the_printer:
INC DE																; Inc to the next character in the string
JR Print_255_Terminated_with_line_wrap_in_the_printer				; Loop


;#####################################################################################################
;#####				Print_weekday_and_hour
;#####################################################################################################
Print_weekday_and_hour:
LD A, PAPER
RST 0x10
LD A, BLACK
RST 0x10
LD A, INK
RST 0x10
LD A, WHITE
RST 0x10
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
;#####				Incrementa_hora_actual
;#####################################################################################################
;#####	   Añade una hora a la hora actual e incrementa el día si hace falta
;#####################################################################################################
Incrementa_hora_actual:
LD HL, CurrentHour					; Carga en HL la dirección de la hora
INC HL								; Incrementa en 1 para apuntar al dígito menos significativo de la hora
LD A, (HL)							; Carga el dígito menos significativo de la hora en A
INC A								; Incrementa en 1

CP CARACTER_ASCII_4					; Compara con el caracter ascii "4" para saber si puede ser una vuelta completa
JR Z, Puede_ser_vuelta_completa

CP CARACTER_ASCII_9_M_1				; Compara con el caracter ascii "4" para saber si puede ser una vuelta completa

JR NZ, guarda_hora_y_vuelve

; Si pasa por aquí es que simplemente hace falta pasar de [X][10] a [X+1][0]
LD (HL),CARACTER_ASCII_0
LD HL, CurrentHour
LD A, (HL)
INC A
JR guarda_hora_y_vuelve

Puede_ser_vuelta_completa:
LD HL, CurrentHour					; Carga en HL la dirección de la hora
LD A, (HL)							; Carga el dígito más significativo de la hora en A
CP CARACTER_ASCII_2					; Compara con el caracter ascii "2" para saber si puede ser una vuelta completa
JR NZ, guarda_vuelta_no_completa

; VUELTA_COMPLETA
LD (HL),CARACTER_ASCII_0
INC HL
LD (HL),CARACTER_ASCII_0
CALL Incrementa_dia_actual
RET

guarda_vuelta_no_completa:
inc hl
LD A, (HL)
INC A

guarda_hora_y_vuelve:
halt
halt
halt
halt
halt
LD (HL),A
CP CARACTER_ASCII_8
RET NZ
DEC HL
LD A, (HL)
CP CARACTER_ASCII_1
RET NZ
LD HL, CurrentWeekday
LD A, (HL)
CP 7
RET NZ
; CALL Nuevo_escondite
CALL Inicia_caso
RET



;#####				FIN Incrementa_hora_actual


;#####################################################################################################
;#####				Incrementa_dia_actual
;#####				
;#####################################################################################################
Incrementa_dia_actual:
LD HL, CurrentWeekday
LD A, (HL)
INC A
LD (HL), A
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

call Print_panel_derecho

ret

;#####################################################################################################
;#####				Print_panel_derecho
;#####################################################################################################
;;;; Panel derecho
Print_panel_derecho:
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
LD C, 0 											; PARA MEJORAR LA LEGIBILIDAD EN DEPURACIÓN
LD B, (HL)											; carga en B EL ÍNDICE DE la ciudad actual
INC B												; suma 1 al índice de ciudad
LD DE, Cities										; carga en DE el puntero a ciudades
;LD DE, Cities+2
CALL Select_elemento
LD B, 1												; parámetro: en el registro B el limite izquierdo
LD C, 23											; parámetro: en el registro C el limite derecho
CALL Print_255_Terminated_with_line_wrap
RET

;#####################################################################################################
;#####				Select_elemento
;#####		parámetro: en el registro B viene el índice del elemento que se va a seleccionar
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
;#####				Select_elemento
;#####		parámetro: en el registro B viene el índice del elemento que se va a seleccionar
;#####		parámetro: en el registro DE viene la dirección de la cadena que se va a escribir 
;#####		salida: en el registro DE sale la dirección de la cadena con el elemento seleccionado
;#####################################################################################################
Select_elemento_por_posicion:
LD H,0
LD L, B
ADD HL, DE
EX DE,HL
RET

;#####################################################################################################
;#####				Print_highligthed
;#####################################################################################################
Print_highligthed:
LD A, INK 
RST 0x10
LD A, YELLOW
RST 0x10
RET

;#####################################################################################################
;#####				Print_white
;#####################################################################################################
Print_white:
LD A, PAPER 
RST 0x10
LD A, BLACK
RST 0x10
LD A, INK 
RST 0x10
LD A, WHITE
RST 0x10
RET

;#####################################################################################################
;#####				Print_black
;#####################################################################################################
Print_black:
LD A, PAPER 
RST 0x10
LD A, WHITE
RST 0x10
LD A, INK 
RST 0x10
LD A, BLACK
RST 0x10
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
LD A, (HL)
OR A
JR Z, Print_city_desc_HQ
LD B, (HL)
LD DE, City_descriptions

INC B
LD C, 0
call Select_elemento
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

Print_city_desc_HQ:
call Pinta_impresora
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