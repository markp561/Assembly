; comments in assembly start with a semicolon

section     .text   ; create the text section
global      _start  ; has to be declared for the linker
_start:             ; the start section begins

                    ; invoking data to .text section
    mov edx, len    ; move the length of the message to EDX
    mov ecx, msg    ; move the message to ECX

    mov ebx, 1      ; set the file descriptor for the program

                    ; print the message
    mov eax, 4      ; system call for printing is eax, 4 in x86 linux

                    ; stopping the process
    int 0x80        ; int is the abbreviation for "interrupt" -- in linux 0x80 interrupt handler is the kernel
    
                    ; exit the program
    mov eax, 1      ; exit system call in linux
    int 0x80        ; interrupt

section     .data   ; create the data section
    msg     db "Hello World", 0xa   ; declare the message -- 0xa is hex characater for new line
    len     equ $ -msg  ; assign the length of the message to another expression called len
                        ; this is done by using a pointer "$" and the "equ" statement 
