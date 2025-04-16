[BITS 32]
[ORG 0x7F00]
%include 'Kernel.asm'
%include 'Bootloader.asm'
Section .text
compress_data:
    mov ESI ,IN
	resb ESI_BUFFER , 200
    mov EDI out
	resb ESI_BUFFER,200
.next_byte:
    lodsb              ; AL = [ESI]
    cmp al, ' '        ; skip space
    je .next_byte
    stosb              ; store to output
    cmp al, 0
    jne .next_byte
    ret
link_libraries:
	inc LIBRARIES, compress_data
    ret
output_binary:
    all stos , NAME, EXT,
	ADD(NAME , EXT, DATA) , FILE
    ret
Section end