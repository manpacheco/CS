BEEPER: EQU $03B5

;#####################################################################################################
;#####				Noise
;#####				Overwrite: a, b, E, HL
;#####################################################################################################
Noise:
ld e,85            ; repeat 250 times.
ld hl,0             ; start pointer in ROM.
noise2:
push de
ld b,32             ; length of step.
noise0:
push bc
ld a,(hl)           ; next "random" number.
inc hl              ; pointer.
and 248             ; we want a black border.
out (254),a         ; write to speaker.
ld a,e              ; as e gets smaller...
cpl                 ; ...we increase the delay.
noise1:
dec a               ; decrement loop counter.
jr nz,noise1        ; delay loop.
pop bc
djnz noise0         ; next step.
pop de
ld a,e
sub 24              ; size of step.
cp 30               ; end of range.
ret z
ret c
ld e,a
cpl
noise3:
ld b,40             ; silent period.
noise4:
djnz noise4
dec a
jr nz,noise3
jr noise2

;;;;;;; ; Punto anotado
;;;;;;; C_3: EQU $0d07
;;;;;;; C_3_FQ: EQU $0082 / $10 ; frecuencia
;;;;;;; 
;;;;;;; ;Pala
;;;;;;; C_4: EQU $066e
;;;;;;; C_4_FQ: EQU $0105 / $10 ; frecuencia
;;;;;;; 
;;;;;;; ;Rebote
 ;C_5: EQU $0326
 ;C_5_FQ: EQU $020B / $10 ; frecuencia
 

;;;;;;; 
;;;PlaySound:
;;;push de
;;;push hl
;;;;;;;;;; 
;;;;;;;;;; cp $01
;;;;;;;;;; jr z, playSound_point
;;;;;;;;;; 
;;;;;;;;;; cp $02
;;;;;;;;;; jr z, playSound_paddle
;;;;;;;;;; 
;;;ld de, 6
;;;ld hl, 6957
;;;push af
;;;push bc
;;;push ix
;;;call BEEPER
;;;pop ix
;;;pop bc
;;;pop af
;;;pop hl
;;;pop de
;;;ret
;;;;;;; 
;;;;;;; playSound_point:
;;;;;;; ld hl, C_4
;;;;;;; ld de, C_4_FQ
;;;;;;; jr beep
;;;;;;; 
;;;;;;; playSound_paddle:
;;;;;;; ld hl, C_3
;;;;;;; ld de, C_3_FQ
;;;;;;; jr beep


