;UNZIPPED_SCREEN_ADDRESS EQU 58455
UNZIPPED_SCREEN_ADDRESS EQU 57344
LIVE_SCREEN_ADDRESS EQU 16384
CITY_PICTURE_WIDTH_IN_CHARACTERS EQU 10 ; 10 characters
CITY_PICTURE_HEIGHT_IN_CHARACTERS EQU 12 ; 12 characters
CITY_PICTURE_WIDTH_IN_PIXELS EQU CITY_PICTURE_WIDTH_IN_CHARACTERS*8 ; 80
CITY_PICTURE_HEIGHT_IN_PIXELS EQU CITY_PICTURE_HEIGHT_IN_CHARACTERS*8 ; 96
CITY_PICTURE_HORIZONTAL_OFFSET_IN_PIXELS EQU (256-CITY_PICTURE_WIDTH_IN_PIXELS) ; 176
CITY_PICTURE_HORIZONTAL_OFFSET_IN_CHARACTERS EQU (32-CITY_PICTURE_WIDTH_IN_CHARACTERS) ; 32-10 = 22


;#####################################################################################################
;#####				load_screen
;#####################################################################################################

;; A: Y Characters shift down
;; C: X Characters shift left

load_screen:
push bc									; QUITAR TRAS DEPURAR
push af									; QUITAR TRAS DEPURAR
CALL ROM_CLS							; QUITAR TRAS DEPURAR
pop af									; QUITAR TRAS DEPURAR
pop bc									; QUITAR TRAS DEPURAR
LD B,0									; Se descarta la parte alta de BC
LD HL, LIVE_SCREEN_ADDRESS				; Se carga en el registro HL la dirección de la memoria de video
ADD HL, BC								; Se le suman a la dirección de la memoria de vídeo los caracteres de offset en horizontal (en el registro C)

baja_una_scanline:
OR A									; examina el registro A
JR z,no_bajar_mas						; si es 0, entonces deja de iterar	
EX AF,AF'								; preserva AF en el registro alternativo AF´
CALL NextScan							; machaca con la siguiente scanline
EX AF,AF'								; restaura AF que estaba guardado en el registro alternativo AF´
DEC A									; decrementa el contador en A
JR baja_una_scanline
no_bajar_mas:

; EMPIEZA LA COPIA DE MEMORIA A MEMORIA

LD D, H									;copia HL a DE
LD E, L									;copia HL a DE

;LD DE, LIVE_SCREEN_ADDRESS+3+2048

LD HL, UNZIPPED_SCREEN_ADDRESS			; Como base de la dirección de lectura se usa la constante UNZIPPED_SCREEN_ADDRESS
										; que se ajustará automáticamente a la dirección donde se aloje
LD A, CITY_PICTURE_HEIGHT_IN_PIXELS		; Carga la altura de la imagen pegada como contador de iteraciones del bucle externo
;LD A, 8 ; PRUEBA


ld iyh, 0								; carga en IY las 8 iteraciones de la misma línea
ld iyl, 8								; carga en IY las 8 iteraciones de la misma línea
push hl									; preserva hl en ix
pop ix									; preserva hl en ix

load_screen_loop:

LD BC, CITY_PICTURE_WIDTH_IN_CHARACTERS ; Carga la anchura de la imagen pegada como contador de iteraciones del bucle interno
PUSH HL									; preserva HL en la pila
PUSH DE									; preserva DE en la pila
LDIR									; realiza el bucle interno
; LDIR = Repetir LDI hasta que BC valga 0
;     = Repetir:
;          Copiar [HL] en [DE]
;          DE=DE+1
;          HL=HL+1
;          BC=BC-1
;       Hasta que BC = 0
POP DE
;LD BC, CITY_PICTURE_HORIZONTAL_OFFSET_IN_CHARACTERS

; Postprocesamiento de DE -> Se le hace nextscan para ir a la siguiente línea
;ADD HL, BC
EX DE, HL
EX AF, AF'
CALL NextScan
;ADD HL, BC
EX AF, AF'
EX DE, HL

; Postprocesamiento de HL

dec iyl									; decrementa el contador de las iteraciones que corresponden a las 8 scanlines de una fila
EX AF, AF'								; preserva AF en el registro alternativo
ld a, iyl								; carga en A el contador de iteraciones 
or a									; comparar con 0
EX AF, AF'								; restaurar AF con el registro alternativo
jr nz, continuar_postprocesamiento		; si no es 0, continuar pasando scanlines

ld iyh, 0								; carga en IY las 8 iteraciones de la misma línea
ld iyl, 8								; carga en IY las 8 iteraciones de la misma línea

pop hl									;$8824
push ix
pop hl

ex af,af'
ld a, l
add a, 32
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; AQuÍ PASAR DE TERCIO CUANDO HAGA FALTA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ld l, a
ex af, af'
push hl
pop ix

jr fin_postprocesamiento

continuar_postprocesamiento:
pop hl									;$8833
inc h
fin_postprocesamiento:

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