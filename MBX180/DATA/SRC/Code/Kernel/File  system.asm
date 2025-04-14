mov ah, 0x02        ; Function: Read sector(s)
mov al, 1           ; Number of sectors to read
mov ch, 0           ; Cylinder number
mov cl, 2           ; Sector number
mov dh, 0           ; Head number
mov dl, 0x80        ; Drive number (0x80 for HDD)
mov bx, buffer      ; Memory address to store the sector
int 0x13            ; BIOS Disk Service
jc error            ; Handle error if Carry Flag is set
mov si,message
mov ah,0x0E
message db error ,0
FileEntry:
    db 'FILE    TXT'  ; 8-byte name + 3-byte extension
    db 0x00           ; Attribute (read-only, hidden, etc.)
    dw 0x0002         ; Starting cluster (e.g., cluster #2)
    dd 0x00000400     ; File size (1 KB)

ReadFile:
    mov si, FileEntry       ; Load file entry address
    mov ax, [si+12]         ; Get file size
    mov cx, 0x02            ; Starting cluster
    mov bx, buffer          ; Destination in memory


ReadCluster:
	int 0x13
    ; Increment cluster, adjust buffer, and repeat until done
    loop ReadCluster