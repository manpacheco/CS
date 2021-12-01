;########################################################################################################
;################################### Random ####################################################
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
CALL Random
AND 31
CP 2 
JR NC, Inicia_caso_valid_city
ld A, 17	; Si la ciudad resulta 0, mejor le ponemos otro valor, p.ej. 17

Inicia_caso_valid_city:
ld hl, CurrentCity
ld (hl), a
ld hl, CurrentEscapeRoute
LD (HL), A
LD B, A
PUSH BC
LD DE, Cities
CALL Select_elemento
CALL Print_255_Terminated_with_line_wrap_in_the_printer
LD DE, Stolen_item_message
CALL Print_255_Terminated_with_line_wrap_in_the_printer
LD DE, National_treasures
pop bc
CALL Select_elemento
CALL Print_255_Terminated_with_line_wrap_in_the_printer
LD DE, NewLine
; CALL Print_255_Terminated_with_line_wrap_in_the_printer
CALL Select_next_thief
LD HL, Current_thief
LD B, (HL)
;LD DE, Thief_names

;;;;;; CONTINUAR POR AQUÍ, por que no se pintan los nombres del ladron actual?


LD DE, City_descriptions
CALL Select_elemento
CALL Print_255_Terminated_with_line_wrap_in_the_printer
hola:
jr hola
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
CALL Select_elemento										; Selecciona el elemento i-ésimo, estando el índice en el registro B
LD A, (DE)													; Carga el dato en A
OR A														; Se mira si es 0
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