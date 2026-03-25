; nasm -f elf32 main.asm & ld -m elf_i386 main.o

section     .data
    i     dd 0
    n       db 0x0a


section     .text
    global      _start


_start:


    cmp [i], 5
    jl loop

    loop:
        add [i], '0'

        mov edx, 1
        mov ecx, i 
        mov ebx, 1

        mov eax, 4
        int 0x80

        call newline
        
        sub [i], '0'
        inc [i]
        
        cmp [i], 5
        jl loop

    mov eax, 1
    int 0x80









newline:
    mov edx, 1
    mov ecx, n
    mov eax, 4
    int 0x80

    ret
