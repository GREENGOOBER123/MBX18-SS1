[bits 32]  ; Switch to 32-bit mode (if not already)
incbin SYSTEM.SYM
incbin SYSTEM.YSM
%include 'file system.bin'
%include 'Bootloader.bin'
%include 'MODULE.bin'
%include 'MDND.bin'
%include 'BOOLTOADE2.bin'
.model Large
.386
Section .text
KERNEL_START = 0x4500
global kernel_start
Task:
	DB Task = R/W, RO, WO,
	RESB in, WIDTH
	RESB in, LENGTH
	STOS WIDTH LENGTH , TASK
kernel_start:
    cli         ; Disable interrupts
    mov ax, 0x10 ; Load data segment selector
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
	add(CPU, GFX, CARD , MotherBoard, memory,) = System
	%define SYSTEM_ON = SYSTEM = 1
	%define SYSTEM_OFF = SYSTEM = 0
	%define MODE in
	JE ERROR_CODE MODE,1
	JE CASMODE_GUI MODE,2
Memory_MODULE:
	push all
	pop in
	pop 0x1000 , 0x6999
	mov eax, 0xE820          ; Function number for memory map
	mov edx, 0x534D4150      ; "SMAP" identifier
	mov ecx, 24              ; Size of the buffer
	mov ebx, 0               ; Continuation value (set to 0 for first call)
	mov edi, memory_buffer   ; Address of the buffer to store results
	int 0x15                 ; BIOS interrupt
	lds Memory
	call CPU
	jc ERROR_CODE                ; Jump to error handling if the carry flag is set
; Process the memory map data in the buffer
PRINT_STRING:
	mov #BIOS, ah
	call BIOS
	DB NAME , SI
	mov NAME , 0x0e
	lda STR
    pop STR
	lds STR
	mov SHK_TERMINAL , STR
	if
		mov si, MSG
		mov ah , 0x0e
		MSG DB , STR , 0
			1
			MOV STR , NAME
			call SHK_TERMINAL
			mov NAME, SHK_TERMINAL
	endif
   
ERROR_CODE:
	mov si , ERROR_CODE
	mov ah , 0x0E
	ERROR_CODE error, 0
	call Graphics_dealer
	mov #00FC00 , Graphics_dealer ,background
	Mov #030000 ,Graphics_dealer , text
Serial_periphial_interface:
	;reset
	lda #cs
	std PORTA
	LDA #%00000111
	sta DDRA
	
	
	;bit bang %d0 11010000
	lda #MOSI
	LDA #(SCK | MOSI)
	sta PORTA
	
	lda #MOSI
	sta PORTA
	LDA #(SCK | MOSI)
	Sta PORTA



Graphics_dealer:
    ; Set graphics mode (Mode 13h)
    mov ax, 0x4F02
    int 0x10

    ; Placeholder for graphics initialization
    db 'GRPH'

    ; Set text mode (Mode 3)
    mov ax, 0x03
    int 0x10

    ; Set video memory segment for text mode
    mov ax, 0xB800
    mov es, ax

    ; Write a character to the top-left corner
    mov di, 0                ; Start at top-left corner
    mov al, 'T'              ; ASCII code for 'T'
    mov ah, 0x07             ; Attribute byte: white on black
    stosw                    ; Write character and attribute to video memory

    ; Set background and text colors (placeholders)
    mov background_color, 0x000000  ; Black background
    mov text_color, 0xFFFFFF        ; White text
	%define VIDEO_MODE, GFX ADDR
	cmp CPU , in
	shr in , ADDR
	LEA ecx
	stosb ecx
	int ADDR
	xor 0x03, ADDR
	xor 0x4F02, ADDR
    ; Conditional logic (clarify purpose)
    xor CARD_FLAG, 1
    je CARD

    ret


FILE_HANDLE:
	DW FILE_HANDLE
	%define FILE_HANDLE in
	%define FILE_HANDLE out
	%define FILE_HANDLE in, out
	%define FILE_HANDLE in, out, in
	%define FILE_HANDLE in, out, in, out
	%define FILE_HANDLE in, out, in, out, in
	%define FILE_HANDLE in, out, in, out, in, out
	%define FILE_HANDLE in, out, in, out, in, out ,in
	%define FILE_HANDLE in, out, in, out, in, out ,in ,out
	mov FILE_HANDLE, BX
