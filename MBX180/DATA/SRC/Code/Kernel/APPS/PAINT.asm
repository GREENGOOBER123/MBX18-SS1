[BITS 32]
[ORG 0x7F00]
include Kernel.ASM
include MDND.ASM
Section .TEXT
	call GRAPHICS_DEALER
	call MOUSE_DRIVER
	call INIT_KEYBOARD
	call ISR_KEYBOARD
	call TASK
	MAINPROG:
		TASK 500 width, 500 length,
		MOUSE_DRIVER LEA BYTE 1, BYTE 2, BYTE 3
		if BYTE 1 , 10 CALL(DRAWCALL)
		if BYTE 1 , 01 CALL(SETTING_BAR)
		LDS BYTE 2, BYTE 3,
Section END