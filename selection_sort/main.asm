; nasm -f elf32 main.asm && ld -m elf_i386 main.o

section     .data
    arr:             dd 5, 4, 3, 2, 1 
    arr_len          equ ($ - arr) / 4
    i                dd 0
    j                dd 0
    temp             dd 0
    smallest_index   dd 0
    smallest_element dd 0
    n                db 0x0a


section     .text
    global      _start

_start:

        outer_loop_begin:
            mov ebx, arr                                ; Move base address of arr into ebx
            
            mov ecx, [i]                                ; Move i, the outer loop index into ecx
            cmp ecx, arr_len                          ; Compare i, stored in ecx, to the length of the array
            jge outer_loop_end                          ; If i is greater than or equal to the length of the array, then we should exit the outer loop by jumping to outer_loop_end

            mov eax, [ebx + ecx*4]
            mov [smallest_element], eax                 ; Update smallest_element to hold the current element
            mov [smallest_index], ecx                   ; Update smallest_index to hold the current value of i, the iterator for the outer loop
            
           

            inner_loop_begin:
                mov ecx, [j]                            ; Move j, the inner loop index into ecx
                cmp ecx, arr_len                      ; Compare j, stored in ecx, to the length of the array
                jge inner_loop_end                      ; If j is greater than or equal to the length of the array, then we should exit the inner loop by jumping to inner_loop_end
     

                mov eax, [ebx + ecx*4]                  ; Move the element of arr at index j into eax
                cmp [smallest_element], eax             ; Compare the smallest element to the current element
                jle continue                            ; If the smallest element is smaller than the current element than continue
                
                mov [smallest_element], eax             ; Otherwise, we need to update the current smallest element and the index of the smallest element
                mov [smallest_index], ecx               

                continue:                           
                    inc dword [j]                       ; Increment the inner loop index, j
                    jmp inner_loop_begin                ; Jump to the start of the inner loop

            inner_loop_end:
                    
                mov ecx, [i]                            ; Move the value of i into ecx
                mov eax, [ebx + ecx*4]                  ; Move the element at index i of arr into eax
                mov [temp], eax                         ; Move the value stored in eax into temp
                mov ecx, [smallest_index]               ; Move the value of smallest_index into ecx
                mov eax, [ebx + ecx*4]                  ; Move the element at index smallest_index of arr into eax

                                                        ; Need to swap the smallest element with the element at index i
                mov ecx, [i]                            ; Move the value of i into ecx
                mov [ebx + ecx*4], eax                  ; Move the value of eax (the element at index smallest_index) into the element of arr at index i

                mov ecx, [smallest_index]               ; Move the value of smallest_index into ecx
                mov eax, [temp]                         ; Move the value of temp into eax
                mov [ebx+ ecx*4], eax                   ; Move the value stored in eax into the element at index smallest_index of arr

                inc dword [i]                           ; Increment the outer loop index, i
                mov eax, [i]                            ; Move the value of i into eax
                add eax, 1                              ; Add one to the value stored in eax, since the inner loop should step through elements after index i
                mov [j], eax                            ; Move the value stored in eax into j since we don't need to scan elements at indexes smaller than i anymore (at this point everything before i is already in the correct order)
                jmp outer_loop_begin                    ; Jump to the start of the outer loop




        outer_loop_end:
            mov [i], 0
            jmp print_array_begin


            print_array_begin:
                mov ebx, arr            ; Move base address of arr into ebx

                mov ecx, [i]            ; Move i, the index, to ecx
                cmp ecx, arr_len      ; Check if i is less than the length of the array
                jge print_array_end     ; If it is not, then end the loop, if it is then continue with the loop


                mov eax, [ebx + ecx*4]  ; Move the value of the array at index [i], stored now in ecx, to eax

                add eax, '0'            ; Add '0' to eax (only works for single digits)

                mov [temp], eax         ; Move the value stored in eax to [temp]

                mov edx, 1              ; Move the length of temp to edx
                mov ecx, temp           ; Move temp to ecx
                mov ebx, 1              ; Set the file descriptor for the program

                mov eax, 4              ; Print syscall
                int 0x80                ; Interrupt

                call newline            ; Print a newline
                
                inc dword [i]           ; Increment i
                jmp print_array_begin   ; Jump back to the start of the loop



                print_array_end:
                    mov eax, 1
                    int 0x80




newline:
    mov edx, 1
    mov ecx, n
    mov eax, 4
    int 0x80

    ret
