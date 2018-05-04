		SECTION	.data
		EXTERN	inbound_queue	; (defined in main.C)
data		DB	0		; put rcvd byte here

		SECTION	.text
		ALIGN	16
		BITS	32

BASE_PORT	EQU	3F8h		; we have this in our lab

LSR_PORT	EQU	BASE_PORT+5	; LSR (Line Status Register) 
RBR_PORT	EQU	BASE_PORT	; RBR (Receiver Buffer Register) 
THR_PORT	EQU	BASE_PORT	; THR (Transmitter Holding Register)

; ---------------------------------------------------------------------
; void SerialPut(char ch)
; ---------------------------------------------------------------------
; This function uses programmed waiting loop I/O
; to output the ASCII character 'ch' to the UART.

		GLOBAL	SerialPut

SerialPut:
	
	;; vvv Instructions (x86 asm) vvv
	;; https://www.csie.ntu.edu.tw/~cyy/courses/assembly/08fall/lectures/handouts/lec12_x86isa.pdf
	;; (1) Wait for THRE = 1	
		mov DX, LSR_PORT ;  LSR stores the status
		in EAX, DX
	;; cpi eax on bit 5 (THRE (Transmitter Holding RegisterEmpty)) - ref, (1) Wait for THRE = 1	
		bt EAX, 5	; The carry flag will be the same as EAX 5th bit
		jnc SerialPut	; jump if not carry = 1
	;; (2) Output character to UART
		;; Troubleshooting - Had to be DX, https://c9x.me/x86/html/file_module_x86_id_222.html	
		mov DX, THR_PORT 	; stores the address of THR_PORT in eax
		mov AL, [ESP + 4]
		out DX, AL		; Output byte in AL to I/O port address in DX.	
	;; (3) Return to caller
		ret
	
; ---------------------------------------------------------------------
; void interrupt SerialISR(void)
; ---------------------------------------------------------------------
; This is an Interrupt Service Routine (ISR) for
; serial receive interrupts.  Characters received
; are placed in a queue by calling Enqueue(char).

		GLOBAL	SerialISR
		EXTERN	QueueInsert	; (provided by LIBPC)

	;; https://c9x.me/x86/
SerialISR:	STI             	; Enable (higher-priority) IRQs 
	; (1) Preserve all registers
		pushad			; "PUSHA/PUSHAD -- Push All General-Purpose Registers"
	; (2) Get character from UART


		mov DX, LSR_PORT ;  LSR stores the status
		in EAX, DX
		bt EAX, 0	; The carry flag will be the same as EAX 0th bit
		jnc _Eoi	; jump if not carry = 1

		mov DX, RBR_PORT 	; stores the address of THR_PORT in DX
		in AL, DX		; Output byte in AL to I/O port address in DX.
		
	; (3) Put character into queue
		mov [data], AL
		; Param #2: address of data
		push data
		; Param #1: address of queue
		push dword [inbound_queue] ; = 32 bits

		CALL	QueueInsert
		ADD	ESP,8

_Eoi:	; (4) Enable lower priority interrupts
	    ; (Send Non-Specific EOI to PIC)
	; Slides https://www.ida.liu.se/~TDDI11/labs/pdf/old_lab_slides_2009.pdf:
		mov EAX, 0x20
		out 0x20, EAX
	; (5) Restore all registers
		popad
	; (6) Return to interrupted code
		iret
