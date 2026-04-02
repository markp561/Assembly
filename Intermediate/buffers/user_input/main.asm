section     .data
    msg1         db "Enter the array size: "
    msg1_len     equ ($ - msg1)

    msg2         db "Enter the contents of the array: ", 0x0A
    msg2_len     equ ($ - msg2)
    
    exit_msg     db "Program Ended.", 0x0A
    exit_msg_len equ ($ - exit_msg)

    arr_len      dd 0

   
    newline      db 0x0A

section     .bss
    buffer       resb 16
    array        resd 10000

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

    mov ecx, msg2
    mov eax, 4
    mov ebx, 1
    mov edx, msg2_len
    int 0x80
    
    
    mov edi, array
    xor esi, esi 

    loop:
        cmp esi, [arr_len]
        jge end
    
        mov eax, 3
        mov ebx, 0
        mov ecx, buffer
        mov edx, 16
        int 0x80

        xor eax, eax
        mov edi, buffer
        call atoi

        mov edx, esi
        imul edx, 4
        mov [array+edx], eax

        inc esi
        jmp loop
    end:


    push buffer
    push [arr_len]
    push array

    call print_array
    add esp, 12


    mov eax, [arr_len]
    dec eax
    push 0
    push array

    call quicksort
    add esp, 12
    

    push buffer
    push [arr_len]
    push array

    call print_array
    add esp, 12


    mov ecx, exit_msg
    mov eax, 4
    mov ebx, 1
    mov edx, exit_msg_len
    int 0x80
    

    mov eax, 1
    xor ebx, ebx
    int 0x80



print_array:
    push ebp
    mov ebp, esp

    mov edi, [ebp+8]            ; array
    mov ecx, [ebp+12]           ; array length
    mov edx, [ebp+16]           ; buffer

    xor esi, esi
.loop:
    cmp esi, ecx
    jge .end
    mov eax, [edi + esi*4]

    push esi                    ; preserve the counter
    push ecx                    ; preserve the array length
    push edi                    ; preserve the array
    
    mov edi, edx
    push edx
    call itoa
        
    mov ecx, eax
    mov eax, 4
    mov ebx, 1
    int 0x80
    
    pop edx
    pop edi                     ; restore the array
    pop ecx                     ; restore the array length
    pop esi                     ; restore the counter
    
    inc esi                     ; increment the counter
    jmp .loop                   ; jump to the next iteration

.end:
    pop ebp                     
    ret




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
    push esi
    push ebx
    push ecx
    push edx

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

    pop edx
    pop ecx
    pop ebx
    pop esi

    ret




partition:
    
    mov ebx, [edi + edx*4]

    mov eax, esi                       ; move current value of esi (start) into i
    dec eax                            ; decrement i
    
    mov ecx, esi                       ; move start into j
    cmp ecx, edx                       ; compare j to end
    jl .loop                           ; if j smaller than end enter loop
    jge .end                           ; else go to end of loop
   
.loop:   
    ;mov ebx, [edi + ecx*4]             ; move element of arr at index j into eax
    ;cmp ebx, [edi + edx*4]             ; compare element of arr at index j to element of arr at index end
    cmp [edi + ecx*4], ebx
    jg .continue                       ; if arr[j] > arr[end] do nothing, go to next iteration

    inc eax                            ; else i++ and swap arr[i] with arr[j]
    
    mov ebx, [edi + eax*4]             ; move ith element of arr into eax

    xchg ebx, [edi + ecx*4]
    mov [edi + eax*4], ebx             ; move the value of eax into the ith index

.continue:
    inc ecx                            ; increment j to access the next element
    cmp ecx, edx                       ; compare j to the end index
    jl .loop                           ; if j is smaller than end, jump to start of loop for the next iteration

.end:
    mov ecx, eax                   ; move i into ecx
    add ecx, 1                     ; add 1 to ecx
    

                                   ; swapping i+1 element with end element
    mov ebx, [edi + ecx*4]         ; move element of arr at index i into eax
                                   ; same xor swap as before but with edx register that contains the end index
    xchg ebx, [edi + edx*4]
    mov [edi + ecx*4], ebx         ; move eax into i+1 index of arr


    inc eax                        ; add 1 to eax
    ret                            ; return (eax will be returned)




quicksort:
    push ebp
    mov ebp, esp
    
    mov edi, [ebp+8]                   ; array
    mov esi, [ebp+12]                  ; low index
    mov edx, [ebp+16]                  ; high index

    cmp esi, edx                       ; compare esi (start) to edx (end)
    jge .base_case                     ; if start is greater than or equal to then we need to exit
    

    call partition
    mov ebx, eax
                                       ; left partition
    mov eax, ebx                       ; move the return value from partition call to edx
    dec eax                            ; decrement edx
    

    push eax                           ; high
    push esi                           ; low
    push edi                           ; array

    call quicksort                     ; call quicksort on left partition
    add esp, 12


    mov eax, ebx                       ; move the return value from partition call to esi
    inc eax                            ; increment esi
    

    push eax                           ; high
    push esi                           ; low
    push edi                           ; array

    call quicksort                     ; call quicksort on right partition
    add esp, 12
    
.base_case:                            ; in the base case we just need to exit the function
    pop ebp
    ret

