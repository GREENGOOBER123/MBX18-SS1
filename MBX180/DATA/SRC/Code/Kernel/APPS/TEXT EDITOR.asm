[BITS 32]
[ORG 0x7F00]
include Kernel.ASM
include MDND.ASM
Section .text
	MAIN_EDITOR:
		DB TEXTFILE
		IN DATA,Name,EXT
		out  Name.EXT
	GUI:
		call CARD
		int 0x13
		RESB 200 FILES,0
		RESB 200 OPTIONS,0
		DB FILES "NEW"(DB TEXTFILE), "LOAD"(LODS IN), "EXIT"(HLT),
Section end