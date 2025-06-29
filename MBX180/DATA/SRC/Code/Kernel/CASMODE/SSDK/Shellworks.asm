[BITS 32]
[ORG 0x1000]
incbin SYSTEM.YSM
incbin SYSTEM.SYM
%include MakeCab.bin
%include Kernel.bin
%include MDND.bin
%include mainlib.bin
.model Large
.386
Section .text
	Start_:
		int 0x03
		call TASK
		mov title , "PASM BINARY EDITOR"
		in BX, .cab
		ins in , BX
		call Graphics_Dealer,
		mov Background_Color 808080,
		mov TEXT_Color , 000000
		ins Binary , HEX
	MAINEDIT:
		mov title , "SHELLWORK TEXTEDIT"
		mov in  , TXT
		PROC ADDFILE
			dup 0 , BX
			mov 0, MAINEDIT
			ins MAINEDIT
			mov di , 80x80
			ins HEX
		ENDP ADDFILE
		PROC OPENFILE
			ins BX
		ENDP OPENFILE
		PROC UI
			mov di , 30x90, 40x100
			%define FILES_BAR
			mov di, FILES_BAR
			lds FILES_BAR
			call FILES_BAR
		ENDP UI
	COMPILE:
		jsr PRINT_STRING "Setting up Build config"
		mov in bx, .PKG
		mov edx , 8
		mov edx , input.res , BX
		mov edx	, SRC , BX
		mov "Building Program" , MSG9
		jsr PRINT_STRING
		push MSG9
		mov out, AX
		int 0x10
		syscall
		mov AX , 2
		mov eax , 2
		mov "Starting up program", MSG10
		jsr PRINT_STRING
		push MSG10
	
	  MetroWerks_Station:
		mov si , 6090,40100
		%define SSTATISTIC_BAR
		mov si , SSTATISTIC_BAR
		call MOUSE_DRIVER
		if MOUSE_COOR = BYTE 1,0 BX
			INS BX, #SHELL
			mov in BX , rdtsc ADDR
			stosb FILE_HASH
			lodsb FILE_HASH
		endif
		mov eax , 2
		int 10h
		syscall
Section end