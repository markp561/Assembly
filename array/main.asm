; nasm -f elf32 main.asm & ld -m elf_i386 main.o

section     .data
    arr:      DD 5, 4, 3, 2, 1
    n         DB 0x0a


section     .text
    global      _start


_start:

    ; first element
    mov ecx, 2
    add [arr], '0'

    mov edx, 1
    mov ecx, arr
    mov ebx, 1

    mov eax, 4
    int 0x80

    call newline

    
    ; second element
    add [arr+4], '0'

    mov edx, 1
    mov ecx, arr+4
    mov ebx, 1

    mov eax, 4
    int 0x80
    
    call newline

    
    ; third element
    add [arr+8], '0'

    mov edx, 1
    mov ecx, arr+8
    mov ebx, 1

    mov eax, 4
    int 0x80
    
    call newline


    ; fourth element
    add [arr+12], '0'

    mov edx, 1
    mov ecx, arr+12
    mov ebx, 1

    mov eax, 4
    int 0x80
    
    call newline


    ; five element
    add [arr+16], '0'

    mov edx, 1
    mov ecx, arr+16
    mov ebx, 1

    mov eax, 4
    int 0x80
    
    call newline


    mov eax, 1
    int 0x80




newline:
    mov edx, 1
    mov ecx, n
    mov eax, 4
    int 0x80

    ret
