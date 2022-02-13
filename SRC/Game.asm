ESCAPE_ROUTE_LEN EQU 5

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
;################################# RandomEscapeRoute ####################################################
;########## genera la ruta de escape del ladrón actual a través de ciudades interconectadas #############
;########## Usa: AF, BC, HL, DE, IXH														#############
;########################################################################################################
RandomEscapeRoute:
PUSH HL										; PRESERVA EL REGISTRO HL EN LA PILA
CALL Random									; Se aleatoriza el valor del registro A
ld a, 3 ; TEST TEST TEST
AND 31										; Se recorta a 31 como máximo
OR A										; Se compara con 0
JR Z, SpecialBranchRandomEscapeRoute		; Si es 0 salta a rama especial
CP 31										; Se compara con 31
JR Z, SpecialBranchRandomEscapeRoute		; Si es 31 salta a rama especial
JR ContinuarRandomEscapeRoute				; Si no era 0 ni 31, salta a continuar
SpecialBranchRandomEscapeRoute:
JR RandomEscapeRoute						; Y salta al inicio de la función

ContinuarRandomEscapeRoute:
LD HL, CurrentEscapeRoute					; Carga en el registro HL la dirección de la variable de tipo array de bytes de la ruta de escape
LD (HL), A									; Guarda A (la ciudad que ha tocado) en la primera posición del array
LD B, A										; Guarda A (la ciudad que ha tocado) en el registro B
INC B										; Incrementa B porque en el índice de ciudades el 0 es HQ y no vale

PUSH BC										; Preserva BC en la pila
LD BC, 1									; Se mete 1 en BC para usarlo de contador
BucleRutaEscape:
LD DE, Connections							; Carga en DE la dirección de los datos de conexiones entre ciudades
;; EN A ESTÁ LA CIUDAD ACTUAL
DEC A										; Se decrementa porque en connections no empieza por HQ sino que empieza directamente por Athens
SLA A										; multiplica por 2
SLA A										; multiplica por 2 (acumulado por 4)
LD H, 0										; anula el registro H
LD L, A										; carga en L el índice de la ciudad actual por 4 (para poder usarlo en el array de conexiones aéreas)

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
JR Z, ChooseRandomForConnection				; si es así, repite el sorteo de conexión aérea
LD HL, CurrentEscapeRoute					; Carga en el registro HL la dirección de la variable de tipo array de bytes de la ruta de escape
ADD HL, BC
LD (HL), A									; Guarda A (la ciudad que ha tocado) en la primera posición del array

;; EN ESTE PUNTO EN TEORÍA EN HL ESTÁ APUNTANDO A LAS CONEXIONES DE LA CIUDAD QUE VENÍA EN EL REGISTRO A CON EL OFFSET RANDOM
INC BC
LD IXL, A
LD A, C
CP ESCAPE_ROUTE_LEN 						; Comprueba si se ha llegado al número de iteraciones
LD A, IXL
JR NZ, BucleRutaEscape

POP BC
POP HL
Comprobar:

RET

;########################################################################################################
;###################################   Refresh_city  ####################################################
;########################################################################################################
Refresh_city:
CALL Restablecer_valores_por_defecto_recuadros
CALL Pinta_pantalla_juego
CALL Pinta_imagen_ciudad
RET

;########################################################################################################
;################################### Inicia_caso ####################################################
;########################################################################################################
Inicia_caso:

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
;################################### Select_next_thief ####################################################
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