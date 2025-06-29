[BITS 32]
[ORG 0x1000]
.386
.model large
.stack large
%include "Kernel.bin"
Section .TEXT
	SEGMENT
		CMP CPU, .386, .ARM, .6502, .6800, .Z004,M1,M2,M3,M4, 
		DB CPU_TYPE, STOS 386, .ARM, .6502, .6800, .Z004,.M1,.M2,.M3,.M4,
		CMP EXT, .asm, .c, .CPP, .java, .php,
		DB CODE_TYPE .asm, .c, .CPP, .java, .php,
		CMP OPER, Windows, MACOS, Linux, MBXOS
		all CODE_TYPE, CPU_TYPE , OPER_TYPE  equ in
	end SEGMENT
	READ_RES:
		CMP FILE , .res,
			LODS .res
	RESOURCE_FILE:
		mov CODE_TYPE  , 1
		mov CPU_TYPE , 2
		mov OPER_TYPE , 3
		mov FILE , 4
		mov RESFILE , 5
	
	BINARY_PREPARE:
		PROC PREPARE
			call READ_RES,
			lea .res
			lea CODE
			mov "ELF",HEADER
			MOV DI 0,1
			MOV HEADER
		end PREPARE
		PROC GENERATE
		start:
			; Load the byte to convert
			mov al, [byte_to_convert]

			; Convert the high nibble (4 bits)
			mov ah, al
			shr ah, 4                         ; Shift high nibble to low nibble position
			and ah, 0x0F                      ; Mask to isolate lower 4 bits
			mov bl, ah                        ; Move high nibble to BL
			mov ah, [hex_chars + bl]          ; Fetch hex character for high nibble
			mov [hex_output], ah              ; Store in hex_output

			; Convert the low nibble (4 bits)
			and al, 0x0F                      ; Mask to isolate lower nibble
			mov bl, al                        ; Move low nibble to BL
			mov al, [hex_chars + bl]          ; Fetch hex character for low nibble
			mov [hex_output + 1], al          ; Store in hex_output
		end
		MAIN PROC
    ; Initialize the program
    MOV AX, @DATA
    MOV DS, AX

    ; Step 1: Open the .res file
    LEA DX, fileName      ; DS:DX points to the file name
    MOV AX, 3D02h         ; DOS function to open file (read-only)
    INT 21h               ; Call DOS interrupt
    JC FILE_ERROR         ; Jump if an error occurred
    MOV fileHandle, AX    ; Store file handle

    ; Step 2: Read the file into the buffer
    LEA DX, buffer        ; DS:DX points to the buffer
    MOV BX, fileHandle    ; BX = file handle
    MOV CX, 512           ; Max bytes to read
    MOV AH, 3Fh           ; DOS function to read file
    INT 21h               ; Call DOS interrupt
    JC FILE_ERROR         ; Jump if an error occurred
    MOV bytesRead, AX     ; AX = number of bytes read

    ; Step 3: Parse the file contents
    LEA SI, buffer        ; SI points to the buffer
PARSE_LOOP:
    CALL READ_LINE        ; Read a line (key=value)
    CMP AL, 0             ; Check if end of file
    JE END_PARSE          ; Exit loop if no more lines

    ; Parse the key-value pair
    CALL PARSE_KEY_VALUE  ; Extract key and value
    CMP BYTE PTR key, 0   ; Check if key is empty
    JE PARSE_LOOP         ; Skip to next line if empty

    ; Process specific keys
    LEA DI, key
    CMP BYTE PTR [DI], 'D','A','T','A'
    JE PROCESS_DATA       ; If key is "DATA", process it
    CMP BYTE PTR [DI], 'C','O','M',M'
    JE PROCESS_COMMAND    ; If key is "COMMAND", process it
    CMP BYTE PTR [DI], 'C','O','D','E'
    JE PROCESS_CODE       ; If key is "CODE", process it

    JMP PARSE_LOOP        ; Continue to the next line

PROCESS_DATA:
    ; Convert the value to hexadecimal
    LEA SI, value         ; Load the value to convert
    MOV AL, [SI]          ; Get the first byte of the value
    CALL CONVERT_TO_HEX   ; Convert to hex and display
    JMP PARSE_LOOP

PROCESS_COMMAND:
    ; Display the command
    LEA DX, value         ; Load the command
    MOV AH, 09h           ; DOS print string
    INT 21h
    JMP PARSE_LOOP

PROCESS_CODE:
    ; Convert the code sequence to hexadecimal
    LEA SI, value         ; Load the code sequence
CONVERT_CODE_LOOP:
    LODSB                 ; Load the next byte of the code
    CMP AL, 0             ; Check for end of string
    JE PARSE_LOOP         ; Exit if end of string
    CALL CONVERT_TO_HEX   ; Convert to hex and display
    JMP CONVERT_CODE_LOOP

END_PARSE:
    ; Step 4: Close the file
    MOV BX, FILE  ; BX = file handle
    MOV eax , 6           ; DOS function to close file
    INT 21h

    ; Exit program
    MOV AX, 4C00h
    INT 21h

FILE_ERROR
    mov si,MSG
    mov ah, 0x0E
    MSG DB "Error opening file", 0
    MOV AX, 4C01h         ; Exit with error code 1
    INT 21h

; Subroutine to read a line from the buffer
READ_LINE PROC
    mov eax, 0
    mov eax, 4 all
    mov edx, 0
    je READ_LINE ; Check if end of file
    RET
READ_LINE ENDP
NEW_RESFILE PROC
    DB SIDXIN
    MOV SIDIXN, SI , DX
    MOV IN, SIDXIN
    INT 21H
    MOV BX, SIDXIN
NEW_RESFILE ENDP
; Subroutine to parse key=value pairs
PARSE_KEY_VALUE PROC
    mov byte ptr key, 0 ; Clear key buffer
    mov byte ptr value, 0 ; Clear value buffer
    mov eax, 0
    mov eax, 4 all
    mov edx, 0
    ; Read key until '=' or end of line
    RET
PARSE_KEY_VALUE ENDP

; Subroutine to convert a byte to hexadecimal
CONVERT_TO_HEX PROC
    ; Convert high nibble
    MOV AH, AL            ; Copy AL to AH
    SHR AH, 4             ; Shift high nibble to lower 4 bits
    AND AH, 0Fh           ; Mask out unwanted bits
    MOV DL, hexChars[AH]  ; Get the hex character for the high nibble
    CALL PRINT_CHAR       ; Print the high nibble

    ; Convert low nibble
    AND AL, 0Fh           ; Mask to isolate the low nibble
    MOV DL, hexChars[AL]  ; Get the hex character for the low nibble
    CALL PRINT_CHAR       ; Print the low nibble
    RET
CONVERT_TO_HEX ENDP
Definitions:
		:SWORD DATA , edx 7
		%define edx 8 , PROCESS_DATA

MAIN ENDP
		out BX
		test BX
		int 21h
		mov  
        
        
        ,2 
		mov eax 2 , edx 6
		mov si , MSG
		mov ah, 0x0E
		MSG DB , "Compilation has finished, Finished program should open now" , 0
		mov eax 2, CPU
		mov edx, 6
        mov eax , 0
        mov edx , 0 ; Clears the Buffer
                    ; i have made a compiler that can compile and run for different CPU types and ASM only without a .res template
section end