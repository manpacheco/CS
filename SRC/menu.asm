Menu_principal		EQU 1
Menu_departures		EQU 2
Menu_cpu 			EQU 3
Menu_pistas 		EQU 4

;########################################################################################################
;##################################### Pinta_menu #######################################################
;########## pinta el menú dependiendo de cual es el actual                                  #############
;########## Parámetros: Current_menu (variable)												#############
;########## Usa: AF, HL																		#############
;########################################################################################################
Pinta_menu:
LD HL, Current_menu
LD A, (HL)
CP 0
RET Z
CP Menu_principal
JR NZ, pinta_menu_continuar_2
CALL Restablecer_valores_por_defecto_recuadros
CALL Pinta_boton_Elegir_destino		; Pinta el botón con el avión
CALL Pinta_boton_Lupa				; Pinta el boton de la lupa para las pistas
CALL Pinta_boton_Ordenador			; Pinta el boton del ordenador para la orden de arresto
CALL PintaCursor
pinta_menu_continuar_2:
CP Menu_departures
JR NZ, pinta_menu_continuar_3
CALL Pinta_ciudad_origen
CALL Pinta_ciudades_destino
pinta_menu_continuar_3:
RET