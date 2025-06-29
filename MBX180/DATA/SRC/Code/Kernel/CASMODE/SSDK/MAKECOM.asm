[BITS 32]
[ORG 0x1000]
%%include "MakeCAB.bin"
%%include "Kernel.bin"
Section .text
	MACRO ADDR .INCR
		in BUILD_DIR
		in BINARY,
		int 21h
		mov eax ,2
		mov eax 2, FILE
		test eax 2,
		shr BITS 8
		shr BITS 4
		shr BITS 10 ;Masks
		mov FILE 
	MACRO ADDR .Error
		mov si, ERROR
		mov ah , 0x0e
		ERROR DB, "Error in Generate_DATA, try again" error " was the problem" ,0
	MACRO ADDR .Generate_DATA
		mov eax 2, SHELL.bin
		int 21h
		DB FILEOUTPUT
		DUP FILE, FILEOUTPUT
	MACRO ADDR .PAYLOAD
		int 21h
		mov si, MSG
		mov ah , 0x0e
		MSG DB, "Input your payload" ,0
		DB PAYLOAD
		mov PAYLOAD al , Dx
		IN al, DX
		LODS al, DX, Payload
		mov edx 8 Payload, in FILE
		mov edx 6, out FILE
	MACRO ADDR .Finalize
		Option "[1]Package"
		Option "[2]Folder and Package"
		cmp in, 1 or 2
		JE PACKAGE in,1
		JE FOLD_PACK in,2
	PACKAGE:
		DB DIR
		mov FILE , DIR
		mov COM, DIR
		DB .PKG
		mov COM, PKG
		mov FILE, PKG
	FOLD_PACK:
		DB DIR
		mov FILE , DIR
		mov COM, DIR
		DB .PKG
		mov COM, PKG
		mov FILE, PKG
		mov all , NAME.PKG
section end