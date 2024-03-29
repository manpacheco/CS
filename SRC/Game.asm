ESCAPE_ROUTE_LEN 			EQU 5
VALOR_CIUDAD_MARCADA 		EQU 85

ANCHURA_PANTALLA_COLUMNAS 	EQU 32
PAPEL_BLANCO_TINTA_BLANCA 	EQU 63
CURSOR_POR_DEFECTO			EQU 2
CIUDAD_INICIAL				EQU 1
ULTIMO_BYTE_ZONA_ATTR		EQU 23296

;########################################################################################################
;#####                             Random        
;#####		parámetro: variable Seed_for_random (en memoria)
;#####		salida: en el registro A sale un número aleatorio entre 0 y 255
;#####		usa registros: AF, HL
;########################################################################################################
; Simple pseudo-random number generator.
; Steps a pointer through the ROM (held in seed), returning
; the contents of the byte at that location.
Random:
LD HL,(Seed_for_random) ; Pointer
LD A,H
AND 31 ; keep it within first 8k of ROM.
LD H,A
LD A,(HL) ; Get "random" number from location.
INC HL ; Increment pointer.
LD (Seed_for_random),HL
RET

;########################################################################################################
;################################# limpia_buffer_vram ####################################################
;########## genera la ruta de escape del ladrón actual a través de ciudades interconectadas #############
;########## Parámetros: ninguno		   														#############
;########## Usa: BC, HL																		#############
;########################################################################################################
limpia_buffer_vram:
LD B, 32
LD HL, LIVE_SCREEN_ADDRESS
bucle_limpia_buffer_vram:
LD (HL),0
INC HL
DJNZ bucle_limpia_buffer_vram
RET

;########################################################################################################
;################################# RandomEscapeRoute ####################################################
;########## genera la ruta de escape del ladrón actual a través de ciudades interconectadas #############
;########## Parámetros: ninguno		   														#############
;########## Usa: AF, BC, HL, DE, IXH														#############
;########################################################################################################
RandomEscapeRoute:
PUSH HL										; PRESERVA EL REGISTRO HL EN LA PILA
CALL limpia_buffer_vram
CALL Random									; Se aleatoriza el valor del registro A
ld a, 9 ; TEST TEST TEST
AND 31										; Se recorta a 31 como máximo
OR A										; Se compara con 0
JR Z, SpecialBranchRandomEscapeRoute		; Si es 0 salta a rama especial
CP 31										; Se compara con 31
JR Z, SpecialBranchRandomEscapeRoute		; Si es 31 salta a rama especial
JR ContinuarRandomEscapeRoute				; Si no era 0 ni 31, salta a continuar
SpecialBranchRandomEscapeRoute:
JR RandomEscapeRoute						; Y salta al inicio de la función

ContinuarRandomEscapeRoute:
Call MarcaCiudadComoUsada
LD HL, CurrentEscapeRoute					; Carga en el registro HL la dirección de la variable de tipo array de bytes de la ruta de escape
LD (HL), A									; Guarda A (la ciudad que ha tocado) en la primera posición del array
LD B, A										; Guarda A (la ciudad que ha tocado) en el registro B
INC B										; Incrementa B porque en el índice de ciudades el 0 es HQ y no vale

PUSH BC										; Preserva BC en la pila
LD BC, 1									; Se mete 1 en BC para usarlo de contador
BucleRutaEscape:

LD DE, Connections							; Carga en DE la dirección de los datos de conexiones entre ciudades

call set_HL_with_value_to_add_to_connections_pointer_for_city_in_A_position

ChooseRandomForConnection:
PUSH HL
CALL Random									; Se genera un random [0-255] en A
POP HL
AND 3										; Se recorta a un random [0-3] en A
ADD A,L										; Se añade el número random [0-3] a lo que se va a sumar para apuntar a las conexiones de la ciudad seleccionada
LD L, A										; Se carga el resultado en L
ADD HL, DE									; Se suma todo en el registro HL

LD A, (HL)									; Carga en A la ciudad que consta como conexión random de la ciudad seleccionada previamente
CP 255										; Comprueba que no sea un valor prohibido (por ser un nodo con solamente 3 aristas)
JR Z, RebootRandomEscapeRoute

LD HL, CurrentEscapeRoute					; Carga en el registro HL la dirección de la variable de tipo array de bytes de la ruta de escape
ADD HL, BC
LD (HL), A									; Guarda A (la ciudad que ha tocado) en la primera posición del array
Call MarcaCiudadComoUsada
EX AF, AF'
JR Z, RebootRandomEscapeRoute
EX AF, AF'

