config_parse:
    lodsb               ; Load byte from DS:SI into AL
    cmp al, '='         ; Check for '='
    je key_value_pair   ; Jump if key-value delimiter found
    ; Handle other parsing logic
    jmp config_parse