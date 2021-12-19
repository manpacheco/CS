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
;################################### RandomEscapeRoute ####################################################
;########################################################################################################
RandomEscapeRoute:
CALL Random									; Se aleatoriza el valor del registro A
AND 31										; Se recorta a 31 como máximo
OR A										; Se compara con 0
JR Z, SpecialBranchRandomEscapeRoute		; Si es 0 salta a rama especial
CP 31										; Se compara con 31
JR Z, SpecialBranchRandomEscapeRoute		; Si es 31 salta a rama especial
JR ContinuarRandomEscapeRoute				; Si no era 0 ni 31, salta a continuar
SpecialBranchRandomEscapeRoute:
; CALL Random								; En la rama especial, llama a otro random
JR RandomEscapeRoute						; Y salta al inicio de la función
ContinuarRandomEscapeRoute:
LD HL, CurrentEscapeRoute					; Carga en el registro HL la dirección de la variable de tipo array de bytes de la ruta de escape
LD (HL), A									; Carga A (la ciudad que ha tocado) en la primera posición del array
LD B, A
INC B

PUSH BC										; Preserva BC
LD B, 1
BucleRutaEscape:

LD DE, Connections
;; EN A ESTÁ LA CIUDAD ACTUAL
DEC A
SLA A
SLA A
LD H, 0
LD L, A
ADD HL, DE

;;; REVISAR: SIEMPRE SALE 0 COMO OFFSET DE LA CIUDAD POSIBLE DESTINO

;; ELIGE ENTRE UNO DE LOS DESTINOS
EligeDestino:
PUSH HL
EX DE,HL
CALL Random
EX DE,HL
AND 3
PUSH BC
LD B, 0
LD C, A
ADD HL, BC
LD A, (HL)
CP 255
POP BC
POP HL
JR Z, EligeDestino

LD A, (HL)									; Carga en A la nueva ciudad
LD DE, CurrentEscapeRoute
INC DE
LD (DE), A

DJNZ BucleRutaEscape
POP BC
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
;;;; QUITAR EN PRODUCCION START
;LD HL, Current_thief
;LD B, (HL)
;LD DE, Thief_names
;CALL Select_elemento
;CALL Print_255_Terminated_with_line_wrap_in_the_printer
;;;; QUITAR EN PRODUCCION END
ld hl, CurrentCity
ld a,(hl)
ld b,a
INC B
;ld b, 26
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