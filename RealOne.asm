;
; System Programming 
; Homework 1
; Student name: Sabrina Cara
; Student number: 150160914
; 

segment .data  
segment .text  
global cross_correlation_asm_full						; Declare as Global in order to use with .c code
														; Standard procedure
 				                        

cross_correlation_asm_full:								; Start the function

        push    ebp                                     ; push ebp to stack, standard procedure
        mov     ebp, esp                                ; push esp to ebp, standard procedure
        push    ecx                                     ; push ecx  to stack
        push    edi                                     ; push esi to stack
        sub     esp, 20                                 ; subtract 20 so esp can have space for all variables
        mov     dword [ebp-12], 0                      	; make value of ebp - 12 zero
														; it will serve as an index i
        jmp     LOOP1                                   ; unconditional jump
 
;; Loop 1 and Loop 2 serve to clear the output array before writing any result to it
;; This is done for safety reasons since output array can contain garbage

LOOP2:  mov     eax, dword [ebp-12]                    	; move i to accumulator
        lea     edx, [eax*4]                            ; moves and shifts at the same time
														; it will move address of where index points to edx
        mov     eax, dword [ebp+24]                     ; moves output array to accumulator
        add     eax, edx                                ; adds result to accumulator (output array)
        mov     dword [eax], 0                          ; makes that value of output array zero
        inc    dword [ebp-12]		                    ; increments index by one
             
LOOP1:  mov     eax, dword [ebp-12]                     ; move index i to accumulator
        cmp     eax, dword [ebp+28]                     ; compare value to output size
        jl      LOOP2                                   ; if i < output size jump tp loop2
        mov     dword [ebp-12], 0                       ; if i>= output size make it zero again
														; in order to use it in future loops
        jmp     LOOP3       


        
;;Loops 3,4,5,6 serve as two equivalent for loops in c. We try to traverse array 1 and array 2
;;We multiply their respective elements and add them to output[k] array
        

                            
LOOP4:  mov     eax, dword [ebp-12]                     ; move index i to acc
        mov     dword [ebp-20], eax                     ; move value of acc to another variable k
        mov     dword [ebp-8], 0                        ; make a new index for inner loop j = 0 in ebp-8
        jmp     LOOP5                                   ; unconditional jump 
        

LOOP6:  mov     eax, dword [ebp-20]                     ; move k variable to accumulator
        lea     edx, [eax*4]                            ; multiply index to 4 so in other iterations it will increase by 4 in stack
        mov     eax, dword [ebp+24]                     ; move output to accumulator
        add     eax, edx                                ; move address of index k to accumulator
        mov     edx, dword [ebp-20]                     ; move output[k] to edx
        lea     ebx, [edx*4]                            ; we take next index (incremented)
        mov     edx, dword [ebp+24]                     ; we move output[k] to edx
        add     edx, ebx                                ; we add ebx with edx 
        mov     ebx, dword [edx]                        ; we take address of index of output 
        mov     edx, dword [ebp-12]                     ; we add again output[k] to itself
        lea     ecx, [edx*4]                            ; now we take index of i
        mov     edx, dword [ebp+8]                      ; we move array one to edx
        add     edx, ecx                                ; we add index of i to edx
        mov     ecx, dword [edx]                        ; we move array_1[i] to ecx
        mov     edx, dword [ebp-8]                      ; we move j to edx as index
        mov     edi, dword [ebp+20]                     ; we move size or array_2 to edi
        sub     edi, edx                                ; we subtract them for index to be size_2 - j
        mov     edx, edi                                ; we save our new index to edx
        sub     edx, 1                        		    ; this subtracts the index with(1)
        lea     edi, [edx*4]                            ; we shift and add index by 4 in each iteration
        mov     edx, dword [ebp+16]                     ; we move array_2 to edx
        add     edx, edi                                ; we take index of array_2: [size_2-j-1] to  edx
        mov     edx, dword [edx]                        ; we move value of array_2[size_2 - j - 1] to edx
        imul    edx, ecx                                ; we multiply array_1[i] with array_2[size_2-j-1]
        add     edx, ebx                                ; we add output to edx so now we have it as
														;output[k] += arr_1[i] * arr_2[size_2 - j -1]
        mov     dword [eax], edx                        ; we move result to accumulator
        inc     dword [ebp-20]                     	    ; we increment k
        inc     dword [ebp-8]                           ; we increment j
        
LOOP5:  mov     eax, dword [ebp-8]                      ; we move j index to accumulator
        cmp     eax, dword [ebp+20]                     ; we compare it to size of array 2
        jl      LOOP6                                   ; if j < size_2 we jump to another place
        inc     dword [ebp-12]	                        ; increment i before going back to outter loop
        
LOOP3:  mov     eax, dword [ebp-12]                     ; we again move index to accumulator
        cmp     eax, dword [ebp+12]                     ; we compare index i to size of array 1
        jl      LOOP4                                   ; if i< size_1 we jump to inner for loop
        mov     dword [ebp-24], 0                       ; if i>= size_1 we break the outter for loop
														; we make the index for inner loop zero (j = 0)
        mov     dword [ebp-12], 0                       ; we make index of outter loop 0
        jmp     LOOP9   								; unconditional jump

;;Loop7,8 and 9 serve to count all non zero elements of the output array and return them                            

LOOP7:  mov     eax, dword [ebp-12]                     ; we again take index and move to acc
        lea     edx, [eax*4]                            ; we add and shift index by 4 so that it can point to next place in stack
        mov     eax, dword [ebp+24]                     ; we take output to acc
        add     eax, edx                                ; we add index i to output array
        mov     eax, dword [eax]                        ; we move output[i] to acc
        test    eax, eax                                ; we compare output[i] to itself (difference)
        jz      LOOP8                                   ; if element of output[i] is zero jump
        add     dword [ebp-24], 1                       ; if not increment i
LOOP8:  add     dword [ebp-12], 1                       ; increment counter
LOOP9:  mov     eax, dword [ebp-12]                     ; we take index i
        cmp     eax, dword [ebp+28]                     ; compare index i to output_size
        jl      LOOP7                                   ; if i< output_size jump
        mov     eax, dword [ebp-24]                     ; else move counter value to acc
														; this way we return number of non zero elements 
        add     esp, 20                                 ; decrement esp again
        pop     edi                                     ; we pop all registers used
        pop     ecx                                     ; we pop all registers used
        pop     ebp                                     ; we pop all registers used
        ret                                             ; we return and end the function

                  			


