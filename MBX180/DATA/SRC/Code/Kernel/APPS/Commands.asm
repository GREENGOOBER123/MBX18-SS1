[BITS 32]
DB Commands
Section .text
MAINDEFINE:
	mov MAINDEFINE, SYSTEM
	%include 'FILE SYSTEM.ASM':
	%define DIR, FAT16
echo:
	in KEYBOARD ;takes input from KEYBOARD
	mov si, command
	mov ah, 0x0E
	Command OUT Keyboard,0 ;prints
Calc:
	in KEYBOARD
	Add div sub mul = "", 0 mov MATHAWNS
	mov si, command
	mov ah, 0x0E
	Command out MATHAWNS
START:
	%define START_PROG in dx ax
	in PROGRAM
	call(PROGRAM)
COMPILE:
	%include 'Compiler.ASM'
	call COMPILE
Copy:
	mul FILE = 2, FILE_1, FILE_2
	mov FILE_2 , in
Move:
	mov FILE
Shutdown:
	cli
	hlt
restart:
	STI
	cli
	hlt
	lds BOOTLOADER
LS:
	STI
	LEA DIR
	LDS DIR
	mov si, Directory
	mov ah, 0x0E
	message db DIR
CD:
	mov KERNEL, in
Clear:
	cli
	hlt Shell
	int
MKDIR:
	STI
	new
Section end
STOSB .TEXT COMMANDS
