UNZIPPED_SCREEN_ADDRESS EQU 57344 ;$E000
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
;; IYL si es 0 fila de arriba, >0 fila de abajo

load_screen:
; offset horizontal en destino
LD B,0									; Se descarta la parte alta de BC
LD HL, LIVE_SCREEN_ADDRESS				; Se carga en el registro HL la dirección de la memoria de video que hace de base de destino
ADD HL, BC								; Se le suman a la dirección de la memoria de vídeo los caracteres de offset en horizontal (en el registro C)

; offset vertical en destino
baja_una_scanline:
OR A									; examina el registro A
JR z,no_bajar_mas						; si es 0, entonces deja de iterar	
EX AF,AF'								; preserva AF en el registro alternativo AF´
CALL NextScan							; machaca con la siguiente scanline
EX AF,AF'								; restaura AF que estaba guardado en el registro alternativo AF´
DEC A									; decrementa el contador en A
JR baja_una_scanline					; siguiente iteración
no_bajar_mas:

; EMPIEZA LA COPIA DE MEMORIA A MEMORIA
EX DE, HL								; Después de haber sumado con HL se pone la dirección destino ajustada en DE
LD HL, Aux_screen_horizontal_offset		; Se carga en HL la dirección de offset horizontal de origen
LD A, (HL)								; Carga en A el offset horizontal de origen
LD HL, UNZIPPED_SCREEN_ADDRESS			; Como base de la dirección de lectura se usa la constante UNZIPPED_SCREEN_ADDRESS
ADD A, L								; Suma a la dirección de lectura el offset horizontal de origen

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SEGUIR POR AQUÍ ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EX AF, AF'							;Preserva AF en el alternativo
LD A, IYL							; Carga en el registro A el valor de YHL (que contiene el parámetro)
OR A								; Es 0?
JR Z, SIN_AJUSTE_MITAD_TERMINADO	; Si es cero, no hagas nada y salta
; TESTS
EX AF, AF'								; Restaura AF desde el alternativo
ADD A, 128								; Si no es 0, habrá que sumar las el offset de mitad de pantalla
										; 12 filas * 8 scanlines * 32 columnassuma 128 al registro A que irá a la parte baja
; FIN TESTS								; 1152= 100 (8) en H y 1000 0000 (128) en L

LD L, A									; Lleva el resultado a la parte baja de HL
; TESTS
LD A, H									; Carga en el registro A la parte alta de la dirección (en HL)
ADD A, 8								; le suma 8 a la parte alta (para avanzar al siguiente tercio de pantalla)
LD H, A									; carga en la parte alta el resultado que queda en el registro A
; FIN TESTS
JR AJUSTE_MITAD_TERMINADO
SIN_AJUSTE_MITAD_TERMINADO:
EX AF, AF'								; Restaura AF desde el alternativo
LD L, A									; Lleva el resultado a la parte baja de HL
AJUSTE_MITAD_TERMINADO:

									
LD A, CITY_PICTURE_HEIGHT_IN_PIXELS		; Carga en el registro A la altura de la imagen pegada como contador de iteraciones del bucle externo

LD IYH, 0								; carga en IY las 8 iteraciones de la misma línea
LD IYL, 8								; carga en IY las 8 iteraciones de la misma línea
PUSH HL									; preserva HL en ix
POP IX									; preserva HL en ix

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
EX DE, HL								; mete el registro DE en Hl para que sirva como entrada
EX AF, AF'								; preserva AF en el registro alternativo
CALL NextScan							; baja una línea el puntero en HL
EX AF, AF'								; restaura AF desde el registro alternativo
EX DE, HL								; mete la dirección incrementada de vuelta a DE

; Postprocesamiento de HL
DEC IYL									; decrementa el contador de las iteraciones que corresponden a las 8 scanlines de una fila
EX AF, AF'								; preserva AF en el registro alternativo
LD A, IYL								; carga en A el contador de iteraciones 
OR A									; comparar con 0
EX AF, AF'								; restaurar AF con el registro alternativo
JR NZ, continuar_postprocesamiento		; si no es 0, continuar pasando scanlines

; Restaura el contador de las 8 iteraciones
LD IYH, 0								; carga en IY las 8 iteraciones de la misma línea
LD IYL, 8								; carga en IY las 8 iteraciones de la misma línea

										; posible dirección de memoria $8824
POP HL									; restaura HL en la pila del comienzo de la iteración
PUSH IX									; se pone IX en la pila
POP HL									; y se carga en HL para poder operar con él

EX AF,AF'								; Preserva AF en el registro alternativo
LD A, L									; Carga en A la parte menos significativa de HL
ADD A, 32								; le suma 32 (una fila de pantalla)
JR NC, suma_32_sin_carry				; si no se produce carry, salta

LD A, H									; Ha habido carry, entonces carga en A la parte más significativa de HL
ADD A, 8								; le suma 8 (cambia al siguiente tercio)
LD H, A									; fija el valor de H al resultado anterior con el tercio avanzado
EXX										; preservar registros en alternativos
LD HL, Aux_screen_horizontal_offset		; carga en HL el puntero al offset horizontal de origen
LD L,(HL)								; carga en L el valor
PUSH HL									; mete el valor de HL en la pila
EXX										; restaura todos los registros
POP BC									; pasa el valor del puntero con el offset que estaba en la pila al registro BC
LD L,C									; mete la parte menos significativa del puntero en HL
JR fin_suma_32							; salta para no sobreescribir L

