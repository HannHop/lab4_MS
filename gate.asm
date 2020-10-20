;Gate sensors
GT_0	EQU	P1.0
GT_1	EQU	P1.1


BSEG	AT 0
GO_INC: DBIT		1
GO_DEC:	DBIT		1

DSEG	AT 30H
;This is a rotation counter
CNT:	DS			1

CSEG	AT 0H

RESET:
	AJMP	MAIN

; -------------------------------------	
;    Your implementation starts here	
; -------------------------------------	
GATE_CTRL:	
	
IDLE1:
	JNB GT_0, R_0
	//JB GT_0, IDLE2
	
	
IDLE2:
	//JB GT_1, IDLE1
	JNB GT_1, L_0
	SJMP IDLE1
	
R_0:
	//JNB GT_1, R_1
	JB GT_1, IDLE1

	
R_1:
	JNB GT_0, R_0
	//JB GT_0, R_2


R_2:
	JB GT_1, CNT_INC
	JNB GT_1, R_1
	
L_0:
	JB GT_0, IDLE2
	//JNB GT_0, L_1


L_1:
	//JB GT_1, L_2
	JNB GT_1, L_0


L_2:
	JB GT_0, CNT_DEC
	JNB GT_0, L_1


CNT_INC:
	//JESLI CNT==255, NIC NIE ROB
	MOV A, CNT
	SUBB A, #255
	JZ IDLE1
	INC CNT
	//IDZ DO IDLE
	SJMP IDLE1

CNT_DEC:
	//JESLI CNT==0, IDZ DO IDLE
	MOV A, CNT
	JZ IDLE1
	//INACZEJ -> ODEJMIJ I IDZ DO IDLE
	DEC CNT
	//IDZ DO IDLE
	SJMP IDLE2
	
RET
;___________________

MAIN:
	MOV		SP,#7FH
	MOV		CNT,#0
RUN_GATE:	
	ACALL	GATE_CTRL
	;When reach STOP the controller is incorrectly designed
STOP:
	SJMP	STOP
	
	END