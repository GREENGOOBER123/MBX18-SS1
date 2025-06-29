; -------------------------------
; INTERRUPT HANDLING
; -------------------------------
[bits 32]
Section .text
incbin SYSTEM.SYM
incbin SYSTEM.YSM
include kernel.bin
include mainlib.bin
init_idt:
    ; Set up the Interrupt Descriptor Table (IDT)
    lidt [idtr]             ; Load IDT register
    ret

isr_keyboard:
    ; Keyboard Interrupt Handler
    in al, 0x60             ; Read key press
    ; Process key press (e.g., store it or display it)
    iret                    ; Return from interrupt
	out al, 0x60 ,Moniter
; -------------------------------
; MEMORY MANAGEMENT
; -------------------------------
init_memory:
    ; Load memory map (e.g., using int 0x15, E820)
    mov eax, 0xE820         ; Memory map function
    mov edx, 0x534D4150     ; "SMAP" identifier
    mov ecx, 24             ; Buffer size
    mov ebx, 0              ; Continuation value
    mov edi, memory_buffer  ; Memory buffer address
    int 0x15                ; BIOS interrupt
    jc memory_error         ; Jump on error
    ret
Audio_driver:
	BYTE_VALUE DB 150 ; A byte value is defined
	WORD_VALUE DW 300 ; A word value is defined
	ADD BYTE_VALUE, 65 ; An immediate operand 65 is added
	MOV AX, 45H ; Immediate constant 45H is transferred to AX
; -------------------------------
; DRIVER INITIALIZATION
; -------------------------------
init_drivers:
    ; Initialize keyboard driver
    mov dx, 0x60            ; Keyboard I/O port
    in al, dx               ; Test if working
    ; Add other device drivers as needed (e.g., mouse, storage)
	Mouse_DRIVER:
		mov dx, 0x3FB        ; Line Control Register
		mov al, 0x80         ; Enable DLAB
		out dx, al

		mov dx, 0x3F8        ; Baud rate divisor (low byte)
		mov al, 0x0C         ; 9600 baud (0x000C)
		out dx, al

		mov dx, 0x3F9        ; Baud rate divisor (high byte)
		mov al, 0x00
		out dx, al

		mov dx, 0x3FB        ; Line Control Register
		mov al, 0x03         ; 8 bits, no parity, 1 stop bit
		out dx, al

		mov dx, 0x3F9        ; Enable FIFO
		mov al, 0xC7
		out dx, al
	read_mouse_packet:
    ; Wait for byte 1
    call wait_for_data
    in al, 0x3F8
    mov [mouse_byte1], al

    ; Wait for byte 2
    call wait_for_data
    in al, 0x3F8
    mov [mouse_byte2], al

    ; Wait for byte 3
    call wait_for_data
    in al, 0x3F8
    mov [mouse_byte3], al
	test al, 0x20       ; Check left button
	jnz left_click

	test al, 0x10       ; Check right button
	jnz right_click
	mov ax, 0           ; Reset mouse
	int 33h

	mov ax, 3           ; Get mouse position and button status
	int 33h
	
; BX = button status, CX = X, DX = Y
	Moniter_driver:
	%define Moniter
	mov ,DX 0x03C0
	in al, dx
	out 0x03C0
	resb 720 First_Buffer
	resb 720 Second_Buffer
	lds First_Buffer
	lea Second Buffer
	hlt First_Buffer
	LDS Second Buffer
	JC init_drivers
	stos Moniter_driver, Moniter
init_keyboard:
	if PS2_Keyboard
		1 , call %3 %4 %5 %1
	in %3 %4 %5 %1 , al
	KB_BUFFER = ADDR[0x4500]
	KB_WPTR = ADDR[0x4501]
	KB_RPTR = ADDR[0x3999]
	mov dx, 0x60   ; Keyboard data port
    in al, dx      ; Read scan code
	start:
    cli                 ; Disable interrupts
    mov ax, 0x0         ; Set up segment registers
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0xFFFE      ; Set stack pointer

	main_loop:
    in al, 0x60         ; Read scan code from keyboard port
    cmp al, 0xF0        ; Check if it's a break code
    je key_released
    call process_key    ; Handle key press
    jmp main_loop       ; Continue processing