suma_32_sin_carry:
LD L, A									; No se ha producido carry, carga la parte baja del puntero con el 32 añadido en la parte baja de HL
fin_suma_32:
EX AF, AF'								; Restaura AF desde el registro alternativo
PUSH HL									; Se pone HL en la pila
POP IX									; Se carga en el registro IX
JR fin_postprocesamiento				; salta al final

continuar_postprocesamiento:			;$8833
POP HL									; Recupera del valor de HL
INC H									; Incrementa la parte alta (avanza una scanline)
fin_postprocesamiento:

DEC A									; Decrementa A
OR A									; OR de comparación
JR NZ, load_screen_loop					; Si no es 0, continúa iterando

ret

;#####################################################################################################
;#####				Copiar_atributos
;#####################################################################################################

;; A: Y characters shift down (en destino)
;; C: X Characters shift left (en destino)

Copiar_atributos:

LD IYL, CITY_PICTURE_HEIGHT_IN_CHARACTERS		; Carga en IYL la altura de la imagen en caracteres

; OFFSET HORIZONTAL EN DESTINO
LD B,0											; Carga 0 en B
LD HL, LIVE_ATTRIBUTES_ADDRESS					; Carga en HL la dirección de la zona de los atributos de la pantalla
ADD HL, BC										; Suma a HL los caracteres de desplazamiento a la izquierda

; OFFSET VERTICAL EN DESTINO
LD B, A											; Carga en B el parámetro del número de caracteres de desplazamiento hacia abajo
OR A											; OR para comparar A con 0
JR Z, fin_mini_bucle							; Si es 0 entonces salta a la etiqueta
mini_bucle:										 
LD DE, 32										; Carga 32 en DE
ADD HL, DE										; Suma 32 a HL (con la dirección de los atributos)
DJNZ mini_bucle									; Si hay más caracteres que desplazar hacia abajo, salta a nueva iteración
fin_mini_bucle:

; OFFSET HORIZONTAL EN ORIGEN
EXX 											; Intercambia BC, DE, HL con sus alternativos
EX AF, AF'										; Intercambia AF con su alternativo
LD HL, Aux_screen_horizontal_offset				; Carga en HL la dirección del offset horizontal de la pantalla auxiliar
LD DE, UNZIPPED_ATTRIBUTES_ADDRESS				; Carga en DE la dirección de los atributos en la pantalla auxiliar
LD E, (HL)										; Carga en E el offset horizontal de la pantalla auxiliar

; OFFSET VERTICAL EN ORIGEN
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
LD B,0											; Descarta la parte alta de BC
LD C, CITY_PICTURE_WIDTH_IN_CHARACTERS			; Mete en BC el número de iteraciones (igual a la anchura en caracteres)
PUSH HL											; Preserva la dirección de origen de los datos en la pila
PUSH DE											; Preserva la dirección de destino de los datos en la pila
LDIR											; REALIZA EL BUCLE INTERNO
												; LDIR = REPETIR LDI HASTA QUE BC VALGA 0
												;     = REPETIR:
												;          COPIAR [HL] EN [DE]
												;          DE=DE+1
												;          HL=HL+1
												;          BC=BC-1
												;       HASTA QUE BC = 0
POP DE											; Restaura en DE la dirección de destino de los datos desde la pila
POP HL											; Restaura en HL la dirección de origen de los datos desde la pila

LD BC, 32										; Carga 32 en el registro BC
EX DE, HL										; Intercambia HL y DE (origen y destino) para poder realizar la suma con HL
ADD HL, BC										; suma 32 al registro HL (una fila de atributos) que ahora contiene el destino
EX DE, HL										; Vuelve a intercambia HL y DE (origen y destino) y se quedan en su sitio original
ADD HL, BC										; suma 32 al registro HL (una fila de atributos) que ahora contiene el origen
DEC IYL											; Decrementa YHL que lleva la cuenta del número de iteraciones (originalmente la altura en caracteres)
JR NZ, iteracion_copiar_atributos				; Si el contador no es cero, salta a una nueva iteración

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
LD HL, CurrentCity
LD A, (HL)

LD DE, Pantalla
CP 7
JR C, FinSaltosPantalla
LD DE, Pantalla0712
CP 13
JR C, FinSaltosPantalla
LD DE, Pantalla1318
CP 19
JR C, FinSaltosPantalla
LD DE, Pantalla1924
CP 25
JR C, FinSaltosPantalla
LD DE, Pantalla2530  

FinSaltosPantalla:
EX DE, HL
LD    DE, UNZIPPED_SCREEN_ADDRESS
call dzx0_standard

LD HL, CurrentCity
LD A, (HL)
LD HL, Aux_screen_vertical_offset
DEC A

MODULO_CURRENT_CITY:
CP 6
JR C, FIN_MODULO_CURRENT_CITY
SUB 6
JR MODULO_CURRENT_CITY
FIN_MODULO_CURRENT_CITY:

CP 3
JR NC, Fila_inferior
LD (HL), 0
JR Selecciona_columna
Fila_inferior:
LD (HL), 128
SUB 3


Selecciona_columna:
LD HL, Aux_screen_horizontal_offset
CP 2
JR Z, Columna_20
CP 1
JR Z, Columna_10
JR Columna_0
Columna_20:
LD (HL), 20
JR Fin_seleccion_columna
Columna_10:
LD (HL), 10
JR Fin_seleccion_columna
Columna_0:
LD (HL), 0
Fin_seleccion_columna:

LD HL, Aux_screen_vertical_offset
LD A, (HL)
LD IYL, A

LD A, 88
LD C, 3

CALL load_screen
LD A, 11
LD C, 3
CALL Copiar_atributos
RET