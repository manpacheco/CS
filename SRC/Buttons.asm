

;#####################################################################################################
;#####				Pinta_boton_Elegir_destino
;#####################################################################################################
Pinta_boton_Elegir_destino:
LD HL, Caracter_relleno
LD (HL),32

LD HL, Window_y_inicial
LD (HL),Buttons_y_inicial					
LD HL, Window_y_final_m_1
LD (HL),Buttons_y_final
LD HL, Window_x_inicial
LD (HL),Button_depart_x_inicial					
LD HL, Window_x_final_m_1
LD (HL),Button_depart_x_final
CALL Pinta_recuadro

LD DE, Button_depart_1_3
CALL Print_255_Terminated

LD DE, Button_depart_2_3
CALL Print_255_Terminated

LD A, 1
PUSH BC
PUSH DE
CALL ROM_OPEN_CHANNEL
POP DE
POP BC

LD DE, Button_depart_3_3
CALL Print_255_Terminated

LD A, 2
CALL ROM_OPEN_CHANNEL
RET

;#####################################################################################################
;#####				Pinta_boton_Lupa
;#####################################################################################################
Pinta_boton_Lupa:
ld hl, Window_y_final_m_1
ld (hl),Buttons_y_final
ld hl, Window_x_inicial
ld (hl),Button_lupa_x_inicial
ld hl, Window_x_final_m_1
ld (hl),Button_lupa_x_final
CALL Pinta_recuadro

LD DE, Button_lupa_1_3
CALL Print_255_Terminated

LD DE, Button_lupa_2_3
CALL Print_255_Terminated

LD A, 1
PUSH BC
PUSH DE
CALL ROM_OPEN_CHANNEL
POP DE
POP BC

LD DE, Button_lupa_3_3
CALL Print_255_Terminated

LD A, 2
CALL ROM_OPEN_CHANNEL
RET

;#####################################################################################################
;#####				Pinta_boton_Ordenador
;#####################################################################################################
Pinta_boton_Ordenador:
LD HL, Window_y_final_m_1
LD (HL),Buttons_y_final
LD HL, Window_x_inicial
LD (HL),Button_crime_x_inicial					
LD HL, Window_x_final_m_1
LD (HL),Button_crime_x_final					
CALL Pinta_recuadro

LD DE, Button_crime_1_3
CALL Print_255_Terminated

LD DE, Button_crime_2_3
CALL Print_255_Terminated

LD A, 1
PUSH BC
PUSH DE
CALL ROM_OPEN_CHANNEL
POP DE
POP BC

LD DE, Button_crime_3_3
CALL Print_255_Terminated

LD A, 2
CALL ROM_OPEN_CHANNEL
RET