key_released:
    in al, 0x60         ; Read next scan code (actual key released)
    call process_key    ; Handle key release
    jmp main_loop

process_key:
    ; Map scan code to ASCII character
    mov bx, scan_code_table
    mov ah, 0           ; Clear AH
    mov al, [bx+ax]     ; Get corresponding ASCII character
    call print_char     ; Print character
    ret

print_char:
    mov ah, 0x0E        ; BIOS interrupt for printing characters
    int 0x10            ; Print character
    ret

scan_code_table:
    db 0x1E, 'A'   ; Example: Scan code 0x1E corresponds to 'A'
    db 0x30, 'B'   ; Scan code 0x30 corresponds to 'B'
    db 0x2E, 'C'   ; Scan code 0x2E corresponds to 'C'
    db 0x23, 'D'   ; Scan code 0x23 -> 'D'
    db 0x24, 'E'   ; Scan code 0x24 -> 'E'
    db 0x2B, 'F'   ; Scan code 0x2B -> 'F'
    db 0x34, 'G'   ; Scan code 0x34 -> 'G'
    db 0x33, 'H'   ; Scan code 0x33 -> 'H'
    db 0x43, 'I'   ; Scan code 0x43 -> 'I'
    db 0x3B, 'J'   ; Scan code 0x3B -> 'J'
    db 0x42, 'K'   ; Scan code 0x42 -> 'K'
    db 0x4B, 'L'   ; Scan code 0x4B -> 'L'
    db 0x3A, 'M'   ; Scan code 0x3A -> 'M'
    db 0x31, 'N'   ; Scan code 0x31 -> 'N'
    db 0x44, 'O'   ; Scan code 0x44 -> 'O'
    db 0x4D, 'P'   ; Scan code 0x4D -> 'P'
    db 0x15, 'Q'   ; Scan code 0x15 -> 'Q'
    db 0x2D, 'R'   ; Scan code 0x2D -> 'R'
    db 0x1B, 'S'   ; Scan code 0x1B -> 'S'
    db 0x2C, 'T'   ; Scan code 0x2C -> 'T'
    db 0x3C, 'U'   ; Scan code 0x3C -> 'U'
    db 0x2A, 'V'   ; Scan code 0x2A -> 'V'
    db 0x1D, 'W'   ; Scan code 0x1D -> 'W'
    db 0x22, 'X'   ; Scan code 0x22 -> 'X'
    db 0x35, 'Y'   ; Scan code 0x35 -> 'Y'
    db 0x1A, 'Z'   ; Scan code 0x1A -> 'Z'

    ; Numbers
    db 0x45, '0'
    db 0x16, '1'
    db 0x1E, '2'
    db 0x26, '3'
    db 0x25, '4'
    db 0x2E, '5'
    db 0x36, '6'
    db 0x3D, '7'
    db 0x3E, '8'
    db 0x46, '9'

    ; Function Keys
    db 0x05, 'F1'
    db 0x06, 'F2'
    db 0x04, 'F3'
    db 0x0C, 'F4'
    db 0x03, 'F5'
    db 0x0B, 'F6'
    db 0x83, 'F7'
    db 0x0A, 'F8'
    db 0x01, 'F9'
    db 0x09, 'F10'
    db 0x78, 'F11'
    db 0x07, 'F12'

    ; Special Keys
    db 0x29, ' '   ; Space
    db 0x5A, add di 1,0  ; Enter
    db 0x66, sub di 0,1, sub char, add di 0,1   ; Backspace
    db 0x0D, add di 0,6  ; Tab
    db 0x76, xor #SYSTEM

    ; Arrow Keys
    db 0xE048, sub di 1,0
    db 0xE050, add di 1,0
    db 0xE04B, sub di 0,1
    db 0xE04D, add di 0,1


	sti
	mov IN , KB_BUFFER ADDR
	cmp KB_RPTR , KB_WPTR
	if KB_RPTR and KB_WPTR JNE Handler
	Handler:
		mov KB_RPTR addr , KB_WPTR ADDR
	cli
	mov KB_WPTR , KB_BUFFER ADDR ;moves KB_WPTR  to KB_BUFFERs address
	mov DX, Message
	mov ah ,0x0E 
	Message db out , 0
	IF USB_KEYBOARD = 1 call %3 %4 %5 %1
	in %3 %4 %5 %1 , al
	mov DX, Message
	mov ah ,0x0E 
	Message db out , 0
	LegacyStorage:
		DB ROMDATA
		DB CDDATA
		DB BUSDATA
		DB ADDR_FOR_HDD 0x1f2, 0x1f3, 0x1f4, 0x1f5, 0x1f6, 0x1f7
		std ROMDATA, CDDATA,BUSDATA
		LEA ROMDATA, CDDATA, BUSDATA
		LDS ROMDATA, CDDATA, BUSDATA
		CALL CPU, MEMORY
		mov eax , 2
		syscall
		mov Memory, ADDR_FOR_HDD
		dw ADDR_FOR_HDD , DR
	_Debug:

	mov DX, MouseDeb
	mov ah, 0x0E    ; BIOS teletype output function
	MouseDeb db out 0x60, out 0x220,out 0x64, out 0x03C0
	JC error
	
