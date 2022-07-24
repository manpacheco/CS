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


;;; call Restablecer_valores_por_defecto_recuadros
;;; LD HL, CurrentCity
;;; LD A, (HL)
;;; INC A
;;; LD (HL), A
;;; 
;;; call Restablecer_valores_por_defecto_recuadros
;;; CALL Pinta_pantalla_juego
;;; CALL Pinta_imagen_ciudad

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
;call Hacer_scroll_papel_impresora
;;;; ; ; ; call Restablecer_valores_por_defecto_recuadros
;;;; ; ; ; LD HL, CurrentCity
;;;; ; ; ; LD A, (HL)
;;;; ; ; ; dec A
;;;; ; ; ; LD (HL), A
;;;; ; ; ; 
;;;; ; ; ; call Restablecer_valores_por_defecto_recuadros
;;;; ; ; ; CALL Pinta_pantalla_juego
;;;; ; ; ; CALL Pinta_imagen_ciudad
;jr ScanFinally

; ##########################################################
; ###################     RIGHT       ######################
; ##########################################################
ScanRight:
ld bc, ROW_YUIOP			; en BC se carga la dirección completa donde está la fila del teclado
in a,(c)					; a la instrucción IN solo se le pasa la parte explicitamente el registro C porque la parte que está en el registro B ya está implícita
rra							; nos quedamos con el valor del bit más bajo
jr c, ScanLeft				; si hay carry significa que la tecla no estaba pulsada

ld hl, Cursor_max
ld b, (hl)
ld hl, Cursor
ld a, (hl)
;cp 3
cp b
jr nc, ScanFinally
inc a
ld (hl), a
halt
call Pinta_menu


;;;; CALL FUNCION RIGHT
;jr ScanFinally

; ##########################################################
; ###################     LEFT       #######################
; ##########################################################
ScanLeft:
ld bc, ROW_YUIOP			; en BC se carga la dirección completa donde está la fila del teclado
in a,(c)					; a la instrucción IN solo se le pasa la parte explicitamente el registro C porque la parte que está en el registro B ya está implícita
bit 1,a						; nos quedamos con el valor del 2º bit más bajo
jr nz, ScanFire				; si no es cero significa que la tecla no estaba pulsada

ld hl, Cursor
ld a, (hl)

cp 2
jr c, ScanFinally
dec a
ld (hl), a
halt
call Pinta_menu

;;;; CALL FUNCION LEFT

; ##########################################################
; ###################     FIRE       #######################
; ##########################################################
ScanFire:
LD BC, ROW_BNM_SymbolShift_Space
IN A, (C)
RRA
JR C, NothingPressed

;LD HL, (Current_menu)
LD HL, Current_menu
LD A, (HL)
deinteres:
CP Menu_principal
JR NZ, No_es_menu_principal
;; SI MENU ES MENU PRINCIPAL


LD HL, Cursor
LD A,(HL)
CP 3
CALL Z, ArrestTron
CP 2
CALL Z, Enquire
CP 1
CALL Z, Depart
JR ScanFinally

No_es_menu_principal:
CP Menu_departures
JR NZ, ScanFinally ;; SI MENU NO ES MENU DE VUELOS -> SALTA A SIGUIENTE ( O FINAL)
;; SI MENU ES MENU DE VUELOS
;; SI LA CIUDAD ES LA MISMA -> NO SE CAMBIA DE CIUDAD
;; SI LA CIUDAD ES DISTINTA -> SE CAMBIA DE CIUDAD -> (opcional) sonido -> (opcional) trayecto en mapa


CALL Refresh_city

NothingPressed:

ScanFinally:
RET

; ##########################################################
; ###############     PressAnyKey       ####################
; ###############     Sobreescribe HL, AF, AF'   ###########
; ##########################################################
; Espera a que se pulse una tecla y además devuelve un numero random en AF'

PressAnyKey:
ld hl,23560         			; LAST K system variable.
ld (hl),0           			; put null value there.
PressAnyKeyLoop:			
ex af,af'
inc a
ex af, af'
ld a,(hl)           			; new value of LAST K.
cp 0                			; is it still zero?
jr z,PressAnyKeyLoop			; yes, so no key pressed.
RET                 			; key was pressed.