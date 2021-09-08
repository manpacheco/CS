UNZIPPED_SCREEN_ADDRESS EQU 58455
LIVE_SCREEN_ADDRESS EQU 16384
CITY_PICTURE_WIDTH_IN_CHARACTERS EQU 10 ; 10 characters
CITY_PICTURE_HEIGHT_IN_CHARACTERS EQU 12 ; 12 characters
CITY_PICTURE_WIDTH_IN_PIXELS EQU CITY_PICTURE_WIDTH_IN_CHARACTERS*8 ; 80
CITY_PICTURE_HEIGHT_IN_PIXELS EQU CITY_PICTURE_HEIGHT_IN_CHARACTERS*8 ; 96
CITY_PICTURE_HORIZONTAL_OFFSET_IN_PIXELS EQU (256-CITY_PICTURE_WIDTH_IN_PIXELS) ; 176
CITY_PICTURE_HORIZONTAL_OFFSET_IN_CHARACTERS EQU (32-CITY_PICTURE_WIDTH_IN_CHARACTERS) ; 32-10 = 22

;; A: Y Characters shift down
;; C: X Characters shift left
load_screen:
LD B,0							; Se descarta la parte alta de BC
LD HL, LIVE_SCREEN_ADDRESS		; Se carga en el registro HL la dirección de la memoria de video
ADD HL, BC						; Se le suman a la dirección de la memoria de vídeo los caracteres de offset en horizontal (en el registro C)


baja_una_scanline:
OR A							; examina el registro A
JR z,no_bajar_mas				; si es 0, entonces deja de iterar	
EX AF,AF'						; preserva AF en el registro alternativo AF´
CALL NextScan					; machaca con la siguiente scanline
EX AF,AF'						; restaura AF que estaba guardado en el registro alternativo AF´
DEC A							; decrementa el contador en A
JR baja_una_scanline
no_bajar_mas:

; EMPIEZA LA COPIA DE MEMORIA A MEMORIA

LD D, H
LD E, L

;LD DE, LIVE_SCREEN_ADDRESS+3+2048

LD HL, UNZIPPED_SCREEN_ADDRESS
LD A, CITY_PICTURE_HEIGHT_IN_PIXELS
;LD A, 32 ; PRUEBA


LD BC, CITY_PICTURE_WIDTH_IN_CHARACTERS

load_screen_loop:
push de
LDIR
; LDIR = Repetir LDI hasta que BC valga 0
;     = Repetir:
;          Copiar [HL] en [DE]
;          DE=DE+1
;          HL=HL+1
;          BC=BC-1
;       Hasta que BC = 0
pop de
LD BC, CITY_PICTURE_HORIZONTAL_OFFSET_IN_CHARACTERS

;ADD HL, BC
EX DE, HL
ex af, af'
CALL NextScan
;ADD HL, BC
ex af, af'
EX DE, HL
LD BC, CITY_PICTURE_WIDTH_IN_CHARACTERS

DEC A
OR A
JR NZ, load_screen_loop
paraaa:
jr paraaa
ret

; NextScan. https://wiki.speccy.org/cursos/ensamblador/gfx2_direccionamiento
; Obtiene la posición de memoria correspondiente al scanline siguiente al indicado.
; 010T TSSS LLLC CCCC
; Entrada: HL -> scanline actual.
; Salida: HL -> scanline siguiente.
; Altera el valor de los registros AF y HL.
; -----------------------------------------------------------------------------
NextScan:
inc h ; Incrementa H para incrementar el scanline
ld a, h ; Carga el valor en A
and $07 ; Se queda con los bits del scanline
ret nz ; Si el valor no es 0, fin de la rutina

; Calcula la siguiente línea
ld a, l ; Carga el valor en A
add a, $20 ; Añade 1 a la línea (%0010 0000)
ld l, a ; Carga el valor en L
ret c ; Si hay acarreo, ha cambiado de tercio,

; que ya viene ajustado de arriba. Fin de la rutina

; Si llega aquí, no ha cambiado de tercio y hay que ajustar
; ya que el primer inc h incrementó el tercio
ld a, h ; Carga el valor en A
sub $08 ; Resta un tercio (%0000 1000)
ld h, a ; Carga el valor en H
ret