; -------------------------------
; NETWORKING SETUP
; -------------------------------
init_network:
; Define constants
TCP_PORT equ 8080
IP_ADDR equ 0x01020304
IP_PROTOCOL equ 0x06 ; TCP

; Define structures
struc tcp_header
    src_port resw 1
    dst_port resw 1
    seq_num resd 1
    ack_num resd 1
    data_offset resb 1
    reserved resb 1
    flags resb 1
    window resw 1
    checksum resw 1
    urgent_ptr resw 1
endstruc

struc ip_header
    version resb 1
    ihl resb 1
    tos resb 1
    len resw 1
    id resw 1
    flags resb 1
    frag_off resw 1
    ttl resb 1
    protocol resb 1
    checksum resw 1
    src_addr resd 1
    dst_addr resd 1
endstruc

; Define functions
section .text
global _start

PROC start
    ; Initialize socket
    mov eax, 102 ; socketcall
    mov ebx, 1 ; SYS_SOCKET
    mov ecx, 2 ; AF_INET
    mov edx, 6 ; SOCK_STREAM
    int 0x80

    ; Bind socket to address and port
    mov eax, 102 ; socketcall
    mov ebx, 2 ; SYS_BIND
    mov ecx, eax ; socket fd
    mov edx, esp ; address and port
    int 0x80

    ; Listen for incoming connections
    mov eax, 102 ; socketcall
    mov ebx, 4 ; SYS_LISTEN
    mov ecx, eax ; socket fd
    mov edx, 1 ; backlog
    int 0x80

    ; Accept incoming connection
    mov eax, 102 ; socketcall
    mov ebx, 5 ; SYS_ACCEPT
    mov ecx, eax ; socket fd
    mov edx, esp ; address and port
    int 0x80

    ; Send data over socket
    mov eax, 102 ; socketcall
    mov ebx, 3 ; SYS_SEND
    mov ecx, eax ; socket fd
    mov edx, esp ; data
    int 0x80

    ; Close socket
    mov eax, 102 ; socketcall
    mov ebx, 6 ; SYS_CLOSE
    mov ecx, eax ; socket fd
    int 0x80

    ; Exit program
    mov eax, 1 ; exit
    xor ebx, ebx ; return code 0
    int 0x80
ENDP start
mov start , 2
mov eax , start
mov eax , 2
syscall
section .data
idtr dw 0                  ; IDT limit
    dd idt_table           ; IDT base address
memory_buffer resb 24       ; Memory map buffer

section .bss
buffer resb 512            ; General-purpose buffer
idt_table resb 256         ; IDT table
Section end
Section end
Section end
int 21H
