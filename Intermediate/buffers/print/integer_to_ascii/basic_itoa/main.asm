section     .data
    a           dd 12345

section     .bss
    buffer      resb 16

section     .text
    global      _start


_start:

    mov esi, 0
    mov edi, 0
    mov eax, [a]
    mov ecx, 10

    loop1: 
        xor edx, edx
        idiv ecx
        push edx
        inc edi
        cmp eax, 0
        jne loop1
    loop2:
        cmp esi, edi
        jg end

        pop edx
        mov eax, edx
        add eax, '0'
        mov [buffer + esi], eax

        inc esi
        jmp loop2
    end: 
        
    mov [buffer+edi], 0x0A
    inc edi
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, edi
    int 0x80

    mov eax, 1
    int 0x80

