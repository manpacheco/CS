UNZIPPED_SCREEN_ADDRESS EQU 57344;+2176  ; 32 de prueba; EL VALOR Válido para la primera fila 
UNZIPPED_ATTRIBUTES_ADDRESS EQU UNZIPPED_SCREEN_ADDRESS+6144 
LIVE_SCREEN_ADDRESS EQU 16384
LIVE_ATTRIBUTES_ADDRESS EQU 22528
CITY_PICTURE_WIDTH_IN_CHARACTERS EQU 10 ; 10 characters
CITY_PICTURE_HEIGHT_IN_CHARACTERS EQU 12 ; 12 characters
CITY_PICTURE_WIDTH_IN_PIXELS EQU CITY_PICTURE_WIDTH_IN_CHARACTERS*8 ; 80
CITY_PICTURE_HEIGHT_IN_PIXELS EQU CITY_PICTURE_HEIGHT_IN_CHARACTERS*8 ; 96

;#####################################################################################################
;#####				load_screen
;#####################################################################################################

;; A: Y pixels shift down
;; C: X Characters shift left

load_screen:
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

ld hl, Aux_screen_horizontal_offset
ld a, (hl)
LD HL, UNZIPPED_SCREEN_ADDRESS			; Como base de la dirección de lectura se usa la constante UNZIPPED_SCREEN_ADDRESS
ADD A, L
LD L, A
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
jr nc, suma_32_sin_carry

ld a, h
add a, 8
ld h, a
;;; ld l,0
exx
ld hl, Aux_screen_horizontal_offset
ld l,(hl)
push hl
exx
push bc
pop bc
pop bc
ld l,c

;ld l,10 ;;; TODO -AJUSTAR OFFSET-
jr fin_suma_32

suma_32_sin_carry:
ld l, a
fin_suma_32:
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

ret

;#####################################################################################################
;#####				Copiar_atributos
;#####################################################################################################

;; A: Y characters shift down
;; C: X Characters shift left

Copiar_atributos:

LD IYL, CITY_PICTURE_HEIGHT_IN_CHARACTERS		; Carga en IYL la altura de la imagen en caracteres
LD B,0											; Carga 0 en B
LD HL, LIVE_ATTRIBUTES_ADDRESS					; Carga en HL la dirección de la zona de los atributos de la pantalla
ADD HL, BC										; Suma a HL los caracteres de desplazamiento a la izquierda

LD B, A											; Carga en B el parámetro del número de caracteres de desplazamiento hacia abajo
OR A											; OR para comparar A con 0
JR Z, fin_mini_bucle							; Si es 0 entonces salta a la etiqueta
mini_bucle:										 
LD DE, 32										; Carga 32 en DE
ADD HL, DE										; Suma 32 a HL (con la dirección de los atributos)
DJNZ mini_bucle									; Si hay más caracteres que desplazar hacia abajo, salta a nueva iteración
fin_mini_bucle:

; OFFSET HORIZONTAL
EXX 											; Intercambia BC, DE, HL con sus alternativos
EX AF, AF'										; Intercambia AF con su alternativo
LD HL, Aux_screen_horizontal_offset				; Carga en HL la dirección del offset horizontal de la pantalla auxiliar
LD DE, UNZIPPED_ATTRIBUTES_ADDRESS				; Carga en DE la dirección de los atributos en la pantalla auxiliar
LD E, (HL)										; Carga en E el offset horizontal de la pantalla auxiliar

; OFFSET VERTICAL
LD HL, Aux_screen_vertical_offset				; Carga en HL la dirección del offset vertical
LD A, (HL)										; Carga en el registro A el valor del offset vertical
OR A											; operación OR de comparación
JR Z, Fin_offset_vertical						; si el registro A es 0, salta y no hagas offset vertical
INC D											; suma 1 a la parte alta de la dirección de los atributos auxiliares, es decir, suma 256 al valor de 16 bits
ADD A, E										; añade 128 a la parte baja de la dirección de los atributos auxiliares 
LD E, A											; Carga en la parte baja de la dirección de los atributos auxiliares el valor calculado para la zona inferior
Fin_offset_vertical:

PUSH DE											; Preserva el registro DE en la pila
EXX												; Intercambia BC, DE, HL con sus alternativos
EX AF, AF'										; Intercambia AF con su alternativo
POP DE											; Recupera el registro DE de la pila

EX DE,HL										; DE (con la dirección y el offset horizontal de los atributos) pasa a ser HL (que será origen)
												; HL (con la dirección de los atributos de pantalla real con sus dos offsets) pasa a ser DE (que será destino)

iteracion_copiar_atributos:
LD B,0
LD C, CITY_PICTURE_WIDTH_IN_CHARACTERS
PUSH HL
PUSH DE
LDIR											; REALIZA EL BUCLE INTERNO
												; LDIR = REPETIR LDI HASTA QUE BC VALGA 0
												;     = REPETIR:
												;          COPIAR [HL] EN [DE]
												;          DE=DE+1
												;          HL=HL+1
												;          BC=BC-1
												;       HASTA QUE BC = 0
POP DE
POP HL 

LD BC, 32
EX DE, HL
ADD HL, BC
EX DE, HL
ADD HL, BC
DEC IYL
JR NZ, iteracion_copiar_atributos

RET

; NextScan. https://wiki.speccy.org/cursos/ensamblador/gfx2_direccionamiento
; Obtiene la posición de memoria correspondiente al scanline siguiente al indicado.
; 010T TSSS LLLC CCCC
; Entrada: HL -> scanline actual.
; Salida: HL -> scanline siguiente.
; Altera el valor de los registros AF y HL.
; -----------------------------------------------------------------------------
NextScan:
INC H											; Incrementa H para incrementar el scanline
LD A, H											; Carga el valor en A
AND $07											; Se queda con los bits del scanline
RET NZ											; Si el valor no es 0, fin de la rutina

; Calcula la siguiente línea
LD A, L 										; Carga el valor en A
ADD A, $20										; Añade 1 a la línea (%0010 0000)
LD L, A											; Carga el valor en L
RET C											; Si hay acarreo, ha cambiado de tercio,

; que ya viene ajustado de arriba. Fin de la rutina

; Si llega aquí, no ha cambiado de tercio y hay que ajustar
; ya que el primer inc h incrementó el tercio
LD A, H 										; Carga el valor en A
SUB $08 										; Resta un tercio (%0000 1000)
LD H, A											; Carga el valor en H
RET

;#####################################################################################################
;#####				Pinta_imagen_ciudad
;#####################################################################################################
Pinta_imagen_ciudad:
LD HL, Aux_screen_horizontal_offset
;ld (hl), 20
LD (HL), 20

LD HL, Aux_screen_vertical_offset
;ld (hl), 20
LD (HL), 128

LD A, 88
LD C, 3
CALL load_screen
LD A, 11
LD C, 3
CALL Copiar_atributos
RET