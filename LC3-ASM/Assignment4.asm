; Joseph Krambeer
; Assignment 4 
; Part A
; Implementing an LC3 MULT function

;---------------
; Part A
;---------------

; PUSH
; STR R#, R6, #0
; ADD R6, R6, #-1

; POP
; ADD R6, R6, #1
; LDR R#, R6, #0

	; Test code for MULT function
	; -Register use:
	; *R0 is the first argument to MULT
	; *R1 is the second argument to MULT
	; *R2 is an arbitrary value used to ensure MULT doesn't change
	;     this register's content after the MULT function is finished
	; *R3 is used to load the value of -1649 to compare to the result 
	;     of MULT(17,97) to check if the right result was obtained
	; *R6 is the stack pointer
	; *R7 is used to hold return addresses

	.orig x3000
	LD R6, STACK; Load starting stack address into R6 the stack pointer
	LD R2, R2Val; Load R2 with abritrary value to make sure it isn't
		    ; changed by calls to MULT

	; 3 x 5 
	LD   R0, VAL3    ; Load R0 with 3
	LD   R1, VAL5    ; Load R1 with 5
	JSR  MULT        ; Call subroutine MULT 
	ST   R0, RESULT1 ; Store result in RESULT1
	ADD  R0, R0, #-15; Test R0 minus expected result to set conditions	
	BRnp FAIL1; If (R0-15)!=0, then the two values differed, so MULT failed

	; 0 x 7
	LD   R0, VAL0   ; Load R0 with 0
	LD   R1, VAL7   ; Load R1 with 7
	JSR  MULT       ; Call subroutine MULT
	ST   R0, RESULT2; Store result in RESULT2
	ADD  R0, R0, #0 ; Test R0 minus expected result to set conditions	
	BRnp FAIL2; If (R0-0)!=0, then the two values differed, so MULT failed

	; 7 x 0
	LD   R0, VAL7   ; Load R0 with 7
	LD   R1, VAL0   ; Load R1 with 0
	JSR  MULT       ; Call subroutine MULT
	ST   R0, RESULT3; Store result in RESULT3
	ADD  R0, R0, #0 ; Test R0 minus expected result to set conditions	
	BRnp FAIL3; If (R0-0)!=0, then the two values differed, so MULT failed 

	; 97 x 17
	LD   R0, VAL97  ; Load R0 with 97
	LD   R1, VAL17  ; Load R1 with 17
	JSR  MULT       ; Call subroutine MULT
	ST   R0, RESULT4; Store result in RESULT4
	LD   R3, VALBIG ; Load R3 with -1649
	ADD  R0, R0, R3 ; Test R0 minus expected result to set conditions	
	BRnp FAIL4; If (R0-1649)!=0, then the two values differed, so MULT failed 

	; No failures, all tests passed
	BR   SUCCESS

; Used to indicated failed tests
FAIL1	BR FAIL1
FAIL2	BR FAIL2
FAIL3	BR FAIL3
FAIL4	BR FAIL4

; Used to indicate all tests passed
SUCCESS	BR SUCCESS
	

; Implemented by summing value of R0 value of R1 times 
; into R2 and then putting value of R2 into R0 at end
; -Register use:
; *R0 is the first parameter to MULT, and used to hold the return value
; *R1 is the second parameter to MULT
; *R2 is a register used to hold the sum of the additions and transfer it 
;     to R0 when the function is done looping

MULT	STR R2, R6, #0 ; Push R2 at stack pointer
	ADD R6, R6, #-1; Move stack pointer down
	AND R2, R2, #0 ; Clear R2
	ADD R1, R1, #0 ; Set condition flags based on R1's value

	; This part is used to loop R1 times and add R0 
	; to R2 each iteration
LOOP	BRz DONE       ; When R1 is zero go to the done routine finish function
	ADD R2, R2, R0 ; R2 = R2 + R0
	ADD R1, R1, #-1; R1 = R1 - 1
	BR LOOP        ; Repeat loop

DONE	ADD R0, R2, #0; R2 = R0, set R2 to R0's value
	ADD R6, R6, #1; Move stack pointer back up
	LDR R2, R6, #0; Pop original R2 val off stack
		      ; restoring its saved value
	RET           ; return from MULT function
	
; Data for test program
R2Val	.FILL 1234 ; Arbitrary value put into R2 to make sure it doesn't change
		   ; as a side effect of MULT function call

; Values used load registers with parameters for MULT
VAL0	.FILL 0	
VAL3	.FILL 3	
VAL5	.FILL 5	
VAL7	.FILL 7	
VAL17	.FILL 17	
VAL97	.FILL 97

; Values used to hold the result of the multiplications
RESULT1 .FILL -1
RESULT2 .FILL -1
RESULT3 .FILL -1
RESULT4 .FILL -1

; Value used to compare to the result of 97x17 (1649)
VALBIG  .FILL -1649

; Value used to indicate where to initally load the stack pointer
STACK	.FILL xffff
	.END


