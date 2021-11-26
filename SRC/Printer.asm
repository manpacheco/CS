;#####################################################################################################
;#####				Pinta_rango
;#####################################################################################################
Pinta_rango:
ld b, PRINTER_BASE_X
LD C, 5
LD A, PAPER
rst 0x10
ld a, WHITE
rst 0x10
ld a, AT
rst 0x10
LD A, PRINTER_BASE_Y
rst 0x10
LD A, PRINTER_BASE_X
rst 0x10
LD DE, Current_rank_message
CALL Print_255_Terminated_with_line_wrap_in_the_printer
LD DE, Ranks
LD HL, Current_rank
LD B, (HL)
CALL Select_elemento
CALL Print_255_Terminated_with_line_wrap_in_the_printer

LD DE, NewLine
CALL Print_255_Terminated_with_line_wrap_in_the_printer

LD DE, Press_key_to_start_message
CALL Print_255_Terminated_with_line_wrap_in_the_printer
RET

;#####################################################################################################
;#####				Dibujar_guias
;#####################################################################################################
Dibujar_guias:
ld a, PAPER
rst 0x10
ld a, YELLOW
rst 0x10
ld a, AT
rst 0x10
ld a, 15 ; Y
rst 0x10
ld a, 14 ; X
rst 0x10
ld a, 64 ; Guía impresora
rst 0x10

ld a, AT
rst 0x10
ld a, 15 ; Y
rst 0x10
ld a, 29 ; X
rst 0x10
ld a, 64 ; Guía impresora
rst 0x10
ret

;#####################################################################################################
;#####				Pinta_impresora
;#####################################################################################################
Pinta_impresora:

Call Borrar_panel_derecho

ld a, PAPER
rst 0x10
ld a, WHITE
rst 0x10
ld a, INK
rst 0x10
ld a, 0
rst 0x10

ld d, 32
ld e, 13
ld a, 3

Pinta_impresora_vertical_loop:

PUSH AF
ld a, AT
rst 0x10
ld a, e
inc e
rst 0x10
ld a, 14
rst 0x10

;; EMPIEZA A IMPRIMIR UNA LÍNEA
ld a, PAPER_HOLE_CHARACTER 
rst 0x10
ld b,14
Pinta_impresora_horizontal_loop:
ld a, 32 ; espacio
rst 0x10
djnz Pinta_impresora_horizontal_loop
ld a, PAPER_HOLE_CHARACTER
rst 0x10
;; FIN IMPRESIÓN DE LÍNEA

POP AF
dec a
jr nz, Pinta_impresora_vertical_loop


call Dibujar_guias



LD C, 2
SEGUNDA:
LD B, 18
ld a, AT
rst 0x10
ld a, e
inc e
rst 0x10
ld a, RETORNO_DE_CARRO
rst 0x10
;; EMPIEZA A IMPRIMIR UNA LÍNEA
Pinta_impresora_horizontal_loop2:

ld a, 95 ; guIÓN BAJO
rst 0x10
djnz Pinta_impresora_horizontal_loop2
DEC C
JR nz, SEGUNDA
;; FIN IMPRESIÓN DE LÍNEA

ld a, AT
rst 0x10
ld a, 16 ; Y
rst 0x10
ld a, 25 ; X
rst 0x10
ld a, OVER
rst 0x10
ld a, 1
rst 0x10
ld a, 92 ; LED
rst 0x10
ld a, 92 ; LED
rst 0x10
ld a, 92 ; LED
rst 0x10
ld a, OVER
rst 0x10
ld a, 0
rst 0x10
RET

;#####################################################################################################
;#####				Pinta_mensaje_impresora
;#####################################################################################################
Pinta_mensaje_impresora:
ld b, PRINTER_BASE_X
ld c, 5
ld a, PAPER
rst 0x10
ld a, WHITE 
rst 0x10
ld a, AT
rst 0x10
ld a, PRINTER_BASE_Y ; Y
;ld a, 4 ; Y
RST 0x10
LD A, B ; X
RST 0x10
LD DE, Mensajes_impresora
call Print_255_Terminated_with_line_wrap_in_the_printer

;call Print_255_Terminated_with_line_wrap
call Hacer_scroll_papel_impresora
ret

;#####################################################################################################
;#####				Hacer_scroll_papel_impresora
;#####################################################################################################
Hacer_scroll_papel_impresora:
push hl
push de
push bc
push af
ld hl, LIVE_SCREEN_ADDRESS+192+14
ld de, LIVE_SCREEN_ADDRESS+160+14
call Scroll_up
ld HL, LIVE_SCREEN_ADDRESS+224+14
ld DE, LIVE_SCREEN_ADDRESS+192+14
call Scroll_up
ld HL, LIVE_SCREEN_ADDRESS+2048+14
ld DE, LIVE_SCREEN_ADDRESS+224+14
call Scroll_up

ld a, PAPER
rst 0x10

ld a, WHITE
rst 0x10

ld a, INK
rst 0x10

ld a, BLACK
rst 0x10

ld a, AT
RST 0x10
ld a, 15
RST 0x10
ld a, 14
RST 0x10
LD A, PAPER_HOLE_CHARACTER                							
RST 0x10
ld a, AT
RST 0x10
ld a, 15
RST 0x10
ld a, 29
RST 0x10
LD A, PAPER_HOLE_CHARACTER                							
RST 0x10


ld bc, 32
push ix
push iy
ld ix, LIVE_SCREEN_ADDRESS+2048+0+14
ld iy, LIVE_SCREEN_ADDRESS+2048-32+14
ld a, 7


Pinta_mensaje_loop_scroll:
add ix, bc

push ix
pop hl

add iy, bc

push iy
pop de

push af
push bc
call Scroll_up
pop bc
pop af
dec a
jr nz, Pinta_mensaje_loop_scroll

pop iy
pop ix
call Dibujar_guias
call Borrar_primera_linea
pop af
pop bc
pop de
pop hl
RET

;#####################################################################################################
;#####				Borrar_primera_linea
;#####################################################################################################
Borrar_primera_linea:
ld a, PAPER
rst 0x10
ld a, WHITE
rst 0x10
ld a, AT
rst 0x10
ld a, 15
rst 0x10
ld a, 15
rst 0x10
ld b, 14
repetir_borrar_primera_linea:
ld a, 32
rst 0x10
djnz repetir_borrar_primera_linea
ret


;#####################################################################################################
;#####				Scroll_up : Hace scroll de una línea de caracteres de 1 caracter (8 píxeles) de alto
;#####				Param: HL Dirección de origen
;#####				Params DE Dirección de destino
;#####################################################################################################
Scroll_up:
ld a,8
Scroll_bucle_exterior:
ld b,0
ld c, 16
push hl
push de
LDIR
pop de
pop hl
push af
call NextScan
ex de, hl
call NextScan
pop af
ex de, hl
dec a
jr nz, Scroll_bucle_exterior
ret