;; EN ESTE PUNTO EN TEORÍA EN HL ESTÁ APUNTANDO A LAS CONEXIONES DE LA CIUDAD QUE VENÍA EN EL REGISTRO A CON EL OFFSET RANDOM
INC BC
LD IXL, A
LD A, C
CP ESCAPE_ROUTE_LEN 						; Comprueba si se ha llegado al número de iteraciones
LD A, IXL
JR NZ, BucleRutaEscape

POP BC
POP HL
RET

RebootRandomEscapeRoute:
POP BC
POP HL
JR RandomEscapeRoute


;########################################################################################################
;#####   set_HL_with_value_to_add_to_connections_pointer_for_city_in_A_position  ########################
;#####		parámetro: ciudad en registro A
;#####		salida: en el registro HL se guarda un puntero a las conexiones de la ciudad A-ésima
;#####		usa registros: AF, HL
;########################################################################################################
set_HL_with_value_to_add_to_connections_pointer_for_city_in_A_position:
;; EN A ESTÁ LA CIUDAD ACTUAL
DEC A										; Se decrementa porque en connections no empieza por HQ sino que empieza directamente por Athens
SLA A										; multiplica por 2
SLA A										; multiplica por 2 (acumulado por 4)
LD H, 0										; anula el registro H
LD L, A										; carga en L el índice de la ciudad actual por 4 (para poder usarlo en el array de conexiones aéreas)
RET

;########################################################################################################
;###############################   MarcaCiudadComoUsada  ################################################
;## Se marca el índice de la ciudad en la memoria de video para no repetir ninguna ######################
;## DEVUELVE EN AF' la comparación con la marca ######################
;########################################################################################################
MarcaCiudadComoUsada:
PUSH HL
PUSH BC

LD HL, LIVE_ATTRIBUTES_ADDRESS
LD B, ANCHURA_PANTALLA_COLUMNAS
cuadros:
LD (HL),PAPEL_BLANCO_TINTA_BLANCA
INC HL
DJNZ cuadros

LD HL, LIVE_SCREEN_ADDRESS
LD B, 0
LD C, A
ADD HL, BC
EX AF, AF'
LD A, (HL)
CP VALOR_CIUDAD_MARCADA
EX AF, AF'
LD (HL), VALOR_CIUDAD_MARCADA
LD HL, LIVE_SCREEN_ADDRESS
POP BC
POP HL
RET

;########################################################################################################
;###################################   Refresh_city  ####################################################
;########################################################################################################
Refresh_city:
CALL Restablecer_valores_por_defecto_recuadros
call Print_black
CALL Print_linea_blanco
LD A, AT
RST 0x10
LD A, 19
RST 0x10
LD A, 0
RST 0x10

LD HL, ULTIMO_BYTE_ZONA_ATTR
LD B, 160 ;; 32 * 5
blancos:
DEC HL
LD (HL), 63
DJNZ blancos
CALL Print_black

;;; 31/07 -> 01/08
; DEJAR PLACEHOLDER PARA POSIBLE EFECTO TRÁNSITO AVIÓN + SONIDO
; EN CASO DE SELECCIONAR OTRA CIUDAD, ESTABLECER ESA CIUDAD COMO CIUDAD ACTUAL Y VOLVER A MENU PRINCIPAL



CALL Pinta_pantalla_juego
CALL Pinta_imagen_ciudad


CALL Dibuja_Linea

LD B, 13
LD C, 3
LD DE, NewLine
CALL Print_255_Terminated_with_line_wrap
LD DE, NewLine
CALL Print_255_Terminated_with_line_wrap
LD DE, Next_step_message
CALL Print_255_Terminated_with_line_wrap
RET

;########################################################################################################
;################################### Inicia_caso ####################################################
;########################################################################################################
Inicia_caso:
;;; DEBUG
call Pinta_todos_recuadros
;;; FIN DEBUG

ld hl,CurrentWeekday
ld (hl), 1
ld hl,CurrentHour
ld (hl), CARACTER_ASCII_0
inc hl
ld (hl), CARACTER_ASCII_9
CALL Pinta_rango
CALL PressAnyKey
EX AF,AF'
LD HL, Seed_for_random
LD (HL), A
EX AF,AF'
LD DE, Flash_message
CALL Print_255_Terminated_with_line_wrap_in_the_printer

CALL RandomEscapeRoute

PUSH BC
LD HL, CurrentEscapeRoute
LD A, (HL)
LD HL, CurrentCity
LD (HL), A

