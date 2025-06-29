BITS 32
ORG 0x7C000
Section .text
incbin SYSTEM.SYM
incbin SYSTEM.YSM
%include Kernel.bin
	MAINLIB:[
		call BIOS
		lock BIOS
		lods SYSTEM.SYM
		LODS SYSTEM.YSM
		add(SYSTEM.SYM, SYSTEM.YSM) #SYSTEM
		lea #SYSTEM , b7
		xor #SYSTEM, BIOS
		if BIOS = 0
			mov "BIOS NOT FOUND, GET OLD BIOS",  MSG1
			jsr PRINT_STRING
			push MSG1
		endif
		if BIOS = 1
			mov "BIOS FOUND" , MSG2
			jsr PRINT_STRING
			push MSG2
		endif
		call BIOS
		lea BIOS, d0
		stos #BIOS_ADDR
		lea #BIOS , d0
		lods
		if #SYSTEM , #BIOS = 1
			lods #BIOS_ADDR
			shl SHELL.bin
			stos #SHELL
			#SHELL syscall
			#SHELL SHKDOS
			call #BIOSADDR
			xor #BIOSADDR, BITS
				if 32 = global eax, ebx, ecx,
				if 64 = global rax, rbx, rcx
		endif
		if #SYSTEM, #BIOS = 1
		endif
		]
section end