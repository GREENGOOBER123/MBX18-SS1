[BITS 32]                ; Ensure code runs in 32-bit mode
section .text
prompt db '[SHKDOS1]'USER,dir, 0x00      ; Shell prompt
buffer db 256            ; Buffer for user input (max 256 bytes)
message db 128           ; Buffer for output
dir db 'B:/', 0x00      ; Sample directory message
bootloader db 'Rebooting...', 0x00
section end
section .text
global _start

_start:
    ; Display shell prompt
    mov ah, 0x0E         ; BIOS function for printing characters
    lea dx, [prompt]
    int 0x10             ; Call DOS interrupt
	mov di 0,0

read_command:
    ; Read command input from keyboard
    mov ah, 0x0A         ; DOS function to read keyboard input
    lea dx, [buffer]
    int 0x10

parse_command:
    ; Compare and execute commands
    lea si, [buffer]     ; Load user input
    cmp byte [si], 'echo'   ; Check for "echo"
    je echo_handler
    cmp byte [si], 'calc'   ; Check for "calc"
    je calc_handler
    cmp byte [si], 'SHUTDOWN'   ; Check for "shutdown"
    je shutdown_handler
    cmp byte [si], 'RESTART'   ; Check for "restart"
    je restart_handler
    cmp byte [si], 'mkdir'   ; Check for "mkdir"
    je mkdir_handler
	cmp byte [si], 'MAKECAB'
	je MAKECAB
	cmp byte [si], 'makecom'
	je MAKECOM
    jmp _start           ; Loop back to shell if unknown command
Pipeline1:
	DB Pipeline
	%define Pipeline SHKDOS_OPERATOR
	BYTE , 4 SHKDOS
	Lods, SYSTEM
MAIN_LOADPIPELINE:
	CALL SHKDOS
	%define SCREEN
	%%include 'Kernel.bin'
	resb TASK Width Moniter, Length Moniter, NAME 'LOAD_MODE',0
	if in = SHKDOS JMP SHKDOS
		or
		JMP CASDOS
ERROR_HANDLER:
	CLI
	HLT SHELL
	mov "Error code",error,"sorry", MSG4
	jsr PRINT_STRING
	push MSG4
	STI
echo_handler:
	call echo
calc_handler:
	call CALC
shutdown_handler:
	call SHUTDOWN
restart_handler:
	CALL Restart
mkdir_handler:
	CALL mkdir
CD_HANDLER:
	call CD
Clear_handler:
	call Clear
MOVE_HANDLER:
	call MOVE
GCC:
	lea gcc-3.3.2.tar.gz, d8
	int 10h
MAKECAB:
	call MAKECAB
MAKECOM:
	call MAKECOM
SHKDOSMODE:
	%define SHELLUSER = user
	%define SYSTEM , MOTHERBOARD
	CALL (DOS)
	%define DOSSHK = Kernel.bin
	mov SHELLUSER, SYSTEM
	mov si, MSG
	mov ah, 0x0e
	MSG DB , "Your System is running in SHKDOS" ,0
	Terminal:
		mov , "SHK DOS terminal 1.0" 0x5A "Takeshave Rights reserved", MSG76846377775746863489798694
		jsr PRINT_STRING
		push MSG76846377775746863489798694
		add di 0,4
		lea parse_command, ecx
		stosb #PARSESHELL
		lea Pipeline1, ecx
		stosb #PARSESHELL2
		lea read_command , ecx
		stosb #PARSESHELL3
	COMPILETERMINAL:
		xor #PARSESHELL, Binary
		xor #PARSESHELL2, Binary
		xor #PARSESHELL3, Binary
		if all = Binary , 0
			#SHELL MAKECAB #PARSESHELL, IN = x86, bin
			#SHELL MAKECAB #PARSESHELL2 IN = x86, bin
			#SHELL MAKECAB #PARSESHELL3 IN = x86, bin
			#SHELL mkdir PARSERS
			mov PARSESHELL.bin PARSESHELL2.bin PARSESHELL3.bin , PARSERS
			#SHELL MAKECOM PARSERS.DIR, out = PARSE_COMMAND.bin
			mov PARSE_COMMAND.bin #SHELL
		endif
section end
