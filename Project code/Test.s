;;; Directives
	PRESERVE8
	THUMB ; Marks the THUMB mode of operation
		
		

Stack EQU 	0x00000100 ; Define stack size to be 256 bytes
	
	; Allocate space for the stack.
	AREA STACK, NOINIT, READWRITE, ALIGN=3
StackMem SPACE Stack
	
	; Initialize the two enteries of vector table.
	AREA RESET, DATA, READONLY
	EXPORT __Vectors
		

__Vectors
	DCD StackMem + Stack ; stack pointer value when stack is empty
	DCD Reset_Handler	 ; reset vector
		
		
	ALIGN
		
		
	AREA Strings, DATA, READONLY ; Declaring the two sentences.	
String1 DCB "HELLO WORLD",0
String2 DCB "Bye World",0

	AREA Texts, DATA, READWRITE
TEX1 SPACE 20
TEX2 SPACE 20
Count1 SPACE 1
Count2 SPACE 1
COMMON SPACE 1
ENCRYPT1 SPACE 20
ENCRYPT2 SPACE 20
		
;;;;;;;;;;;;; The user code (program) is placed in the CODE AREA.

	AREA |.text|, CODE, READONLY, ALIGN = 2
	ENTRY   ; Marks the starting point of the code execution
	EXPORT  Reset_Handler
		
		
Reset_Handler
; User code starts from the next line.


__main 
	
	;;;;;;;;;;; TO SEARCH IN MEMORY FOR THE RESULTS ;;;;;;;;;;;
	
	; String1 address is 0x00000108 (N bytes where N is length of the string)
	; String2 address is 0x00000114 (N bytes where N is length of the string)
	; TEX1 address is 0x20000000 (20 bytes allocated can be modified to store larger strings)
	; TEX2 address is 0x20000014 (20 bytes allocated can be modified to store larger strings)
	; Count1 address is 0x20000028 (1 byte)
	; Count2 address is 0x20000029 (1 byte)
	; COMMON address is 0x2000002A (1 byte)
	; ENCRYPT1 address is 0x2000002B (20 bytes allocated can be modified to store larger strings)
	; ENCRYPT2 address is 0x2000003F (20 bytes allocated can be modified to store larger strings)
	
	LDR R0, = TEX1 ; using the procedure TO_SMALL to convert the String1 to small letters and store it in TEX1 
	LDR R1, = String1
	MOV R3, #0
	BL TO_SMALL
	LDR R0, = Count1
	STRB R3, [R0]
	
	
	
	LDR R0, = TEX2 ; using the procedure TO_SMALL to convert the String2 to small letters and store it in TEX2 
	LDR R1, = String2
	MOV R3, #0
	BL TO_SMALL
	LDR R0, = Count2
	STRB R3, [R0]
	

	
	
	;
	;; Calling the procedure Count_Common to count the common letters between two strings.
	;; Storing the address of the first String in R0
	;; Storing the address of the second String in R1
	;; Storing the count value in R3
	;
	
	LDR R0, = String1 
	LDR R1, = String2
	MOV R3, #0
	BL Count_Common
	LDR R0, = COMMON
	STRB R3,[R0]
	
	
	
	;; Encrypt the first string (address in R1), Destination address in R0
	LDR R0, = ENCRYPT1
	LDR R1, = String1
	BL Encrypt
	
	;; Encrypt the first string (address in R1), Destination address in R0
	LDR R0, = ENCRYPT2
	LDR R1, = String2
	BL Encrypt
	
STOP
	B STOP
	
	
TO_SMALL PROC
	
LOOP1
	LDRB R2, [R1]
	CMP R2, #0 ; the end of the string
	BEQ exitloop
	
	CMP R2, #0x20 ; skipping the space char
	BEQ next
	
	CMP R2, #0x5A ; ascii code for 'Z' if the char is less or equal to 'Z' it's capital, otherwise, it's small
	
	BLS Capital
	; Already small	
	B next
Capital 	
	;CAPITAL, convert it to small
	ADD R2, #0x20
	ADD R3, #1
next 

	STRB R2, [R0]  ; storing the small letter.
	
	ADD R0, R0, #1 ; increase the reading address pointer by one
	ADD R1, R1, #1 ; increase the writing address pointer by one
	
	B LOOP1
exitloop
	BX LR
	ENDP
	


Count_Common PROC
	LDR R2, = 0x61 ; load R2 = 'a'

LOOP2 					;; Looping through the letters from 'a' to 'z' small
	LDR R0, = String1
	LDR R1, = String2
	MOV R6, #0
LOOPSMALL_1				;; looping through the first string and increase R6 is small or capital match is found 
						;; (There is a char in string1 that is equal to char stored in R2).
	LDRB R4, [R0]
	
	CMP R4, #0
	BEQ exit1
	
	SUBS R5, R2, R4	
	BEQ SAME1	 ; SAME CHAR IN R2
	CMP R5, #32  ; SAME CHAR IN R2 But Capital
	BEQ SAME1
	
	B next1
SAME1
	ADD R6, #0x1
	B exit1
next1
	
	
	
	ADD R0, #0x1
	B LOOPSMALL_1
exit1
	
LOOPSMALL_2		;; looping through the second string and increase R6 is small or capital match is found 
				;; (There is a char in string2 that is equal to char stored in R2).
	LDRB R4, [R1]
	
	CMP R4, #0
	BEQ exit2
	
	SUBS R5, R2, R4
	BEQ SAME2
	CMP R5, #32
	BEQ SAME2
	
	B next2
SAME2
	ADD R6, #0x1
	B exit2
next2
	
	
	
	ADD R1, #0x1
	B LOOPSMALL_2
exit2

	CMP R6, #0x2
	BEQ COMMON_CHAR ;; if R6 is equal to 2 then the char in R2 appeared in string1 and in string2 so it's a common char.
	B SKIP
COMMON_CHAR
	ADD R3, #0x1
SKIP

	ADD R2, #0x1
	CMP R2, #0x7B
	BNE LOOP2

	
	BX LR
	ENDP



Encrypt PROC
	LDR R3, = 0xFFFFFFFF
LOOP3
	LDRB R2, [R1]
	CMP R2, #0
	BEQ exit3
	
	EOR R2, R2, R3
	
	STRB R2,[R0]
	
	ADD R0, #0x1
	ADD R1, #0x1
	
	B LOOP3
	
exit3
	BX LR
	ENDP


	END

