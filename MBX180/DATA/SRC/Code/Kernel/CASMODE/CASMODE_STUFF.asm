[BITS 32]
[ORG 0x7C00]
%include 'Kernel.bin'
.model medium
Section .TEXT
	main proc
		call CASMODE_GUI
		%include 'API MAKE'
		FUNC:
			call all
			LDS all
			JE FUNC if SYSTEM_ON
		MAIN_UI:
			mov BX, all
			mov eax, 0
			mov edx, 0
		Setup_ENVIROMENT:
			mov eax, 0x00000000
			mov edx, 0x00000000
			mov ecx, 0x00000000
			mov ebx, 0x00000000
			mov esi, 0x00000000
			mov edi, 0x00000000
			mov esp, 0x00000000
			mov BX , .RES ; Setup enviroment for a new task
		LOAD:
			mov BX , Memory
			int 21h
			mov eax, MAIN_SCREEN.res
			shr bits, 10
			shr bits, 8
			shr bits, 6
			shr bits, 4
			shr bits, 2
			shr bits, 0
			mov edx, 2
			mov BX, MAIN_SCREEN
			For
				mov eax, MAIN_SCREEN.res
				mov edx, 2
			while
				
	end main
section end