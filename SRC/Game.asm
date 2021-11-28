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
RET