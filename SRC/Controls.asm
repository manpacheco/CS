ROW_54321 EQU 63486
ROW_67890 EQU 61438
ROW_TREWQ EQU 64510
ROW_YUIOP EQU 57342
ROW_GFDSA EQU 65022
ROW_HJKL_Enter EQU 49150
ROW_VCXZ_CapsShift EQU 65278
ROW_BNM_SymbolShift_Space EQU 32766

ScanAllKeys:
; ##########################################################
; ####################     UP       ########################
; ##########################################################
ScanUp:
LD BC, ROW_TREWQ 			; en BC se carga la dirección completa donde está la fila del teclado
IN A,(C) 					; a la instrucción IN solo se le pasa la parte explicitamente el registro C porque la parte que está en el registro B ya está implícita
RRA 						; nos quedamos con el valor del bit más bajo
JR C, ScanDown 				; si hay carry significa que la tecla no estaba pulsada

call Restablecer_valores_por_defecto_recuadros
LD HL, CurrentCity
LD A, (HL)
INC A
LD (HL), A

call Restablecer_valores_por_defecto_recuadros
CALL Pinta_pantalla_juego
CALL Pinta_imagen_ciudad

;;;; CALL FUNCION SUBIR
; jr ScanFinally

; ##########################################################
; ###################     DOWN       #######################
; ##########################################################
ScanDown:
ld bc, ROW_GFDSA			; en BC se carga la dirección completa donde está la fila del teclado
in a,(c)					; a la instrucción IN solo se le pasa la parte explicitamente el registro C porque la parte que está en el registro B ya está implícita
rra							; nos quedamos con el valor del bit más bajo
jr c, ScanRight				; si hay carry significa que la tecla no estaba pulsada
;;;; CALL FUNCION BAJAR
;jr ScanFinally

; ##########################################################
; ###################     RIGHT       ######################
; ##########################################################
ScanRight:
ld bc, ROW_YUIOP			; en BC se carga la dirección completa donde está la fila del teclado
in a,(c)					; a la instrucción IN solo se le pasa la parte explicitamente el registro C porque la parte que está en el registro B ya está implícita
rra							; nos quedamos con el valor del bit más bajo
jr c, ScanLeft				; si hay carry significa que la tecla no estaba pulsada

;;;; CALL FUNCION RIGHT
;jr ScanFinally

; ##########################################################
; ###################     LEFT       #######################
; ##########################################################
ScanLeft:
ld bc, ROW_YUIOP			; en BC se carga la dirección completa donde está la fila del teclado
in a,(c)					; a la instrucción IN solo se le pasa la parte explicitamente el registro C porque la parte que está en el registro B ya está implícita
bit 1,a						; nos quedamos con el valor del 2º bit más bajo
jr nz, ScanFire		; si no es cero significa que la tecla no estaba pulsada

;;;; CALL FUNCION LEFT

; ##########################################################
; ###################     FIRE       #######################
; ##########################################################
ScanFire:
ld bc, ROW_BNM_SymbolShift_Space
in a, (c)
rra
jr c, NothingPressed


JR ScanFinally

NothingPressed:

ScanFinally:

RET