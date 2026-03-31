; nasm -f elf32 main.asm && ld main.o


section     .data
    a           dd 12345

section     .bss
    buffer      resb 16

section     .text
    global      _start


_start:

    mov eax, [a]
    mov edi, buffer

    call itoa
        
    mov ecx, eax
    mov eax, 4
    mov ebx, 1
    int 0x80

    mov eax, 1
    int 0x80


itoa:
    push ebx
    push ecx
    push esi

    mov ecx, 10
    xor esi, esi
  
.loop1:
    xor edx, edx
    idiv ecx
    push edx
    inc esi 
    test eax, eax
    jne .loop1

    mov eax, edi

.loop2:
    pop edx
    add dl, '0'
    mov [edi], dl
    inc edi
    dec esi
    jnz .loop2 

    mov [edi], 0x0A
    inc edi

    mov edx, edi
    sub edx, eax

    pop esi
    pop ecx
    pop ebx

    ret
