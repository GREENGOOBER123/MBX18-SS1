[BITS 32]                ; Ensure code runs in 32-bit mode
section .data
prompt db '>', 0x00      ; Shell prompt
buffer db 256            ; Buffer for user input (max 256 bytes)
message db 128           ; Buffer for output
dir db 'C:/', 0x00      ; Sample directory message
bootloader db 'Rebooting...', 0x00

section .text
global _start

_start:
    ; Display shell prompt
    mov ah, 0x0E         ; BIOS function for printing characters
    lea dx, [prompt]
    int 0x21             ; Call DOS interrupt
	mov di 0,0

read_command:
    ; Read command input from keyboard
    mov ah, 0x0A         ; DOS function to read keyboard input
    lea dx, [buffer]
    int 0x21

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
    jmp _start           ; Loop back to shell if unknown command

ERROR_HANDLER:
	CLI
	HLT SHELL
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
COMPILE_Handler:
	call COMPILE
SHKMODE:
	%define SHELLUSER = user
	%define SYSTEM , MOTHERBOARD
	CALL (DOS)
	%define DOSSHK = MSDOSSYSTEM
	mov SHELLUSER, SYSTEM
	mov si, MSG
	mov ah, 0x0e
	MSG DB , "Your System is running in SHKDOS" ,0
section end
