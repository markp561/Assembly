; nasm -f elf32 print_array.asm & ld -m elf_i386 print_array.o

section     .data
    arr:     dd 5, 4, 3, 2, 1 
    arr_len  dd 5
    i        dd 0
    temp     dd 0
    smallest dd 0
    n        db 0x0a


section     .text
    global      _start


_start:


    sort_array:
        mov ebx, arr
        
        mov ecx, [i]
        cmp ecx, [arr_len]
        jge swap_start
        

        mov smallest, [ebx + ecx*4]
        inc ecx
        mov eax, [ebx + ecx*4]
    
        mov ecx, [i]
        cmp [smallest], eax

            



    print_array:
        mov ebx, arr

        mov ecx, [i]
        cmp ecx, [arr_len]

        jge print_array_end 


        mov eax, [ebx + ecx*4]
        add eax, '0'

        mov [temp], eax

        mov edx, 1
        mov ecx, temp
        mov ebx, 1

        mov eax, 4
        int 0x80

        call newline
        
        inc dword [i]
        jmp print_array



    print_array_end:
        mov eax, 1
        int 0x80




newline:
    mov edx, 1
    mov ecx, n
    mov eax, 4
    int 0x80

    ret
