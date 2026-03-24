; nasm -f elf32 increment_num.asm & ld -m elf_i386 increment_num.o

section     .data
    a dd 5
    n db 0x0a

section     .text
    global      _start


_start:
    mov eax, [a]    ; move the value of a into eax register
    add eax, 1      ; add 1 to the eax register, which has the value of a
    mov [a], eax    ; write the value of the eax register back to a

    add [a], '0'    ; convert a to ascii representation by adding '0' to it, whose ascii code is 48

    mov edx, 1      ; move the length of a, which is 1 since a is a single digit, to the edx register
    mov ecx, a      ; move a to the ecx register to be printed
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

