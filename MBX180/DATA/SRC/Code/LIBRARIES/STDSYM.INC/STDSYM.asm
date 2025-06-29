BITS 32
ORG 0x8000
%include SYSTEM.SYM
%include SYSTEM.YSM
%include SHELL.bin
%include Kernel.bin
%include File_System.bin
%include mainlib.bin
Section .text
	MAINLIB:
		call all
		dup all, all2
		mov all2 , MSG8
		jsr PRINT_STRING
		push MSG8
		call MAKECAB
		mov edx , 8 all
		call FILE_SYSTEM
		call all

section end