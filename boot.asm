[BITS 16]
[ORG 0x7c00]

start: 
    cli ;Clear interrupts 
    mov ax, 0x00
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00  
    sti ; Enable interrups
    mov si, msg

print:
    lodsb ;LOad byte at ds:si to AL reg and inc si
    cmp al, 0
    js done
    mov ah, 0x0E
    int 0x10
    jmp print 


msg: db 'Hello World!' , 0

done:
    cli
    hlt ;Stop the CPU Exec

times 510 - ($ - $$) db 0
dw 0xAA55; 'magic' so that it is recognized as a boot sector
