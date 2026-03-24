; nasm -f elf32 main.asm & ld -m elf_i386 main.o

section     .data
    x dd 5
    n db 0x0a

section     .text
    global      _start


_start:

    mov [x], 7

    add [x], '0'    ; convert a to ascii representation by adding '0' to it, whose ascii code is 48

    mov edx, 1      ; move the length of a, which is 1 since a is a single digit, to the edx register
    mov ecx, x      ; move a to the ecx register to be printed
    mov ebx, 1      ; set file descriptor for the system


    ; printing the value of a, which is 6
    mov eax, 4      ; system call for printing
    int 0x80        ; interrupt 


    ; printing a newline
    call newline

    mov eax, 1      ; exit system call
    int 0x80        ; interrupt 


newline:
    mov edx, 1
    mov ecx, n
    mov eax, 4
    int 0x80

    ret
