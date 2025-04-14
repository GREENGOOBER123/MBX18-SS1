[bits 32]  ; Switch to 32-bit mode (if not already)
Section .text
KERNEL_START = 0x7F00
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

mov eax, 0xE820          ; Function number for memory map
mov edx, 0x534D4150      ; "SMAP" identifier
mov ecx, 24              ; Size of the buffer
mov ebx, 0               ; Continuation value (set to 0 for first call)
mov edi, memory_buffer   ; Address of the buffer to store results
int 0x15                 ; BIOS interrupt
lds Memory
lds CPU
jc ERROR_CODE                ; Jump to error handling if the carry flag is set
; Process the memory map data in the buffer
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
End Serial_periphial_interface:
Graphics_dealer:
	DB GRPH
	mov ax, 0x13        ; Set Mode 13h (graphics mode)
    int 0x10            ; BIOS interrupt
	DB VIDE
	DB text
	A_font db 0x18, 0x24, 0x42, 0x7E, 0x42, 0x42 ; A character
	mov ax, 0x03   ; Mode 3: VGA text mode
	int 0x10
	org 0x100
	mov ax, 0xB800       ; Video memory base address
	mov es, ax
	include FONT.ASM
	mov di, 0            ; Start at top-left corner
	mov al, 'T'          ; ASCII code for 'T'
	mov ah, 0x07         ; Attribute byte: white on black
	stosw                ; Write character and attribute to video memory
	mov #Ffa500 , Graphics_dealer ,background
	Mov #101651 ,Graphics_dealer , text
	JE CARD, 1
CARD:
	mov, AX 0x13  ;VGA card Graphics mode
	include COMMANDS.ASM
	SysCALL(if VGA_CARD = TRUE)
	.TEXT IN
	OUT #MODEL_IMAGE
	CALL(WRITE_FILE)
	STOSB
	call MONITER_DRIVER
	out MONITER_PIXEL=TASKR/W
	
REST_OF_CODE:
mov si, message
mov ah, 0x0E    ; BIOS teletype output function
message db "Kernel is starting up!", 0
Section .keyboard
section .keyboard
mov dx, 0x60       ; Keyboard data port
in al, dx          ; Read key press into AL
; Process the key (e.g., store in a buffer or handle directly)
mov [Buffer], al   ; Save the key press in a buffer
Section end
Section end