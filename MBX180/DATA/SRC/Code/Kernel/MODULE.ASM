%include 'Kernel.asm'
%include 'MDND.asm'
%include 'Bootloader.asm'
Section .text
	MACRO ADDR MODULE_READER
		mov Memory 0x3f000, 0x4f000
		ADD (Memory, MODULE_READER)
	MACRO ADDR MODULE_WRITER
		IN MODULE
		DB NEW-MODULE
		IN PATH NEW-MODULE
		mov MODULE , NEW-MODULE
		DB FILE
	Call(MODULE_READER, MODULE_READER)
Section end