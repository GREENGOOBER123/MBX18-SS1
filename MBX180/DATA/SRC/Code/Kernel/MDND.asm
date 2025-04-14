; -------------------------------
; INTERRUPT HANDLING
; -------------------------------
[bits 32]
Section .text
init_idt:
    ; Set up the Interrupt Descriptor Table (IDT)
    lidt [idtr]             ; Load IDT register
    ret

isr_keyboard:
    ; Keyboard Interrupt Handler
    in al, 0x60             ; Read key press
    ; Process key press (e.g., store it or display it)
    iret                    ; Return from interrupt

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

memory_error:
    ; Handle memory initialization error
    hlt                     ; Halt the system

; -------------------------------
; DRIVER INITIALIZATION
; -------------------------------
init_drivers:
    ; Initialize keyboard driver
    mov dx, 0x60            ; Keyboard I/O port
    in al, dx               ; Test if working
    ; Add other device drivers as needed (e.g., mouse, storage)
	Mouse_DRIVER:
    in al, 0x64        ; Read status byte from port 0x64
	test al, 0x20      ; Check if mouse data is available (bit 5)
	jz skip_read       ; If not, skip the read

	in al, 0x60        ; Read mouse data from port 0x60
	; Interpret mouse data (e.g., check left/right button state)

	Moniter_driver:
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
init_keyboard:
	if PS2_Keyboard =  1 , call %3 %4 %5 %1
	in %3 %4 %5 %1 , al
	mov DX, Message
	mov ah ,0x0E 
	Message db out , 0
	IF USB_KEYBOARD = 1 call %3 %4 %5 %1
	in %3 %4 %5 %1 , al
	mov DX, Message
	mov ah ,0x0E 
	Message db out , 0
	Storage:
	DB ROMDATA
	DB CDDATA
	std ROMDATA, CDDATA
	LEA ROMDATA, CDDATA
	LDS ROMDATA, CDDATA
	CALL CPU, MEMORY
	if CPU 0 hlt
	
	_Debug:
	
	mov DX, MouseDeb
	mov ah, 0x0E    ; BIOS teletype output function
	MouseDeb db out 0x60, out 0x220,out 0x64, out 0x03C0
	JC error
	
; -------------------------------
; NETWORKING SETUP
; -------------------------------
init_network:
    ; Basic network initialization (e.g., configure NIC)
    ; This is a placeholder as networking in Assembly is complex and
    ; requires interaction with specific hardware (like an Ethernet card)
    mov dx, 0xC000          ; Hypothetical NIC I/O port
    out dx, al     	; Send configuration data
    ; Implement basic send/receive routines
	in 0xC000  dx , al
	in Send 1 or 2
	lds 0xC000 
	Jl Send = 2, out Data
    ret

DATA:
; -------------------------------
; DATA SECTION
; -------------------------------
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