CASMODE_GUI:
	DB GUI
	int 0x4F02
	mov GUI, GRPH
	CALL DRAW_CALL[#FFFFFF] , background
	CALL DRAW
	%define ORIGIN[GUI]  di in,in and in, in
	MEMORY RESB 1000 , SCREEN
	call SCREEN, RESB ORGIN 0,0 1000,100 , %define Upper_bar
	call SCREEN, RESB ORGIN 0,100 900,1000, %define actual_mainboard
	%define DashBoard, APPS_ICONS
	int 0x10
CARD:
    ; Set VGA graphics mode
    mov ax, 0x4F02
    int 0x10

    ; %include additional commands
    %include COMMANDS.bin
	%include SHELL.bin
    ; Check if VGA card is present
    mov ax, 0x4F00
    int 0x10
    cmp al, 0x4F
    jne VGA_NOT_SUPPORTED

    ; Write model image to file
    call WRITE_FILE

    ; Interact with monitor driver
    call MONITER_DRIVER
    mov dx, MONITER_PIXEL
    out dx, ax

    ret

VGA_NOT_SUPPORTED:
    mov si, VGA_NOT_SUPPORTED_MSG
	mov ah, 0x0E
	VGA_NOT_SUPPORTED_MSG db "Your computer uses HDMI i guess, damn it", 0
    ret

	IVT:
    dw ISR_DIVIDE_BY_ZERO, 0x0000  ; Interrupt 0x00: Divide by zero
    dw ISR_DEBUG, 0x0000           ; Interrupt 0x01: Debug
    dw ISR_NMI, 0x0000             ; Interrupt 0x02: Non-maskable interrupt
    dw ISR_BREAKPOINT, 0x0000      ; Interrupt 0x03: Breakpoint
    dw ISR_OVERFLOW, 0x0000        ; Interrupt 0x04: Overflow
    dw ISR_BOUND_RANGE, 0x0000     ; Interrupt 0x05: Bound range exceeded
    dw ISR_INVALID_OPCODE, 0x0000  ; Interrupt 0x06: Invalid opcode
    dw ISR_DEVICE_NOT_AVAILABLE, 0x0000 ; Interrupt 0x07: Device not available
    ; ... (Add more interrupts as needed)

    ; Fill remaining entries with a default handler
    times 256 - ($ - $$) / 4 dw ISR_DEFAULT, 0x0000

; Interrupt Service Routines (ISRs)
ISR_DIVIDE_BY_ZERO:
    cli
    mov ah, 0x0E
    mov si, DIVIDE_BY_ZERO_MSG
    call PRINT_STRING
    hlt

ISR_DEBUG:
    cli
    mov ah, 0x0E
    mov si, DEBUG_MSG
    call PRINT_STRING
    hlt
	ISR_INT_21H:
    pusha                   ; Save all registers
    cmp ah, 0x09            ; Check service number (e.g., 0x09 for printing a string)
    je PRINT_STRING
    cmp ah, 0x3D            ; Check service number (e.g., 0x3D for opening a file)
    je OPEN_FILE
    ; Add more services as needed
    jmp DEFAULT_HANDLER     ; Default handler for unknown services

DEFAULT_HANDLER:
    mov eax, 2
	mov edx, 2 UNKOWNSERVICE.TXT
    popa
    iret
ISR_DEFAULT:
    cli
    mov ah, 0x0E
    mov si, DEFAULT_MSG
    call PRINT_STRING
    hlt

SHK_TERMINAL:
    mov di 1,0
    cmp STR, NULL
    if STR ,0
        ADD(di 1,0)
	mov ah, 0x0E    ; BIOS teletype mode
    xor bx, bx      ; Cursor position tracking

read_loop:
    mov ah, 0x00    ; Wait for keypress
    int 0x16        ; BIOS keyboard input

    cmp al, 0x08    ; Backspace?
    je backspace

    cmp al, 0x0D    ; Enter?
    je newline

    mov ah, 0x0E    ; Print the character
    int 0x10

    inc bx          ; Move cursor forward
    jmp read_loop

backspace:
    cmp bx, 0       ; If nothing to erase, skip
    je read_loop

    dec bx
    mov ah, 0x0E
    mov al, ' '     ; Overwrite last char with space
    int 0x10
    mov al, 0x08    ; Move cursor back
    int 0x10
    jmp read_loop

newline:
    mov ah, 0x0E
    mov al, 0x0A    ; Line feed
    int 0x10
    mov al, 0x0D    ; Carriage return
    int 0x10
    jmp read_loop
; Messages
DIVIDE_BY_ZERO_MSG db "Divide by zero error!", 0
DEBUG_MSG db "Debug interrupt triggered!", 0
DEFAULT_MSG db "Unhandled interrupt!", 0

SAFEMODE:
	jsr PRINT_STRING "you sure you wanna download this"
	Option"[1]Yes"
	Option"[2]NO"
	CMP in
	if
		in = 1
			mov edx, 0
		in = 2
			mov edx 9
	endif
	mov , "OK BYE BYE" , MSG67
	jsr PRINT_STRING
	push MSG67
	; Define system calls
SYSCALLS:
	DW SYSCALL(fork) = int 21h SHELL.bin , EXEC(in) mov SHELL, in, eax 2
	DW SYSCALL(IOCTL) = DB %include mainlib.bin call MAINLIB in or out , eax 4
	DW SYSCALL(KILL) = DB CALL Kernel.bin,mov eax 2,mov eax 2,0 , eax 6
	DW SYSCALL(Read) = LEA EXEC and lds, edx 2
	DW SYSCALL(Write) = LEA EXEC and IN, edx 4
	DW SYSCALL(Save) = stos EXEC, edx 6
	DW SYSCALL(Security) = mov Internet SAFEMODE , edx 9
Macro ADDR DRAW_CALL
	CALL CARD, DB DRAW_CALL
	call MONITER_DRIVER
	mov, ax 0x4F02	
REST_OF_CODE:
mov ,"Kernel is in initialization", MSG89
jsr PRINT_STRING
push MSG89
Section .keyboard
mov dx, 0x60       ; Keyboard data port
in al, dx          ; Read key press into AL
; Process the key (e.g., store in a buffer or handle directly)
mov [Buffer], al   ; Save the key press in a buffer
OUT[BUFFER],
Section end
Section end
INT 10h
mov eax , 2
INT 10h
if SYSTEM.SYM = BX, ''
INS \SRC\CODE\KERNEL\CASMODE\INSTALL.XML
INS \SRC\CODE\KERNEL\INSTALL.BIN
INS \BUILD\setexec.obj
mov eax 2 , Kernel.bin
mov eax 2, INSTALL.XML
int 10
