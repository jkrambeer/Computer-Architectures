; Joseph Krambeer
; Assignment 4 
; Part B
; Implementing an LC3 FACT function
; without recursion

;---------------
; Part B
;---------------

	.orig x3000
	LD  R6, STACK   ; Load starting stack address into R6 the stack pointer
	AND R1, R1, #0  ; Load R1 with value of zero to load other registers with
                    ; literal values and make sure it isn't changed by calls
                    ; to FACT function
	ADD R2, R1, #13 ; Load R2 with 13 to make sure it doesn't change during
                    ; calls to FACT functions
	; FACT(1)
	ADD R0, R1, #1; Load R0 with 1
	JSR FACT      ; Call FACT function with value of R0
	ST  R0, RES1  ; Store result of function in results

	; FACT(2)
	ADD R0, R1, #2; Load R0 with 2
	JSR FACT      ; Call FACT function with value of R0
	ST  R0, RES2  ; Store result of function in results

	; FACT(3)
	ADD R0, R1, #3; Load R0 with 3
	JSR FACT      ; Call FACT function with value of R0
	ST  R0, RES3  ; Store result of function in results

	; FACT(4)
	ADD R0, R1, #4; Load R0 with 4
	JSR FACT      ; Call FACT function with value of R0
	ST  R0, RES4  ; Store result of function in results

	; FACT(5)
	ADD R0, R1, #5; Load R0 with 5
	JSR FACT      ; Call FACT function with value of R0
	ST  R0, RES5  ; Store result of function in results

	; FACT(6)
	ADD R0, R1, #6; Load R0 with 6
	JSR FACT      ; Call FACT function with value of R0
	ST  R0, RES6  ; Store result of function in results

	; FACT(7)
	ADD R0, R1, #7; Load R0 with 7
	JSR FACT      ; Call FACT function with value of R0
	ST  R0, RES7  ; Store result of function in results

DONE	BR DONE ; Loop to end program

; FACT function (iterative)
; The use of this function is to calculate the factorial of n 
; -Register use:
; *R0 is the only parameter to function, is used as parameter to call MULT, 
;     is used to hold the result of MULT, and is the return value of FACT
; *R1 is used as a parameter to call MULT, copies value from R2 before call to MULT
; *R2 is hold the value of R0 used as the parameter to call this function and
;     is used as the counter to indicate the next value to multiply R0 with, 
;     when R2 is <= 1 the function is done calculating the factorial of n

FACT	
    STR R7, R6, #0 ; Push R7 onto the stack
	ADD R6, R6, #-1; the return address of this function
	STR R1, R6, #0 ; Push R1 onto the stack
	ADD R6, R6, #-1; saving its value
	STR R2, R6, #0 ; Push R2 onto the stack
	ADD R6, R6, #-1; saving its value

	ADD R2, R0, #0 ; Load R2 with value in R0
	AND R0, R0, #0 ; R0 = 0, Clear R0
	ADD R0, R0, #1 ; R0 = 1, Set R0 to 1
	ADD R1, R2, #-1; R1 = R2 - 1, check if R2 is <= 1

FLOOP	
    BRnz FDONE      ; If the result of R2-1 was <= 0, go to FACT's done to finish 
	ADD  R1, R2, #0 ; Load R1 with R2's value, used as parameter to MULT
	JSR  MULT       ; Call mult function with running val in R0 and val to mult by in R1
	ADD  R2, R2, #-1; R2 = R2 - 1, set conditions and decrement R2
	BR   FLOOP      ; Repeat loop

FDONE	
    ADD R6, R6, #1; Pop R2 off of stack
	LDR R2, R6, #0; restoring its value
	ADD R6, R6, #1; Pop R1 off of stack
	LDR R1, R6, #0; restoring its value
	ADD R6, R6, #1; Pop R7 off of stack
	LDR R7, R6, #0; restoring this function's return address
	RET ; Return from FACT function

; MULT function
; -Register use:
; *R0 is the first parameter to MULT, and used to hold the return value
; *R1 is the second parameter to MULT
; *R2 is a register used to hold the sum of the additions and transfer it 
;     to R0 when the function is done looping
; It should also be noted R1 is equal to 0 when this function returns
MULT	
    STR R2, R6, #0 ; Push R2 at stack pointer
	ADD R6, R6, #-1; Move stack pointer down
	AND R2, R2, #0 ; Clear R2
	ADD R1, R1, #0 ; Set condition flags based on R1's value

	; This part is used to loop R1 times and add R0 
	; to R2 each iteration
MLOOP	
    BRz MDONE      ; When R1 is zero go to the done routine finish function
	ADD R2, R2, R0 ; R2 = R2 + R0
	ADD R1, R1, #-1; R1 = R1 - 1
	BR  MLOOP      ; Repeat loop

MDONE	
    ADD R0, R2, #0; R2 = R0, set R2 to R0's value
	ADD R6, R6, #1; Move stack pointer back up
	LDR R2, R6, #0; Pop original R2 val off stack
		          ; restoring its saved value
	RET           ; return from MULT function

; Data for program

; Expected values / results for calls to FACT function
EXP1	.FILL 1
RES1	.FILL 0
EXP2	.FILL 2
RES2	.FILL 0
EXP3	.FILL 6
RES3	.FILL 0
EXP4	.FILL 24
RES4	.FILL 0
EXP5	.FILL 120
RES5	.FILL 0
EXP6	.FILL 720
RES6	.FILL 0
EXP7	.FILL 5040
RES7	.FILL 0

; Value used to indicate where to initally load the stack pointer.
; starts in highest address available to user programs
STACK	.FILL xFDFF
	.END


