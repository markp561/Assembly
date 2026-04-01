section     .data
    msg1         db "Enter the array size: "
    msg1_len     equ ($ - msg1)

    msg2         db "Enter the contents of the array: "
    msg2_len     equ ($ - msg2)
    
    exit_msg     db "Program Ended."
    exit_msg_len equ ($ - exit_msg)

    arr_len      dd 0

section     .bss
    buffer       resb 16
    array        resd 10

section     .text
    global       _start

_start:
    
    mov ecx, msg1
    mov eax, 4
    mov ebx, 1
    mov edx, msg1_len
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 16
    int 0x80
        
    xor eax, eax
    mov edi, buffer
    call atoi
    
    mov [arr_len], eax

    ;call itoa
    
    ;mov ecx, eax
    ;mov eax, 4
    ;mov ebx, 1
    ;int 0x80
    

    mov eax, 1
    xor ebx, ebx
    int 0x80


atoi:
    movzx edx, byte [edi]
    cmp dl, 0x0A
    je .end

    imul eax, 10
    sub edx, '0'
    add eax, edx
    inc edi

    jmp atoi
.end:
    ret

itoa:
    mov ecx, 10                 ; divisor
    xor esi, esi                ; clear esi
    
    mov ebx, eax
    cmp eax, 0
    jge .loop1
    
    neg eax

.loop1:
    cdq
    idiv ecx                    ; divide edx:eax by ecx
    push edx                    ; push the remainder onto the stack
    inc esi                     ; increment the remainder counter
    test eax, eax               ; check if eax is zero
    jne .loop1                  ; if not then jump to next iteration. if it is then go to loop2

    mov eax, edi                ; this will be returned. it is the base address of the buffer

    cmp ebx, 0
    jge .loop2
    
    mov byte [edi], '-'
    inc edi

.loop2:
    pop edx                     ; pop a remainder from the stack
    add dl, '0'                 ; append a '0' to convert it to ascii
    mov [edi], dl               ; mov it into the buffer
    inc edi                     ; increment the buffer so we can append the next digit
    dec esi                     ; decrement the remainder counter
    jnz .loop2                  ; if esi is not zero then jump to next iteration. if it is then the loop is done

    mov byte [edi], 0x0A        ; append a newline character to the buffer
    inc edi                     ; increment the buffer

    mov edx, edi                ; move the address of the buffer into edx
    sub edx, eax                ; calculate length of the buffer by subtracting the current address with the base address that was previously stored in eax

    ret

