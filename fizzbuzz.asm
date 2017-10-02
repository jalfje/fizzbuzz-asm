; An intel-x86 assembly fizzbuzz program. Numbers for fizz, buzz, and max values are configurable
; in the .data section.

section .text
    global _start

_start:
    push ebp                    ; Store previous stackbase value on top of stack.
    mov ebp, esp                ; Store current top-of-stack as current stackbase.
    
    sub esp, 6                  ; Move the top-of-stack down 6 bytes, effectively 'allocating' that memory
    
    mov DWORD [ebp-4], 1        ; Insert the value 1 to the memory location 4 below the stackbase - this is our counter
    mov BYTE [ebp-5], 0         ; True/false whether current counter is divisible by first
    mov BYTE [ebp-6], 0         ; True/false whether current counter is divisible by second
    jmp .fizzBuzzExitCheck      ; Move to loop exit condition
    
.fizzBuzzLoop:
    
    ; check if divisible by first
    mov dx, WORD [ebp-2]        ; Move current loop variable into dividend position
    mov ax, WORD [ebp-4]
    mov bh, 0                   ; Clear upper half of BX
    mov bl, BYTE [first]        ; Move dividing value into lower half of BX
    div bx                      ; Divide the contents of AX & DX by BX, store remainder in DX
    ; Set flag to 1 if remainder is 0, or 0 otherwise.
    cmp dx, 0
    mov BYTE [ebp-5], 0
    jne .skipFirst
    mov BYTE [ebp-5], 1
    .skipFirst:
    
    ; check if divisible by second
    mov dx, WORD [ebp-2]        ; Move current loop variable into dividend position
    mov ax, WORD [ebp-4]
    mov bh, 0                   ; Clear upper half of BX
    mov bl, BYTE [second]       ; Move dividing value into lower half of BX
    div bx                      ; Divide the contents of AX & DX by BX, store remainder in DX
    ; Set flag to 1 if remainder is 0, or 0 otherwise. 
    cmp dx, 0
    mov BYTE [ebp-6], 0
    jne .skipSecond
    mov BYTE [ebp-6], 1
    .skipSecond: 
    
    ; check if both flags are set, if so, it's divisible by both
    mov al, [ebp-5]
    and al, [ebp-6]
    cmp al, 0
    jne .divBoth
    ; check if first flag is set, if so, it's divisible by first
    cmp [ebp-5], BYTE 0
    jne .divFirst
    ; check if second flag is set, if so, it's divisible by second
    cmp [ebp-6], BYTE 0
    jne .divSecond
    
    ; the 'else' case; current loop variable not divisible by any
    jmp .divNone
    
.divBoth:
	mov	eax, 4
	mov	ebx, 1
	mov	ecx, fizzbuzz
	mov	edx, fizzbuzzSz
	int 0x80
	jmp .nextLoop
    
.divFirst:
	mov	eax, 4
	mov	ebx, 1
	mov	ecx, fizz
	mov	edx, fizzSz
	int 0x80
	jmp .nextLoop
    
.divSecond:
	mov	eax, 4
	mov	ebx, 1
	mov	ecx, buzz
	mov	edx, buzzSz
	int 0x80
	jmp .nextLoop
    
.divNone:
    push DWORD [ebp-4]              ; Pass parameter by moving it to the top of the stack
    call .printNum
    add esp, 4                      ; Clear parameter
	jmp .nextLoop
    
.nextLoop:
    add DWORD [ebp-4], 1            ; increment loop
    
.fizzBuzzExitCheck:
    ; Compare to max value
    mov eax, DWORD [max]
    cmp DWORD [ebp-4], eax
    jle .fizzBuzzLoop
    
    ; Print exit message
    mov eax, 4
    mov ebx, 1
    mov ecx, exitMsg
    mov edx, exitMsgSz
    int 0x80
    
    ; Clean up stackframe
    mov esp, ebp
    pop ebp
    
    ; Exit
	mov	eax,1                       ; Moves 1 into EAX register, indicating exit on system call.
	xor	ebx,ebx                     ; Sets EBX to 0, indicating error code on exit sytem call.
	int	0x80                        ; System call with EAX==1, so exit. Exit code is EBX==0.

; Function for printing 32-bit number with arbitrary number of digits.
; Because it's a function using the C calling convention, it must be accessed via 'call', not 'jmp'.
; Number to print is the only parameter, accessible as DWORD [EBP+8].
.printNum:
    ; Create stackframe
    push ebp
    mov ebp, esp
    
    ; Prepare to divide. EDX:EAX is divisor, EBX is dividend. ECX is the number of bytes to print.
    mov eax, [ebp+8]                ; Move parameter into divisor position
    mov ebx, 0xA                    ; Divide by 10
    mov ecx, 0                      ; Clear count variable
    
    ; Push newline character.
    sub esp, 1
    mov [esp], BYTE 0xA
    inc ecx                         ; Include newline character in printing
    
    ; Loop through numbers, adding ASCII code of next-lowest digit to stack until no digits remain. 
.remainder:
    ; Increment count variable
    inc ecx                         
    ; Divide EDX:EAX by EBX==10, storing quotient in EAX and remainder in EDX. 
    mov edx, 0                      ; Clear EDX (higher bits of divisor) for 64-bit division
                                    ; Note that lower bits are in EAX, which already has the quotient
                                    ; of the previous division, or the input parameter. No need to move it. 
    div ebx                         
    ; Push contents of DL (lowest byte of remainder) as next ASCII character
    add dl, 0x30                    ; EDX holds remainder in range [0,9]. Add 48 to get ASCII code.
    sub esp, 1                      
    mov [esp], dl                   
    ; Loop again if the quotient was non-zero, i.e. there's still another digit.
    cmp eax, 0                      
    jne .remainder                  
    
    ; Print bytes starting at top of stack, until the number of bytes in ECX is reached.
    mov edx, ecx                    
    mov ecx, esp                    
    mov ebx, 1
    mov eax, 4
    int 0x80
    
    ; Clean up stackframe
    mov esp, ebp
    pop ebp
    
    ; Return with no return value
    ret

; Stored constants
section .data

first db 12 ; Number to say 'Fizz' on.
second db 15 ; Number to say 'Buzz' on.
max dd 180 ; Max value to loop to, inclusive.

fizz        db  'Fizz',0xA
fizzSz      equ $-fizz
buzz        db  'Buzz',0xA
buzzSz      equ $-buzz
fizzbuzz    db  'FizzBuzz!',0xA
fizzbuzzSz  equ $-fizzbuzz

exitMsg     db  'Fizz buzz finished. Exiting.',0xA
exitMsgSz   equ $-exitMsg

