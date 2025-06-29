[BITS 32]
DB Commands
Section .text
MAINDEFINE:
	mov MAINDEFINE, SYSTEM
	%%include 'FILE SYSTEM.bin':
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
	%%include 'Compiler.bin'
	call COMPILE
	STOS COMPILE_FILE
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
SussyAI:
	mov si , MSG
	mov ah , 0x0E
	MSG DB, "Okay if you say so child",0
	mov di 0,1
	MSG DB , "idk why",0
	call(SussyAI)
CD:
	mov KERNEL, in
MAKECAB:
	%%include 'MAKECAB.bin'
	%define "BUILD_DIR"
	COMPILE_FILE in,in
	out BINARY_FILE
Clear:
	cli
	hlt Shell
	int
MKDIR:
	STI
	int 21h , Directory
	in si
	%define NAME in si , Directory
MAKECOM:
	%%include 'MAKECOM.bin'
	call .INCR
Section end
STOSB .TEXT COMMANDS
