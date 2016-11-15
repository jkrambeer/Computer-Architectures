; Joseph Krambeer
; Assignment 4 
; Part C
; Implementing an LC3 FACT function
; with recursion

;---------------
; Part C
;---------------

	; Test program for FACT of 1 through 7, has expected results stored in memory
	; and puts actual results next to the expected to verify that the FACT(N) 
	; actually produces the correct output

	.orig x3000
	LD  R6, STACK   ; Load starting stack address into R6 the stack pointer
	AND R1, R1, #0  ; Load R1 with value of zero to load other registers with
			; literal values
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
	ADD R0, R1, #7 ; Load R0 with 7
	ADD R1, R1, #11; Load R1 with value of 11 to make sure its
		           ; value isn't cleared by this call to FACT
	JSR FACT       ; Call FACT function with value of R0
	ST  R0, RES7   ; Store result of function in results

DONE	BR DONE ; Loop to end program

; FACT function (recursive)
; The use of this function is to calculate the factorial of N 
; -Register use:
; *R0 is the only parameter to function, is used as parameter to call MULT
;  (the FACT(N-1) part of the multiplication), is used to hold the result of MULT, 
;  and is the return value of FACT
; *R1 is used as a parameter to MULT (the N part of the multiplication), recieves
;  value stored in R2 to use as the current N for the call to MULT
; *R2 is used to hold the value of N at each level of the function during the
;  call to FACT(N-1) and then is used to give R1 the current value of N to call MULT with

FACT	
    ADD  R0, R0, #0 ; Set conditions based on value of R0 
	BRp  RECUR	; If R0 > 0, then go to recursive part of function
			; else carry on and return value of 1
	
	; Part for if N <= 0 then return 1 
	AND R0, R0, #0 ; Clear R0
	ADD R0, R0, #1 ; Set R0 to 1
	RET	       ; Return value of 1

	; Part for if N > 0 then return N * FACT(N-1)
RECUR	
    STR R7, R6, #0 ; Push R7 onto the stack storing
	ADD R6, R6, #-1; the return address of this function
	STR R1, R6, #0 ; Push R1 onto the stack
	ADD R6, R6, #-1; storing its value
	STR R2, R6, #0 ; Push R2 onto the stack
	ADD R6, R6, #-1; storing its value

	ADD R2, R0, #0 ; R2 = R0, store value of N as subsequent calls to FACT also
		           ; call MULT which can clear the value in R1, so save it in R2
	ADD R0, R0, #-1; R0 = R0 - 1, decrement value of N for recursive call
	JSR FACT       ; Call FACT recursively, with result stored in R0
	ADD R1, R2, #0 ; R1 = R2, store value of N as parameter to MULT function
	JSR MULT       ; Call MULT with result of result of FACT call in R0 
		           ; and current value of N stored in R1, (N*FACT(N-1))

	ADD R6, R6, #1; Pop R2 off of stack
	LDR R2, R6, #0; restoring its value
	ADD R6, R6, #1; Pop R1 off of stack
	LDR R1, R6, #0; restoring its value
	ADD R6, R6, #1; Pop R7 off of stack
	LDR R7, R6, #0; restoring this function's return address
	RET	      ; Return value of N*FACT(N-1) to caller


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


