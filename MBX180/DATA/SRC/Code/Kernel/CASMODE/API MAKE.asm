[BITS 32]
[ORG 0x7F000]
.model small
.386
%include 'Kernel.bin'
%include 'MDND.bin'
Section .Text
	MAINAPI:
		DW BUTTONS, WIDTH RESB in, Length RESB in, X, Y
		DW Window, WIDTH RESB in, Length RESB in, X, Y
		DW TextPrompt, WIDTH RESB in, Length RESB in, X, Y, TXT
	SS10_GUIAPI:
		mov in "API_MODE>"
		if 'BUTTON' CALL WORD BUTTONS
		if 'Window' CALL WORD Window
		if 'INPUT TEXT' CALL WORD TextPrompt
		if 'Exit' end
		int 21h
	READ_GUIAPI:
		LODS '.GUI'
		or
		LODS '.res'
	Render:
		CALL Graphics_dealer
		MOV GFX, out, Moniter
Section end