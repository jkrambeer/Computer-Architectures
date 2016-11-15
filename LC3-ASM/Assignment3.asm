; Joseph Krambeer
; ENGR 330
; Assignment 3
; This program used to calculate the first COUNT fibonacci numbers and store
; them starting at memory address START

; The fibonacci numbers are defined as fib(1)=1, fib(2)=1, fib(n)=fib(n-1)+fib(n-2)

; Register use:
; R0 is used to hold the previous fib. number (i-1)
; R1 is used to hold the current fib. number (i)
; R2 is used to hold the next fib. number (i+1)
; R3 starts at the value of COUNT and decrements each loop to ensure COUNT iterations
; R4 starts at the value of START, and is used to indicate where the next fib. number 
;    should be stored and increments after each time it is used to store a fib. number
; 
; Calculation of fib. numbers based on the following idea:
; fib(1) = 1;
; prev=0, current=1, next=0;
; for(i=2;i<=COUNT;i++){
;	next = prev + current;
;	fib(i) = next;
;	prev = current;
;	current = next;
; }

	.ORIG x3000
	
	; Initializing registers and storing the first fib. number

	AND R0, R0, #0 ; R0 = 0
	AND R1, R1, #0 ; R1 = 0
	AND R2, R2, #0 ; R2 = 0
	ADD R1, R1, #1 ; R1 = 1, set current fib. number as 1
	LD  R3, COUNT  ; R3 = COUNT
	LD  R4, START  ; R4 = START 	
		       ; R4 is used as a pointer to the location to store the next fib. number
	
	; Storing of initial one of fib. series

	STR R1, R4, #0 ; Store initial 1 of series at location of pointed to by R4 (START's value)
	ADD R4, R4, #1 ; R4 = R4 + 1, Increment memory pointer
	ADD R3, R3, #-1; R3 = R3 - 1, Decrement loop counter

	; This next part is used to loop through and calculate the next COUNT-1 fib. numbers
	; by adding the current (i) fib number to the previous fib number (i-1) to get the next
	; fib number (i+1) and store the next fib number at where R4 points and then increment
	; where R4 points by one spot and decrement R3 and stop when R3 is zero

FIB	BRZ DONE       ; If R3 is zero, go to DONE
	ADD R2, R1, R0 ; R2 = R1 + R0 (Next = current + previous)
	STR R2, R4, #0 ; Store the next fib. number in memory
	ADD R4, R4, #1 ; Increment memory pointer, 
	ADD R0, R1, #0 ; R0 = R1, set previous fib number to current fib. number
	ADD R1, R2, #0 ; R1 = R2, set current fib number equal to fib. number that was just calculated
	ADD R3, R3, #-1; Decrement COUNT, sets conditions
	BR  FIB        ; Repeat FIB loop

DONE	BR  DONE ; Used to indicate program is done

	; Constants declaration
COUNT	.FILL 45    ; Used to dictate how many fib. numbers should be calculated
START	.FILL x5000 ; Used to dictate where to start storing the values in memory
	.END