LD DE, Cities
CALL Select_elemento
ld h, 69
CALL Print_255_Terminated_with_line_wrap_in_the_printer		; pinta la ciudad que ha tocado
ld h, 0
LD DE, Stolen_item_message
CALL Print_255_Terminated_with_line_wrap_in_the_printer		; pinta el mensaje de lo robado
LD DE, National_treasures
POP BC
CALL Select_elemento										; selecciona el tesoro robado correspondiente a la ciudad
CALL Print_255_Terminated_with_line_wrap_in_the_printer
LD DE, NewLine
CALL PressAnyKey
CALL Print_255_Terminated_with_line_wrap_in_the_printer
CALL Select_next_thief
LD HL, Current_thief
LD B, (HL)
LD DE, Thief_sex
CALL Select_elemento_por_posicion
LD A, (DE)
LD B, A
PUSH BC														; Se preserva b para más adelante
LD DE, Sex_texts
CALL Select_elemento
CALL Print_255_Terminated_with_line_wrap_in_the_printer
LD DE, Suspect_message
CALL Print_255_Terminated_with_line_wrap_in_the_printer
LD HL, CurrentCity
LD A,(HL)
LD B,A
INC B
push af
LD DE, Cities
CALL Select_elemento
ld h, 69
CALL Print_255_Terminated_with_line_wrap_in_the_printer		
LD DE, Hideout_message
POP AF
CP 26
JR NZ, Continua_sin_CR
INC DE
Continua_sin_CR:
POP BC
CALL Select_elemento
ld h, 0
CALL Print_255_Terminated_with_line_wrap_in_the_printer		
LD DE, NewLine
CALL PressAnyKey
CALL Print_255_Terminated_with_line_wrap_in_the_printer
LD DE, GoodLuck_message
CALL Print_255_Terminated_with_line_wrap_in_the_printer		
LD DE, NewLine
CALL PressAnyKey
CALL Print_255_Terminated_with_line_wrap_in_the_printer


RET

;########################################################################################################
;################################### Select_next_thief ##################################################
;########################################################################################################
Select_next_thief:
; SELECCIONAR LADRON
LD HL, Thiefs_in_jail										; Lo primero es comprobar si hay que poner activa a CS
LD A, (HL)													; Carga en a el número de ladrones en la cárcel
CP 9														; compara ese dato con los 9 de la banda sin contar a la jefa
JR C, Poner_ladron_banda									; Si ladrones en la carcel < 9 poner uno de la banda
XOR A														; Si ya esta toda la banda en la carcel, activar a CS
JR Fija_ladron_activo
;Poner ladron de la banda
Poner_ladron_banda:
CALL Random													; Se pone un número aleatorio [0-255] en A
AND 7														; Se recorta a [0-7]
INC A														; Se suma 1 y pasa a [1-8]
LD DE, Active_thiefs										; Carga en DE la lista de ladrones activos
Bucle_seleccion_ladron:
LD B, A														; Carga el [1-8] en B
CALL Select_elemento_por_posicion							; Selecciona el elemento i-ésimo, estando el índice en el registro B
EX AF, AF'
LD A, (DE)													; Carga el dato en A
OR A														; Se mira si es 0
EX AF, AF'
JR NZ, Fija_ladron_activo									; Si no es 0, entonces este me vale
INC A														; Si es 0, se intenta con el siguiente
CP 10														; Si ha llegado a 10, ya está fuera del array
JR NZ, Bucle_seleccion_ladron
LD A, 1
JR Bucle_seleccion_ladron
Fija_ladron_activo:
LD HL, Current_thief
LD (HL), A
RET


;########################################################################################################
;###################################      Depart       ##################################################
;########################################################################################################
Depart:
LD HL, Cursor
LD (HL), 1	; Valor por defecto = 3
ld hl, Cursor_max
ld (hl), 4
ld hl, Current_menu
ld (hl),2
CALL World_map
LD HL, Window_y_inicial
LD (HL), 2
LD HL, Window_x_inicial
LD (HL), 0
ld hl, Window_y_final_m_1
LD (HL), 6
ld hl, Window_x_final_m_1
LD (HL), 31
ld hl, Caracter_relleno								; Carga en HL la dirección del caracter de relleno
ld (hl), CARACTER_TODO_RELLENO						; Carga en la dirección del caracter de relleno el caracter todo relleno
CALL Pinta_recuadro
LD DE, Menu							; Carga en el registro DE la dirección de la cadena del menú superior
CALL Print_255_Terminated			; Pinta el menú superior

