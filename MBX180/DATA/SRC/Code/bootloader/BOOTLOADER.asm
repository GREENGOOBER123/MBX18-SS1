[bits 16]       ; Switch to 16-bit mode
[org 0x7C00]    ; BIOS loads bootloader at this address
Section .text
	start:
		cli         ; Disable interrupts
		xor ax, ax  ; Clear AX register
		mov ds, ax  ; Set Data Segment to 0
		mov es, ax  ; Set Extra Segment to 0
		mov fs, ax  ; Set FS segment to 0
		mov gs, ax  ; Set GS segment to 0

    ; Print a string to the screen
		mov si, message
		mov ah, 0x0E    ; BIOS teletype output function
		message db "booting bios!", 0
	Memory_:
		Call Memory
		DB .TEXT = Memory
	Section HARDDISK
		push 0x0000
		push 0x0001
		push 0x0002
		pop 0x0000 equ Data
		pop 0x0001 equ HDDNUM
		pop 0x0002 equ ADDRESS`
	Section END
times 510 - ($-$$) db 0  ; Pad to 512 bytes
dw 0xAA55                ; Bootloader signature
Section end
Section END