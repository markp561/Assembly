section     .data
    a    dd  10
    b    dd 2
    temp dd 0

section     .text
    global     _start

_start:

    mov eax, [a]
    idiv [b]
    

    
    add eax, '0'
    mov edx, 1
    mov [temp], eax
    mov ecx, temp

    mov eax, 4
    int 0x80


    mov eax, 1
    int 0x80
        