ld c, 3 ; se compara primero con 1
CALL Pinta_ciudad_origen
CALL Pinta_ciudades_destino
RET

;########################################################################################################
;############################      Pinta_ciudad_origen       #########################################
;########## Parámetros: C		   														#############
;########## Usa: AF, BC, DE, HL																#############
;########################################################################################################
;########################################################################################################
Pinta_ciudad_origen:
call Print_white
push hl
ld hl, Cursor
ld a, (hl)
pop hl
ld c, CIUDAD_INICIAL
cp c
jr NZ, Continuar_ciudad_origen
call Print_highligthed
Continuar_ciudad_origen:

LD DE, City_origin
CALL Print_255_Terminated

LD DE, Cities
LD HL, CurrentCity
LD B, (HL)

LD A, (HL)									; SE guarda la ciudad actual en A que luego será A'

INC B
CALL Select_elemento
LD B,1
LD C,13
CALL Print_255_Terminated_with_line_wrap
CALL Print_white
RET

;########################################################################################################
;############################      Nuevo_escondite       #########################################
;########## Parámetros: 		   														#############
;########## Usa: 															#############
;########################################################################################################
;########################################################################################################
Nuevo_escondite:
LD A,6 								; carga el color del borde
OUT (254),A							; establecer el color del borde
halt
halt
halt
halt
halt
halt
LD A,3 								; carga el color del borde
OUT (254),A							; establecer el color del borde
halt
halt
halt
halt
halt
halt
LD A,6 								; carga el color del borde
OUT (254),A							; establecer el color del borde
halt
halt
halt
halt
halt
halt
LD A,3 								; carga el color del borde
OUT (254),A							; establecer el color del borde
halt
halt
halt
halt
halt
halt
RET

;########################################################################################################
;############################      Pinta_ciudades_destino       #########################################
;########## Parámetros: 		   														#############
;########## Usa: AF, DE, HL																#############
;########################################################################################################
;########################################################################################################
Pinta_ciudades_destino:
;; PRIMERA CIUDAD DESTINO
ld c, 2 

ld hl, Cursor
ld a, (hl)
cp c
jr NZ, Continuar_primera_ciudad
call Print_highligthed
Continuar_primera_ciudad:
inc c
LD DE,City_destination1
CALL Print_255_Terminated

LD HL, CurrentCity
LD A, (HL)									
CALL set_HL_with_value_to_add_to_connections_pointer_for_city_in_A_position
LD DE, Connections
ADD HL, DE

LD B, (hl)
LD DE, Cities
INC B
CALL Select_elemento
CALL Print_flat_255_Terminated
call Print_white

;; SEGUNDA CIUDAD DESTINO
push hl
ld hl, Cursor
ld a, (hl)
cp c
jr NZ, Continuar_segunda_ciudad
call Print_highligthed

Continuar_segunda_ciudad:
pop hl
inc c
LD DE,City_destination2
CALL Print_255_Terminated

INC HL
LD B, (HL)
LD DE, Cities
INC B
CALL Select_elemento
CALL Print_flat_255_Terminated
call Print_white

;; TERCERA CIUDAD DESTINO
push hl
ld hl, Cursor
ld a, (hl)
cp c
jr NZ, Continuar_tercera_ciudad
call Print_highligthed

Continuar_tercera_ciudad:
pop hl
inc c
LD DE,City_destination3
CALL Print_255_Terminated

INC HL
LD B, (HL)
LD DE, Cities
INC B
CALL Select_elemento
CALL Print_flat_255_Terminated

call Print_white


;; CUARTA CIUDAD DESTINO (OPCIONAL)


push hl

ld hl, Cursor
ld a, (hl)
cp c
jr NZ, Continuar_cuarta_ciudad
call Print_highligthed

Continuar_cuarta_ciudad:
pop hl
inc c
LD DE,City_destination4
CALL Print_255_Terminated

INC HL
LD B, (HL)
LD A, B

compara255:
CP 255
RET Z
ld hl, Cursor_max
ld (hl), 5
LD DE, Cities
INC B
CALL Select_elemento
CALL Print_flat_255_Terminated
RET


Plot:
; This is the simplest to use of all the routines. The easiest method of using this routine is to call it from location #22E5 (8933 decimal). 
; On entry, the routine expects to have the x, y co-ordinates of the point to be plotted in the BC register pair, so to plot a point equivalent to Basic's, Piot 100,90 we only need to write
; LD BC, 5A64 ; Plot 100, 90
; CALL #22E5	;call Plot ROM routine
RET				;return to Basic

Fly:
RET

Enquire:
RET

ArrestTron:
RET